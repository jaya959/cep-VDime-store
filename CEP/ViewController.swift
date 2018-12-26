//
//  ViewController.swift
//  CEP
//
//  Created by jaya kumar on 09/11/18.
//  Copyright © 2018 jaya kumar. All rights reserved.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView

class ViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var contryTextField: UITextField!
    var loader: NVActivityIndicatorView?
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        ApiHelper().getRequest(url: "https://dev.oicapps.com/api/v1/cep/templates/search?name=digitalBill", method: "GET", params: [:]) { (result) in

            print(result)


        }
        
//        let window = UIApplication.shared.keyWindow!
//        let v = UIView(frame: window.bounds)
//        window.addSubview(v);
//        v.backgroundColor = UIColor.black
       
       loader  = NVActivityIndicatorView(frame: CGRect.init(x: loginBtn.center.x - 30, y:  loginBtn.frame.origin.y - 50, width: 60, height: 60), type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballSpinFadeLoader.rawValue), color: UIColor.white, padding: 10.0)
        
        
        self.view.addSubview(loader!)
        
        let flagView = UIView(frame: CGRect.init(x:  0, y: 0, width: 30
            , height: 20))
        
        let flagImageView = UIImageView(frame: CGRect.init(x:  flagView.frame.origin.x + 5, y:  flagView.frame.origin.y, width: 30, height: 20))
        
        flagImageView.contentMode = .scaleAspectFill
        flagView.addSubview(flagImageView)
        
        flagImageView.image = UIImage.init(named: "flag")
        
       // flagImageView.backgroundColor = UIColor.yellow
        
        flagView.backgroundColor = UIColor.clear
        contryTextField.leftView = flagView
        contryTextField.leftViewMode = UITextField.ViewMode.always
        
        loginTextField.tintColor = UIColor.green
        loginTextField.draw(loginTextField.frame)
        contryTextField.draw(contryTextField.frame)
        errorLabel.isHidden = true
        
        
        loginTextField.AddImage(direction: .Left, imageName: "", Frame: CGRect.init(x: 0, y: 0, width: 10.0, height: loginTextField.frame.height), backgroundColor: UIColor.clear)
        
        
        let startPosition = loginTextField.position(from: loginTextField.beginningOfDocument, offset: 3)
        let endPosition = loginTextField.position(from: loginTextField.beginningOfDocument, offset: 7)
        
        if startPosition != nil && endPosition != nil {
            loginTextField.selectedTextRange = loginTextField.textRange(from: startPosition!, to: endPosition!)
        }
        
        loginTextField.inputAccessoryView = accessoryView()
        
        loginTextField.inputAccessoryView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)

        
        if let buttonColor = UIColor(hexString: "#60e0b2"), let buttonColor2 = UIColor(hexString: "#1dcc8c")  {
            self.loginBtn.backgroundColor = UIColor.init(hexString: "#1dcc8c")
            self.loginBtn.applyGradient(colors: [buttonColor.cgColor, buttonColor2.cgColor])
        
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        loader?.stopAnimating()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
   
    }
    
    func accessoryView() -> UIView {
        
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        let doneButton = UIButton()
        doneButton.frame = CGRect(x: self.view.frame.width - 80, y: 7, width: 60, height: 30)
        doneButton.backgroundColor = UIColor.clear
        doneButton.setTitle("Done", for: .normal)
       doneButton.setTitleColor(UIColor.red, for: .normal)
        
        doneButton.addTarget(self, action: #selector(ViewController.loginBtnAction(_:)), for: .touchUpInside)
        view.addSubview(doneButton)
        
        return view
        
    }


    @IBAction func supportBtnAction(_ sender: Any) {
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//
//        self.navigationController?.pushViewController(nextViewController, animated: true)
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
    @IBAction func loginBtnAction(_ sender: Any) {
        
        let remove = loginTextField.text!
      
        if loginTextField.text?.count == 10{
            
            loader?.startAnimating()
            
            loginBtn.setTitleColor(UIColor.white.withAlphaComponent(0.2), for: .normal)
        
            ApiHelper().restRequest(url: EndPoints().registerUserUrl, method: "POST", params: ["phoneNumber": "91" + remove]) { (result) in
                

                
                if  let jsonResult: NSDictionary = result as? NSDictionary {
            
            if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
            
            print(responesJson)
            
            if responesJson.value(forKey: "passwordPresent") as! Bool == false {

            
                DispatchQueue.main.async(execute: {

                    self.loginTextField.resignFirstResponder()
                    
                    self.loader?.stopAnimating()
                    
                     self.loginBtn.setTitleColor(UIColor.white, for: .normal)
                        
                    UIView.animate(withDuration: 0.01, animations: { () -> Void in
                        UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
                  
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "VerifyPinViewController") as! VerifyPinViewController
                        
                        
                        nextViewController.loginRes = responesJson
                        
                        self.navigationController!.pushViewController(nextViewController, animated: false)
                        UIView.setAnimationTransition(UIView.AnimationTransition.flipFromRight, for: self.navigationController!.view!, cache: false)
                    })
                    
                })
            }else{
                DispatchQueue.main.async(execute: {
                    
                    self.loginTextField.resignFirstResponder()
                    
                    self.loader?.stopAnimating()
                    
                    self.loginBtn.setTitleColor(UIColor.white, for: .normal)

                    
                    UIView.animate(withDuration: 0.01, animations: { () -> Void in
                        UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EnterPasswordViewController") as! EnterPasswordViewController
                        
                        
                        nextViewController.loginRes = responesJson
                        
                        self.navigationController!.pushViewController(nextViewController, animated: false)
                        UIView.setAnimationTransition(UIView.AnimationTransition.flipFromRight, for: self.navigationController!.view!, cache: false)
                    })
            
                })
               }
                }else{
                      DispatchQueue.main.async(execute: {
                    print(jsonResult)
                        self.loader?.stopAnimating()
                        self.loginBtn.setTitleColor(UIColor.white, for: .normal)
                    self.alert(message: jsonResult.value(forKey: "message") as! String)
                      })
                }
                
                }else{
                    
                     self.alert(message:"internet")
                    
                }
            }
        }else{
            loader?.stopAnimating()
            
            
            if loginTextField.text?.count != 10{
                
                loginTextField.layer.borderColor = UIColor.red.cgColor
                
                loginTextField.layer.borderWidth = 1.0
                
                loginTextField.layer.masksToBounds = true
                
                errorLabel.isHidden = false
                
                errorLabel.text = "Phone Number is Not Valid"
                
            }else if(loginTextField.text?.count == 0){
                
                loginTextField.layer.borderColor = UIColor.clear.cgColor
                
                loginTextField.layer.borderWidth = 1.0
                
                loginTextField.layer.masksToBounds = true
                
                errorLabel.isHidden = true
                
            }
            
            loginTextField.shake()
            
        
        }
        
    }
 
    @IBAction func forgetPasswordBtnAction(_ sender: Any) {
        
         if loginTextField.text?.count == 10{
        ApiHelper().restRequest(url: EndPoints().resentOtp, method: "PATCH", params: ["phoneNumber": "91" + loginTextField.text! ]) { (result) in
            
            let jsonResult: NSDictionary = result as! NSDictionary
            
            if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                
                print(responesJson)
                DispatchQueue.main.async(execute: {

                UIView.animate(withDuration: 0.01, animations: { () -> Void in
                    UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "VerifyPinViewController") as! VerifyPinViewController
                    
                
                    nextViewController.loginRes = ["phoneNumber":self.loginTextField.text ?? "" , "passwordPresent" : false]
                    
                    self.navigationController!.pushViewController(nextViewController, animated: false)
                    UIView.setAnimationTransition(UIView.AnimationTransition.flipFromRight, for: self.navigationController!.view!, cache: false)
                })
                })
                
            }else{
                DispatchQueue.main.async(execute: {
                    print(jsonResult)
                    
                    self.alert(message: jsonResult.value(forKey: "message") as! String)
                })
            }
            
        }
         }else{
            
            if loginTextField.text?.count != 10{
                
                loginTextField.layer.borderColor = UIColor.red.cgColor
                
                loginTextField.layer.borderWidth = 1.0
                
                loginTextField.layer.masksToBounds = true
                
                errorLabel.isHidden = false
                
                errorLabel.text = "Phone number is not Valid!"
                
            }else if(loginTextField.text?.count == 0){
                
                loginTextField.layer.borderColor = UIColor.clear.cgColor
                
                loginTextField.layer.borderWidth = 1.0
                
                loginTextField.layer.masksToBounds = true
                
                errorLabel.isHidden = true
                
            }
            
            loginTextField.shake()
            
        }
        
        
        
    }
}

extension ViewController : UITextFieldDelegate {
   
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
            loginBtn.setTitleColor(UIColor.white, for: .normal)
            
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



