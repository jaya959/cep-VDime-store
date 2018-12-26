//
//  SetPasswordViewController.swift
//  CEP
//
//  Created by jaya kumar on 10/11/18.
//  Copyright © 2018 jaya kumar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SetPasswordViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    @IBOutlet weak var proceedBtn: UIButton!
    
    @IBOutlet weak var setPwdErrorLabel: UILabel!
    
    var isalpha: Bool!
    
    @IBOutlet weak var retypePwdErrorLabel: UILabel!
    
    var loader: NVActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPwdErrorLabel.isHidden = true
        
        retypePwdErrorLabel.isHidden = true
        
        if let buttonColor = UIColor(hexString: "#60e0b2"), let buttonColor2 = UIColor(hexString: "#1dcc8c")  {
            self.proceedBtn.backgroundColor = UIColor.init(hexString: "#1dcc8c")
            self.proceedBtn.applyGradient(colors: [buttonColor.cgColor, buttonColor2.cgColor])
            
        }
        
        passwordTextField.draw(passwordTextField.frame)
        
        retypePasswordTextField.draw(retypePasswordTextField.frame)
        
        
        retypePasswordTextField.AddImage(direction: .Left, imageName: "", Frame: CGRect.init(x: 0, y: 0, width: 10.0, height: retypePasswordTextField.frame.height), backgroundColor: UIColor.clear)
        
      passwordTextField.AddImage(direction: .Left, imageName: "", Frame: CGRect.init(x: 0, y: 0, width: 10.0, height: passwordTextField.frame.height), backgroundColor: UIColor.clear)
        
        loader  = NVActivityIndicatorView(frame: CGRect.init(x: 0, y:  0, width: 60, height: 60), type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballSpinFadeLoader.rawValue), color: UIColor.white, padding: 10.0)
        
        
       
        self.view.addSubview(loader!)
        
        
//        let TickImageView = UIImageView(frame: CGRect.init(x: passwordTextField.frame.width - 30, y:10, width: 30, height: 30))
//        TickImageView.image = UIImage.init(named: "Tick")
//
//        passwordTextField.rightView = TickImageView
//        passwordTextField.rightViewMode = UITextField.ViewMode.always
//
//
//
//        let TickImageView2 = UIImageView(frame: CGRect.init(x: passwordTextField.frame.width - 30, y:10, width: 30, height: 30))
//
//        TickImageView2.image = UIImage.init(named: "Tick")
//
//        retypePasswordTextField.rightView = TickImageView2
//        retypePasswordTextField.rightViewMode = UITextField.ViewMode.always


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
    
    @IBAction func skipBtnAction(_ sender: Any) {
        
        DispatchQueue.main.async(execute: {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "IndustryViewController") as! IndustryViewController
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        })
        
    }
    
    @IBAction func setPasswordBtnAction(_ sender: Any) {
        if passwordTextField.text == retypePasswordTextField.text && passwordTextField.text != "" && retypePasswordTextField.text  != "" && self.setPwdErrorLabel.text == "strong"{
            
            loader?.startAnimating()
            
            ApiHelper().postRequest(url: EndPoints().setPassword, method: "", params: [
                "password":retypePasswordTextField.text!
                
            ]) { (result) in
                
                print(result)
                 let jsonResult: NSDictionary = (result as? NSDictionary)!
                
            if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                
                print(responesJson)
                
                DispatchQueue.main.async(execute: {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "IndustryViewController") as! IndustryViewController
                    
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                    
                })
            }else{
                self.alert(message: jsonResult.value(forKey: "message") as! String)
                }
            
            }
