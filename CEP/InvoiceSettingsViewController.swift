//
//  InvoiceSettingsViewController.swift
//  CEP
//
//  Created by jaya kumar on 12/12/18.
//  Copyright © 2018 jaya kumar. All rights reserved.
import UIKit
import iOSDropDown
import Alamofire

protocol InvoiceSettingsDelegete: class {
    func startApi()
    
}

class InvoiceSettingsViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var strenthLabel: UILabel!
    @IBOutlet weak var scrollingView: UIScrollView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var taxTypeBtn: UIButton!
    
    @IBOutlet weak var gstTextField: UITextField!
    
    @IBOutlet weak var prefixTextTextField: UITextField!
    
    @IBOutlet weak var taxTypeDropDown: DropDown!
    
    @IBOutlet weak var bottomView: UIView!
    
    weak var delegete: InvoiceSettingsDelegete?
    
    var invoiceIdValue : Int!
    
    var taxArray:[TaxType]!
    
    var taxValueArray : [String] = []
    
    var isimageUploaded : Bool!
    
    var istaxTypeUpdated : Bool!
    
   
    var Indvalue = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomView.isHidden = true
        
        isimageUploaded = false
        istaxTypeUpdated = false
        
        strenthLabel.text = "Business Strength 0X1F389"
        
        errorLabel.text = "Your information can help us serve you better"
        
        completeLabel.text = "0-10 % Complete"
        
        if let backColor = UIColor(hexString: "#D2925A"){
            
            
            errorLabel.textColor = backColor
            
            progressView.progress = 0.15
            
            progressView.progressTintColor = backColor
            
        }
        
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)

        
        for value in taxArray{
            
            taxValueArray.append(value.title!)
        }
        
        bottomView.addBorder(toEdges: [.top], color:UIColor.appDarkGreenColor , thickness: 1)
        
        self.taxTypeDropDown.optionArray = self.taxValueArray
        
        taxTypeBtn.layer.borderColor = UIColor.appDarkGreenColor.cgColor
        taxTypeBtn.layer.borderWidth = 1.0
        taxTypeBtn.layer.masksToBounds = true
        
        
        taxTypeDropDown.didSelect{(selectedText , index ,id) in
            
            if let buttonColor2 = UIColor(hexString: "#3A7BD5"){
                
                self.istaxTypeUpdated = true
                
                self.progressViewSetup(value: 25, isadded: true)
                
                if self.istaxTypeUpdated == true  && self.isimageUploaded == true  && self.gstTextField.text != "" && self.prefixTextTextField.text != ""{
                    self.Indvalue = 75
                    self.progressViewSetup(value: 25 , isadded: true)
                    
                }else{
                    self.bottomView.isHidden = true
                }
                
                self.taxTypeBtn.backgroundColor = buttonColor2
                
                self.taxTypeBtn.setTitle(selectedText, for: .normal)
                
                self.taxTypeBtn.layer.borderColor = UIColor.clear.cgColor
                
                self.taxTypeBtn.setTitleColor(UIColor.white, for: .normal)

            }
            
        }
        
        gstTextField.AddImage(direction: .Left, imageName: "", Frame: CGRect.init(x: 0, y: 0, width: 10.0, height: gstTextField.frame.height), backgroundColor: UIColor.clear)
        
        prefixTextTextField.AddImage(direction: .Left, imageName: "", Frame: CGRect.init(x: 0, y: 0, width: 10.0, height: prefixTextTextField.frame.height), backgroundColor: UIColor.clear)
        
        
        if let navigationBar = self.navigationController?.navigationBar {
            let gradient = CAGradientLayer()
            var bounds = navigationBar.bounds
            bounds.size.height += UIApplication.shared.statusBarFrame.size.height
            gradient.frame = bounds
            
            if let buttonColor = UIColor(hexString: "#00D2FF"), let buttonColor2 = UIColor(hexString: "#3A7BD5")  {
                
                gradient.colors = [buttonColor2.cgColor,buttonColor.cgColor]
                
            }
            gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.1, y: 0.5)
            
            if let image = self.getImageFrom(gradientLayer: gradient) {
                navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
            }
            
            
        }
        let logoutButton:UIBarButtonItem = UIBarButtonItem(title:"Invoice Settings",
                                                           style:UIBarButtonItem.Style.plain,
                                                           target:self,
                                                           action:nil)
        self.navigationItem.setLeftBarButton(logoutButton, animated: true)


        gstTextField.draw(gstTextField.frame)
        prefixTextTextField.draw(prefixTextTextField.frame)
        iconView.layer.borderColor = UIColor.appDarkGreenColor.cgColor
        iconView.layer.borderWidth = 1.0
        iconView.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        iconView.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        scrollingView.isScrollEnabled = true
        // Do any additional setup after loading the view
        scrollingView.contentSize = CGSize.init(width: self.view.frame.width, height:self.view.frame.height + self.view.frame.width)
        
        if #available(iOS 11.0, *) {
            
            
            let bottomPadding = view.safeAreaInsets.bottom
            
            let views = UIView()
            
            views.frame = CGRect.init(x: 0, y: self.view.frame.height - bottomPadding, width: self.view.frame.width, height: bottomPadding)
            
           views.backgroundColor = UIColor.statusColor
            self.view.addSubview(views)
            
            // ...
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollingView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 100
        scrollingView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollingView.contentInset
        contentInset.bottom = -keyboardFrame.size.height
        scrollingView.contentInset = contentInset
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
         let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
       // imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
     
    }
    
    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
        if self.istaxTypeUpdated == true  && self.isimageUploaded == true  && self.gstTextField.text != "" && self.prefixTextTextField.text != ""{
            
        ApiHelper().patchRequest(url: EndPoints().invoicePatch + UserDefaults.standard.string(forKey:"StoreId")!, method: "patch", params: [
            
            "gstNumber": gstTextField.text!,
            "invoicePrefix": prefixTextTextField.text!,
            "invoiceFormat": "\(String(describing: invoiceIdValue))",
            "taxType": taxTypeBtn.titleLabel?.text
            
        ]) { (result) in
            
            print(result)
            
            let jsonResult: NSDictionary = (result as? NSDictionary)!
            
            DispatchQueue.main.async(execute: {
                
                
                if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                    
                    print(responesJson)
                    
                    DispatchQueue.main.async(execute: {
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PreviewInvoiceViewController") as! PreviewInvoiceViewController
                    
                        nextViewController.invoiceIdValue = self.invoiceIdValue
                        self.navigationController?.pushViewController(nextViewController, animated: true)
                      
                    })
                    
                    
                    
                }else {
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.alert(message: jsonResult.value(forKey: "message") as! String)
                        
                        
                        
                    })
                }
                
                
            })
            
        }
        }else{
            
            self.alert(message: "missing field")
            
        }
        
        
        
    }
    
    func progressViewSetup(value : Int ,isadded : Bool){
        
        if isadded == false{
            
            Indvalue = Indvalue - 25
            
        }else{
            Indvalue = Indvalue + 25
        }
        
        if Indvalue == 25{
            
            strenthLabel.text = "Business Strength 😶"
            
            errorLabel.text = "Good start"
            
            completeLabel.text = "\(Indvalue) % Complete"
            
            if let backColor = UIColor(hexString: "#c957dc"){
                
                
                errorLabel.textColor = backColor
                
                progressView.progress = 0.25
                
                progressView.progressTintColor = backColor
                
            }
            
        }else if Indvalue == 50{
            
            strenthLabel.text = "Business Strength 😎"
            
            errorLabel.text = "Way to go"
            
            completeLabel.text = "\(Indvalue) % Complete"
            
            if let backColor = UIColor(hexString: "#1baf44"){
                
                
                errorLabel.textColor = backColor
                
                progressView.progress = 0.50
                
                progressView.progressTintColor = backColor
                
            }
            
            
        }else if Indvalue == 75{
            
            strenthLabel.text = "Business Strength 💪"
            
            errorLabel.text = "Almost there"
            
            completeLabel.text = "\(Indvalue) % Complete"
            
            if let backColor = UIColor(hexString: "#b4ccfc"){
                
                
                errorLabel.textColor = backColor
                
                progressView.progress = 0.75
                
                progressView.progressTintColor = backColor
                
            }
            
            
        }else if Indvalue == 100{
            
            strenthLabel.text = "Business Strength 🎉"
            
            errorLabel.text = "You are Awesome"
            
            completeLabel.text = "100% Complete"
            
            if let backColor = UIColor(hexString: "#4886ff"){
                
                
                errorLabel.textColor = backColor
                
                progressView.progress = 1
                
                progressView.progressTintColor = backColor
                
            }
            bottomView.isHidden = false
            
            
        }else{
            strenthLabel.text = "Business Strength 😶"
            
            errorLabel.text = "Your information can help us serve you better"
            
            completeLabel.text = "0-10 % Complete"
            
            if let backColor = UIColor(hexString: "#D2925A"){
                
                
                errorLabel.textColor = backColor
                
                progressView.progress = 0.15
                
                progressView.progressTintColor = backColor
                bottomView.isHidden = false
            }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        NSLog("\(info)")
        
        let image = info[UIImagePickerController.InfoKey.originalImage]! as! UIImage
        
        
        logoImageView.image = image
        
         dismiss(animated: true, completion: nil)
        
        
        ApiHelper().postRequest(url: EndPoints().uploadKey, method: "POST", params: [
            "name": "\(String(describing: invoiceIdValue)).jpeg",
            "size": 135534,
            "key": "store_logo/\(String(describing: invoiceIdValue!))/\(String(describing: invoiceIdValue!)).jpeg"
            
        ]) { (result) in
            
            print(result)
            
            let jsonResult: NSDictionary = (result as? NSDictionary)!
            
            DispatchQueue.main.async(execute: {
                
                print(jsonResult.value(forKey: "Url")!)
                
                
                let imageData = self.logoImageView.image!.jpegData(compressionQuality: 0)
                
                
                let headers = [
                    "Content-Type": "image/jpeg"
                    
                ]
                
                let url = URL.init(string: jsonResult.value(forKey: "Url") as! String )
                
                // presignedUrl is a String
                
                Alamofire.upload(imageData!, to: url!, method: .put, headers: headers)
                    .responseData {
                        response in
                        
                        print(response)
                        
                        switch response.result {
                        case .success(let JSON):
                            
                            print(JSON)
                            
                            ApiHelper().getRequest(url: EndPoints().uploadKey , method: "GET", params: ["key": "store_logo/\(String(describing: self.invoiceIdValue!))/\(String(describing: self.invoiceIdValue!)).jpeg"]) { (result) in
                                
                                print(result)
                                self.isimageUploaded = true
                                self.progressViewSetup(value: 25, isadded: true)
                                
                                if self.istaxTypeUpdated == true  && self.isimageUploaded == true  && self.gstTextField.text != "" && self.prefixTextTextField.text != ""{
                                    self.Indvalue = 75
                                    self.progressViewSetup(value: 25 , isadded: true)
                                    
                                }else{
                                    self.bottomView.isHidden = true
                                }
                                //                                let url = URL(string: result.value(forKey: "Url") as! String)!
                                //                                self.logoImageView.kf.setImage(with: url)
                                
                            }
                            
                            break
                        case .failure(let error):
                            
                            print(error)
                            
                        }
                        
                }
                
                
            })
            
        }
        
      
    }

}




extension InvoiceSettingsViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
    
        return true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text?.count)! > 0 {
            
            textField.font = UIFont.init(name:"Roboto-Light", size: 16)
            
        }else{
            textField.font = UIFont.init(name:"Roboto-Light", size: 12)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != ""{
            
            progressViewSetup(value: 25, isadded: true)
            
        }else{
            
            progressViewSetup(value: 25, isadded: false)
            
        }
        
        if istaxTypeUpdated == true  && isimageUploaded == true  && gstTextField.text != "" && prefixTextTextField.text != ""{
            Indvalue = 75
            progressViewSetup(value: 25 , isadded: true)
            
        }else{
            bottomView.isHidden = true
        }
    }
    
}
