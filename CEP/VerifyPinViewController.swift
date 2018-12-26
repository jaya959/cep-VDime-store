//
//  VerifyPinViewController.swift
//  CEP
//
//  Created by jaya kumar on 10/11/18.
//  Copyright © 2018 jaya kumar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import JWTDecode


class VerifyPinViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var verifyTextField: UITextField!
    @IBOutlet weak var verifyOtpBtn: UIButton!
    
    @IBOutlet weak var resendBtn: UIButton!
    
    @IBOutlet weak var timerErrorlabel: UILabel!
    @IBOutlet weak var textErrorLabel: UILabel!
    var loginRes : NSDictionary!
        = [:]
    
    var counter = 30
    
    var timer = Timer()
     var loader: NVActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let buttonColor = UIColor(hexString: "#60e0b2"), let buttonColor2 = UIColor(hexString: "#1dcc8c")  {
            self.verifyOtpBtn.backgroundColor = UIColor.init(hexString: "#1dcc8c")
            self.verifyOtpBtn.applyGradient(colors: [buttonColor.cgColor, buttonColor2.cgColor])
            
        }
        
        verifyTextField.draw(verifyTextField.frame)
        
        textErrorLabel.isHidden = true
        timerErrorlabel.isHidden = true
        
         verifyTextField.AddImage(direction: .Left, imageName: "", Frame: CGRect.init(x: 0, y: 0, width: 10.0, height: verifyTextField.frame.height), backgroundColor: UIColor.clear)
        
         timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
        
        
        loader  = NVActivityIndicatorView(frame: CGRect.init(x: verifyOtpBtn.center.x - 30, y:  verifyOtpBtn.frame.origin.y , width: 60, height: 60), type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballSpinFadeLoader.rawValue), color: UIColor.white, padding: 10.0)
      
        self.view.addSubview(loader!)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        
        //loader?.stopAnimating()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey:kCATransition)
        let _ = navigationController?.popViewController(animated: false)
        
    }
    @IBAction func loginBtnAction(_ sender: Any) {
        
        loader?.startAnimating()
        
        verifyOtpBtn.setTitleColor(UIColor.white.withAlphaComponent(0.2), for: .normal)
        
        let parameters = ["phoneNumber":loginRes.value(forKey: "phoneNumber") as! String,
                          "code":verifyTextField.text!,
                          "passwordPresent":false,
                          "password":"testgggg"] as [String : Any]

        //create the url with URL
        let url = URL(string: EndPoints().verifyUrl)! //change the url

        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    
                    let jsonResult: NSDictionary = json as NSDictionary
                    
                    
                    if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                        
                        print(responesJson)
                        
                        
                        let dict: NSDictionary = responesJson.value(forKey: "tokens") as! NSDictionary
                        
                        UserDefaults.standard.set(dict.value(forKey: "token") as! String , forKey: "Oic-Auth")
                        
                        UserDefaults.standard.set(dict.value(forKey: "refreshToken") as! String, forKey: "Oic-ref")
                        
                        do{
                            let jwt = try decode(jwt:UserDefaults.standard.value(forKey: "Oic-Auth")! as! String )
                            
                            let jwtValue = jwt.body as NSDictionary
                            
                            UserDefaults.standard.set(jwtValue.value(forKey: "userId")!, forKey: "userId")
                            
                            print(jwtValue)
                            
                        }catch{
                            
                            print("error")
                            
                        }
                        
                        DispatchQueue.main.async(execute: {
                            
                            self.loader?.stopAnimating()
                            
                            self.verifyOtpBtn.setTitleColor(UIColor.white, for: .normal)
                            
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SetPasswordViewController") as! SetPasswordViewController
                            
                            
                            self.navigationController?.pushViewController(nextViewController, animated: true)
                            
                        })
                        
                        
                        
                    }else {
                        
                        DispatchQueue.main.async(execute: {
                            
                            self.loader?.stopAnimating()
                            
                            self.verifyOtpBtn.setTitleColor(UIColor.white, for: .normal)
                            
                            self.verifyTextField.layer.borderColor = UIColor.red.cgColor
                            
                            self.verifyTextField.layer.borderWidth = 1.0
                            
                            self.verifyTextField.layer.masksToBounds = true
                            
                            self.textErrorLabel.isHidden = false
                            
                            self.textErrorLabel.text = "Wrong OTP!"
                            
                            self.verifyTextField.shake()
                            
                        })
                    }
                    // handle json...
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()

        