//        ApiHelper().restRequest(url: EndPoints().setPassword, method: "POST", params: [
//            "password":retypePasswordTextField.text!
//        ]) { (result) in
//
//            print(result)
//
//             if let responesJson: NSDictionary = result.value(forKey: "data") as? NSDictionary {
//
//                print(responesJson)
//
//            DispatchQueue.main.async(execute: {
//
//                if  self.setPwdErrorLabel.text == "strong" {
//
//                    self.loader?.stopAnimating()
//
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "IndustryViewController") as! IndustryViewController
//
//                self.present(nextViewController, animated: true, completion: nil)
//                }
//                else{
//
//                    self.loader?.stopAnimating()
////
//
//                }
//            })
//            }
//
//            }
        }else{
            loader?.stopAnimating()
//            if retypePasswordTextField.text  == ""{
//
//            self.retypePasswordTextField.layer.borderColor = UIColor.red.cgColor
//
//            self.retypePasswordTextField.shake()
//
//            self.retypePasswordTextField.layer.borderWidth = 1.0
//
//            self.retypePasswordTextField.layer.masksToBounds = true
//
//            self.retypePasswordTextField.isHidden = false
//
//            self.retypePwdErrorLabel.text = "Password Doesen't match"
//
//            self.retypePwdErrorLabel.textColor = UIColor.red
//            }
            if passwordTextField.text  == ""{
                
                self.passwordTextField.layer.borderColor = UIColor.red.cgColor
                
                self.passwordTextField.shake()
                
                self.passwordTextField.layer.borderWidth = 1.0
                
                self.passwordTextField.layer.masksToBounds = true
                
                self.passwordTextField.isHidden = false
                
                self.setPwdErrorLabel.text = "Empty text"
                
                self.setPwdErrorLabel.textColor = UIColor.red
                
            }
            
            if passwordTextField.text != retypePasswordTextField.text && self.setPwdErrorLabel.text != "strong" {
                
                self.retypePasswordTextField.layer.borderColor = UIColor.red.cgColor
                
                self.retypePasswordTextField.shake()
                
                self.retypePasswordTextField.layer.borderWidth = 1.0
                
                self.retypePasswordTextField.layer.masksToBounds = true
                
                self.retypePwdErrorLabel.isHidden = false
                
                self.retypePwdErrorLabel.text = "Password Doesen't match"
                
                self.retypePwdErrorLabel.textColor = UIColor.red
           
            }else{
                
                self.retypePasswordTextField.layer.borderColor = UIColor.red.cgColor
                
                self.retypePasswordTextField.shake()
                
                self.retypePasswordTextField.layer.borderWidth = 1.0
                
                self.retypePasswordTextField.layer.masksToBounds = true
                
                self.retypePwdErrorLabel.isHidden = false
                
                self.retypePwdErrorLabel.text = "Password Doesen't match"
                
                self.retypePwdErrorLabel.textColor = UIColor.red
                
            }
            
        }
        
    }
    @IBAction func showPasswordBtnAction(_ sender: Any) {
        
        
        if retypePasswordTextField.isSecureTextEntry && passwordTextField.isSecureTextEntry{
            
            retypePasswordTextField.isSecureTextEntry = false
            passwordTextField.isSecureTextEntry = false
        }else{
            
            retypePasswordTextField.isSecureTextEntry = true
            passwordTextField.isSecureTextEntry = true
            
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

extension SetPasswordViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        textField.resignFirstResponder()
        
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let letters = NSCharacterSet.letters
        
        
        
        setPwdErrorLabel.isHidden = false
        
        let islength: Bool!
        //  let ischaracters: Bool!
        
        let range = passwordTextField.text?.rangeOfCharacter(from: letters)
        
        // range will be nil if no letters is found
        if let test = range {
            print("letters found")
            
            let numberCharacters = NSCharacterSet.decimalDigits
            
            if passwordTextField.text?.rangeOfCharacter(from: numberCharacters) != nil
            { print("String contains numbers")
                
                print(test)
                
                self.isalpha = true
                
            }
            
            
        }else{
            
            self.isalpha = false
            
        }
        
        
        if (passwordTextField.text?.count)! >= 6{
            print("length correct")
            
            islength = true
        }else{
            
            islength = false
            
        }
        
        //        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        //        if textField.text?.rangeOfCharacter(from: characterset.inverted) != nil {
        //            print("correct contains special characters")
        //
        //            ischaracters = true
        //        }else{
        //
        //            ischaracters = false
        //        }
        
        if islength && isalpha {
            
            self.passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
            
            setPwdErrorLabel.text = "strong"
            
            setPwdErrorLabel.textColor = UIColor.appDarkGreenColor
            
        }else{
            setPwdErrorLabel.text = "Password not strong! use atleast one number"
            
          
            
            self.passwordTextField.layer.borderWidth = 1.0
            
            self.passwordTextField.layer.masksToBounds = true
            
            if let textColor = UIColor(hexString: "#e1b81f"){
                setPwdErrorLabel.textColor = textColor
                
                passwordTextField.layer.borderColor = textColor.cgColor
            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text == "" {
            
            textField.layer.borderColor = UIColor.clear.cgColor
            
            textField.layer.borderWidth = 1.0
            
            textField.layer.masksToBounds = true
            
            textField.draw(textField.frame)
            
            self.retypePwdErrorLabel.isHidden = true
            
        }
        
        let letters = NSCharacterSet.letters
        
       
        
        setPwdErrorLabel.isHidden = false
        
        let islength: Bool!
        //  let ischaracters: Bool!
        
        let range = passwordTextField.text?.rangeOfCharacter(from: letters)
        
        // range will be nil if no letters is found
        if let test = range {
            print("letters found")
        
            let numberCharacters = NSCharacterSet.decimalDigits
            
            if passwordTextField.text?.rangeOfCharacter(from: numberCharacters) != nil
            { print("String contains numbers")
                
                print(test)
                
                self.isalpha = true
                
            }
            
            
        }else{
            
            self.isalpha = false
            
        }
        
        
        if (passwordTextField.text?.count)! >= 6{
            print("length correct")
            
            islength = true
        }else{
            
            islength = false
            
        }
        
        //        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        //        if textField.text?.rangeOfCharacter(from: characterset.inverted) != nil {
        //            print("correct contains special characters")
        //
        //            ischaracters = true
        //        }else{
        //
        //            ischaracters = false
        //        }
        
        if islength && isalpha {
            
            setPwdErrorLabel.text = "strong"
            self.passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
            
            setPwdErrorLabel.textColor = UIColor.appDarkGreenColor
            
        }else{
            
            self.passwordTextField.layer.borderWidth = 1.0
            
            self.passwordTextField.layer.masksToBounds = true
            setPwdErrorLabel.text = "Password not strong! use atleast one number"
            
            if let textColor = UIColor(hexString: "#e1b81f"){
                setPwdErrorLabel.textColor = textColor
                 self.passwordTextField.layer.borderColor = textColor.cgColor
            }
        }
        
        if (textField.text?.count)! > 0 {
            
            textField.font = UIFont.init(name:"Roboto-Light", size: 16)
            
        }else{
            textField.font = UIFont.init(name:"Roboto-Light", size: 12)
        }
        
        return true
    }
}
