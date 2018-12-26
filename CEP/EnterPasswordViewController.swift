//
//  EnterPasswordViewController.swift
//  CEP


//
//  Created by jaya kumar on 28/11/18.
//  Copyright © 2018 jaya kumar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import JWTDecode


class EnterPasswordViewController: UIViewController {

    @IBOutlet weak var enterPasswordTextField: UITextField!
    
    @IBOutlet weak var storeBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var loginRes : NSDictionary!
        = [:]
    
    var loader: NVActivityIndicatorView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let buttonColor = UIColor(hexString: "#60e0b2"), let buttonColor2 = UIColor(hexString: "#1dcc8c")  {
            self.storeBtn.backgroundColor = UIColor.init(hexString: "#1dcc8c")
            self.storeBtn.applyGradient(colors: [buttonColor.cgColor, buttonColor2.cgColor])
            
        }
        enterPasswordTextField.draw(enterPasswordTextField.frame)
        
        errorLabel.isEnabled = true
        
        enterPasswordTextField.AddImage(direction: .Left, imageName: "", Frame: CGRect.init(x: 0, y: 0, width: 10.0, height: enterPasswordTextField.frame.height), backgroundColor: UIColor.clear)
        
        loader  = NVActivityIndicatorView(frame: CGRect.init(x: storeBtn.center.x - 30, y:  storeBtn.frame.origin.y , width: 60, height: 60), type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballSpinFadeLoader.rawValue), color: UIColor.white, padding: 10.0)
        
        
        
        self.view.addSubview(loader!)
        

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
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
    
    @IBAction func supportBtnAction(_ sender: Any) {
        
        let urlWhats = "whatsapp://send?phone=+918056764329&text=***"
        
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: characterSet){
            
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL){
                    UIApplication.shared.openURL(whatsappURL as URL)
                }
                else {
                    print("Install Whatsapp")
                    
                }
            }
        }
        
    }
    
    @IBAction func ForgetBtnAction(_ sender: Any) {
        
        ApiHelper().restRequest(url: EndPoints().resentOtp, method: "PATCH", params: ["phoneNumber": loginRes.value(forKey: "phoneNumber") as! String]) { (result) in
            
            let jsonResult: NSDictionary = result as! NSDictionary
            
            if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                
                print(responesJson)
                
                UIView.animate(withDuration: 0.01, animations: { () -> Void in
                    UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "VerifyPinViewController") as! VerifyPinViewController
                    
                    
                    nextViewController.loginRes = self.loginRes
                    
                    self.navigationController!.pushViewController(nextViewController, animated: false)
                    UIView.setAnimationTransition(UIView.AnimationTransition.flipFromRight, for: self.navigationController!.view!, cache: false)
                })
                
            }else{
                DispatchQueue.main.async(execute: {
                    print(jsonResult)
                    
                    self.alert(message: jsonResult.value(forKey: "message") as! String)
                })
            }
            
        }
        
        
    }
    
    @IBAction func proceedBtnAction(_ sender: Any) {
        
        loader?.startAnimating()
        
        storeBtn.setTitleColor(UIColor.white.withAlphaComponent(0.2), for: .normal)
        
        ApiHelper().restRequest(url: EndPoints().verifyUrl, method: "POST", params: [
            "phoneNumber": loginRes.value(forKey: "phoneNumber") as! String,
            "code": "",
            "passwordPresent": true,
            "password":enterPasswordTextField.text!
        ]) { (result) in
            
             let jsonResult: NSDictionary = result as! NSDictionary
            
            if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary{
            
            print(responesJson)
            
            
            let dict: NSDictionary = responesJson.value(forKey: "tokens") as! NSDictionary
            
            
            
            UserDefaults.standard.set(dict.value(forKey: "token") as! String , forKey: "Oic-Auth")
                
                do{
                    let jwt = try decode(jwt:UserDefaults.standard.value(forKey: "Oic-Auth")! as! String )
                    
                let jwtValue = jwt.body as NSDictionary
                    
                    UserDefaults.standard.set(jwtValue.value(forKey: "userId")!, forKey: "userId")
                    
                }catch{
                    
                    print("error")
                    
                }
            
            UserDefaults.standard.set(dict.value(forKey: "refreshToken") as! String, forKey: "Oic-ref")
            
            if responesJson.value(forKey: "showIndustryScreen") as! Int == 1{
                
                DispatchQueue.main.async(execute: {
                    
                    self.storeBtn.setTitleColor(UIColor.white, for: .normal)
                    
                    self.loader?.stopAnimating()
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "IndustryViewController") as! IndustryViewController
                    
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                })
                
            }else{
                  DispatchQueue.main.async(execute: {
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.storeBtn.setTitleColor(UIColor.white, for: .normal)
                        
                        self.loader?.stopAnimating()
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        
                       self.navigationController?.pushViewController(nextViewController, animated: true)
                        
                    })
                    
                })
                }
            }else{
                 DispatchQueue.main.async(execute: {
                    
                   self.loader?.stopAnimating()
                    
                self.enterPasswordTextField.layer.borderColor = UIColor.red.cgColor
                    
                
                self.enterPasswordTextField.layer.borderWidth = 1.0
                
                self.enterPasswordTextField.layer.masksToBounds = true
                
                self.errorLabel.isHidden = false
               
                self.errorLabel.text = "Wrong Password!"
                    
                self.enterPasswordTextField.shake()
                    
                    self.loader?.stopAnimating()
                    
                    self.storeBtn.setTitleColor(UIColor.white, for: .normal)
                    
                })
        
            }
       
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension EnterPasswordViewController : UITextFieldDelegate{
    
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
            
            errorLabel.isHidden = true
            
        }
        
        if (textField.text?.count)! > 0 {
            
            textField.font = UIFont.init(name:"Roboto-Light", size: 16)
            
        }else{
            textField.font = UIFont.init(name:"Roboto-Light", size: 12)
        }
        
        return true
    }
    
}