//        ApiHelper().restRequest(url: EndPoints().verifyUrl, method: "POST", params: [
//            "phoneNumber": loginRes.value(forKey: "phoneNumber") as! String ,
//            "code": verifyTextField.text ?? "",
//            "passwordPresent":false,
//            "password":"test"
//
//        ]) { (result) in
//
//            let jsonResult: NSDictionary = (result as? NSDictionary)!
//
//
//            if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
//
//               print(responesJson)
//
//
//                let dict: NSDictionary = responesJson.value(forKey: "tokens") as! NSDictionary
//
//                UserDefaults.standard.set(dict.value(forKey: "token") as! String , forKey: "Oic-Auth")
//
//                UserDefaults.standard.set(dict.value(forKey: "refreshToken") as! String, forKey: "Oic-ref")
//
//                DispatchQueue.main.async(execute: {
//
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SetPasswordViewController") as! SetPasswordViewController
//
//
//                    self.navigationController?.pushViewController(nextViewController, animated: true)
//
//                })
//
//
//
//            }else {
//
//                DispatchQueue.main.async(execute: {
//
//                self.verifyTextField.layer.borderColor = UIColor.red.cgColor
//
//                self.verifyTextField.layer.borderWidth = 1.0
//
//                self.verifyTextField.layer.masksToBounds = true
//
//                self.textErrorLabel.isHidden = false
//
//                self.textErrorLabel.text = "Error Password"
//
//                })
//            }
//            }
        
        }
    
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        ApiHelper().restRequest(url: EndPoints().cancelApi, method: "PATCH", params: [
            "phoneNumber": loginRes.value(forKey: "phoneNumber") as! String
        ]) { (result) in
            
            print(result)
            
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resendOtpBtnAction(_ sender: Any) {
        
        if counter == 30 {
            
            
            ApiHelper().restRequest(url: EndPoints().resentOtp, method: "PATCH", params: [
                "phoneNumber": loginRes.value(forKey: "phoneNumber") as! String
            ]) { (result) in
                
                print(result)
                
                let jsonResult: NSDictionary = (result as? NSDictionary)!
                
                 if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                    print(responesJson)
                    DispatchQueue.main.async {
                        
                        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
               
                    }
                    
                 }else{
                      self.alert(message: "Wait until timer ends")
                }
            }
            
        }else{
            
            self.alert(message: "Wait until timer ends")

        }
        
        
        
    }
    @objc func updateCounter() {
        //you code, this is an example
        if counter > 0 {
            
            
            print("Sending OTP in : \(counter) Sec")
            
            timerLabel.text = "Sending OTP in : \(counter) Sec"
            
            counter -= 1
        }else{
            
            timer.invalidate()
            counter = 30
             timerLabel.text = "Sending OTP in : 0 Sec"
            timerErrorlabel.isHidden = false
            
            timerErrorlabel.text = "Did not receive our SMS?"
            
            UIView.animate(withDuration: 0.6,
                           animations: {
                            self.resendBtn.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.6) {
                                self.resendBtn.transform = CGAffineTransform.identity
                            }
            })
            
        }
    }

}

extension VerifyPinViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()

        return true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text == "" {
            
            textField.layer.borderColor = UIColor.clear.cgColor
            
            textField.layer.borderWidth = 1.0
            
            textField.layer.masksToBounds = true
            
            textField.draw(textField.frame)
            
            textErrorLabel.isHidden = true
            
        }
        
        if (textField.text?.count)! > 0 {
            
            textField.font = UIFont.init(name:"Roboto-Light", size: 16)
            
        }else{
            textField.font = UIFont.init(name:"Roboto-Light", size: 12)
        }
        
        return true
    }
    
}
