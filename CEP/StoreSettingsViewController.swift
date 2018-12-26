//
//  StoreSettingsViewController.swift
//  CEP
//
//  Created by jaya kumar on 11/12/18.
//  Copyright © 2018 jaya kumar. All rights reserved.
//

import UIKit
import TagListView
import iOSDropDown

protocol StoreSettingsDelegete: class {
    func startApi()
    
}

class StoreSettingsViewController: UIViewController,TagListViewDelegate{
    @IBOutlet weak var scrollingView: UIScrollView!
    @IBOutlet weak var storeNameTextfield: UITextField!
    @IBOutlet weak var yourNameTextField: UITextField!
    @IBOutlet weak var storeAddressTextField: UITextField!
    @IBOutlet weak var dayCollectionView: UICollectionView!
    @IBOutlet weak var storeContactTextField: UITextField!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var strenthLabel: UILabel!
    @IBOutlet weak var selectCityBtn: UIButton!
    
    @IBOutlet weak var endTimeBtn: UIButton!
    @IBOutlet weak var selectLanguageBtn: UIButton!
    
    @IBOutlet weak var startTimeBtn: UIButton!
    @IBOutlet weak var startTimeField: UITextField!
    
    @IBOutlet weak var endTimeField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cityDropDownField: DropDown!
    
    @IBOutlet weak var languageDropDown: DropDown!
    
    @IBOutlet weak var tagListView: TagListView!
    
     weak var delegete: StoreSettingsDelegete?
    
    var cityArray : [String] = []
    
    var languageArray : [String] = []
    
    var daysArray : [String] = []

    var cityDictc : [City] = []
    
    var languageDictc : [Language] = []
    
    var daysDictc : [Day] = []
    
    var selectedDayIndexs : [Int] = []
    
    var reqDayArray : [String] = []
    
    
    var selectedCityText : String!
    
    var reqDay : [String] = []
    
     var languageText : String!
    
    
    var isContentAnimation : Bool!
    
    
    var Indvalue = 0
    
    
    
    var added = true
    
    
    var activeField: UITextField!
    
    @IBOutlet weak var scrollingViewBottom: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        textApiSetUp()
        
        isContentAnimation = false
        
        strenthLabel.text = "Business Strength 😶"
        
        errorLabel.text = "Your information can help us serve you better"
        
        completeLabel.text = "0-10 % Complete"
        
        if let backColor = UIColor(hexString: "#D2925A"){
            
            
            errorLabel.textColor = backColor
            
            progressView.progress = 0.15
            
            progressView.progressTintColor = backColor
            
        }
        
        
        startTimeField.addTarget(self, action: #selector(startFieldAction), for: UIControl.Event.editingDidBegin)


        endTimeField.addTarget(self, action: #selector(endFieldAction), for: UIControl.Event.editingDidBegin)

        
        selectCityBtn.layer.borderColor = UIColor.appDarkGreenColor.cgColor
        selectCityBtn.layer.borderWidth = 1.0
        selectCityBtn.layer.masksToBounds = true
        
        startTimeBtn.layer.borderColor = UIColor.appDarkGreenColor.cgColor
        startTimeBtn.layer.borderWidth = 1.0
        startTimeBtn.layer.masksToBounds = true
        
        endTimeBtn.layer.borderColor = UIColor.appDarkGreenColor.cgColor
        endTimeBtn.layer.borderWidth = 1.0
        endTimeBtn.layer.masksToBounds = true
       
        selectLanguageBtn.layer.borderColor = UIColor.appDarkGreenColor.cgColor
        selectLanguageBtn.layer.borderWidth = 1.0
        selectLanguageBtn.layer.masksToBounds = true
    
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if screenWidth == 320.0 {
            
            storeNameTextfield.frame = CGRect.init(x: storeNameTextfield.frame.origin.x, y:storeNameTextfield.frame.origin.y , width:10 , height: storeNameTextfield.frame.size.height)
            
        }
       
        bottomView.isHidden = true
        
        bottomView.addBorder(toEdges: [.top], color: UIColor.appDarkGreenColor, thickness: 1)
        
        storeNameTextfield.draw(storeNameTextfield.frame)
        yourNameTextField.draw(yourNameTextField.frame)
        
        storeAddressTextField.draw(storeAddressTextField.frame)
        storeContactTextField.draw(storeContactTextField.frame)
        
        storeNameTextfield.AddImage(direction: .Left, imageName: "", Frame: CGRect.init(x: 0, y: 0, width: 10.0, height: storeNameTextfield.frame.height), backgroundColor: UIColor.clear)
        
        yourNameTextField.AddImage(direction: .Left, imageName: "", Frame: CGRect.init(x: 0, y: 0, width: 10.0, height: yourNameTextField.frame.height), backgroundColor: UIColor.clear)
        
         storeAddressTextField.AddImage(direction: .Left, imageName: "", Frame: CGRect.init(x: 0, y: 0, width: 10.0, height: yourNameTextField.frame.height), backgroundColor: UIColor.clear)
        
         storeContactTextField.AddImage(direction: .Left, imageName: "", Frame: CGRect.init(x: 0, y: 0, width: 10.0, height: yourNameTextField.frame.height), backgroundColor: UIColor.clear)
        
        
        tagListView.textFont = UIFont.systemFont(ofSize: 12)
        tagListView.alignment = .left // possible values are .Left, .Center, and .Right
        
        
        
        tagListView.delegate = self
        
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
        let logoutButton:UIBarButtonItem = UIBarButtonItem(title:"Store Settings",
                                                           style:UIBarButtonItem.Style.plain,
                                                           target:self,
                                                           action:nil)
        self.navigationItem.setLeftBarButton(logoutButton, animated: true)

        
        
        // The list of array to display. Can be changed dynamically
        cityDropDownField.optionArray = ["Monday", "Tuseday", "Wednesday" , "ThursDay" ,"Friday", "Saturday" , "Sunday"]
        //Its Id Values and its optional
        cityDropDownField.optionIds = [1,23,54,22]
        // The the Closure returns Selected Index and String
        cityDropDownField.didSelect{(selectedText , index ,id) in
            
            
            if let buttonColor2 = UIColor(hexString: "#3A7BD5"){
                
                self.selectCityBtn.backgroundColor = buttonColor2
            }
            if let buttonColor2 = UIColor(hexString: "#3A7BD5"){
                
                
                if self.selectCityBtn.backgroundColor == buttonColor2{
                    
                    self.progressViewSetup(value: 12, isadded: true)
                    
                }else{
                    
                    self.progressViewSetup(value: 12, isadded: false)
                    
                }
                
            }
            self.selectCityBtn.layer.borderColor = UIColor.clear.cgColor
             self.selectCityBtn.setTitle(selectedText, for: .normal)
            self.selectCityBtn.setTitleColor(UIColor.white, for: .normal)
           
        }
        cityDropDownField.inputView = UIView.init()
        
        
        languageDropDown.listWillAppear {
            
            UIView.animate(withDuration: 0.4, animations: { // 3.0 are the seconds
                
                self.scrollingView.contentOffset.y = self.scrollingView.contentOffset.y + 100
            })
            
        }
        
        languageDropDown.listWillDisappear
        {
            
            UIView.animate(withDuration: 0.4, animations: { // 3.0 are the seconds
                
                self.scrollingView.contentOffset.y = self.scrollingView.contentOffset.y - 100
            })
            
            self.bottomView.isHidden = false
            
        }
        
        languageDropDown.didSelect{(selectedText , index ,id) in
            
            print("Selected String: \(selectedText) \n index: \(index)")
            
            if let buttonColor2 = UIColor(hexString: "#3A7BD5"){
                
                self.selectLanguageBtn.backgroundColor = buttonColor2
            }
            
             if let buttonColor2 = UIColor(hexString: "#3A7BD5"){
                
                
                if self.selectLanguageBtn.backgroundColor == buttonColor2{
                    
                    self.progressViewSetup(value: 11, isadded: true)
                    
                }else{
                    
                    self.progressViewSetup(value: 11, isadded: false)
                    
                }
                
            }
            
            
            self.selectLanguageBtn.layer.borderColor = UIColor.clear.cgColor
            
            self.selectLanguageBtn.setTitle(selectedText, for: .normal)
            
            self.selectLanguageBtn.setTitleColor(UIColor.white, for: .normal)
        }
        languageDropDown.inputView = UIView.init()
    
        
        
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.textResignSetup1))
        toolBar.setItems([doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        startTimeField.inputAccessoryView = toolBar
        startTimeField.inputView = datePickerView
         datePickerView.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: UIControl.Event.valueChanged)
        
        let datePickerView1 : UIDatePicker = UIDatePicker()
        datePickerView1.datePickerMode = UIDatePicker.Mode.time
        
        let toolBar1 = UIToolbar()
        toolBar1.barStyle = UIBarStyle.default
        toolBar1.isTranslucent = true
        toolBar1.tintColor = .black
        toolBar1.sizeToFit()
        
        let doneButton1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.textResignSetup))
        toolBar1.setItems([doneButton1], animated: false)
        
        toolBar1.isUserInteractionEnabled = true
        endTimeField.inputAccessoryView = toolBar1
        endTimeField.inputView = datePickerView1
        
        datePickerView1.addTarget(self, action: #selector(self.handleDatePicker1(sender:)), for: UIControl.Event.valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)

    }
    override func viewDidLayoutSubviews() {
        
        scrollingView.isScrollEnabled = true
        // Do any additional setup after loading the view
        scrollingView.contentSize = CGSize.init(width: self.view.frame.width, height: scrollingView.frame.height + self.view.frame.width + tagListView.frame.height)

        
        if #available(iOS 11.0, *) {
            
            
            let bottomPadding = view.safeAreaInsets.bottom
           
           let views = UIView()
            
            views.frame = CGRect.init(x: 0, y: self.view.frame.height - bottomPadding, width: self.view.frame.width, height: bottomPadding)
            
            views.backgroundColor = UIColor.appDarkBlueColor
            self.view.addSubview(views)
            
            
            // ...
        }
//        var offset = scrollingView.contentOffset
//        offset.y = scrollingView.contentSize.height + scrollingView.contentInset.bottom - scrollingView.bounds.size.height
//        scrollingView.setContentOffset(offset, animated: true)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + self.view.frame.width, right: 0)
        scrollingView.contentInset = contentInsets
        scrollingView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollingView.contentInset = .zero
        scrollingView.scrollIndicatorInsets = .zero
    }
    
 
    @objc func handleDatePicker(sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        
        timeFormatter.timeStyle = .short
        startTimeField.text = timeFormatter.string(from: sender.date)
        if let buttonColor2 = UIColor(hexString: "#3A7BD5"){
            
            if self.endTimeBtn.backgroundColor == buttonColor2{
                self.progressViewSetup(value: 12, isadded: false)
            }else{
                
                self.progressViewSetup(value: 12, isadded: true)
                
            }
            self.startTimeBtn.backgroundColor = buttonColor2
        }
        startTimeBtn.setTitle(startTimeField.text, for: .normal)
    }
    
    @objc func handleDatePicker1(sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        
        timeFormatter.timeStyle = .short
        endTimeField.text = timeFormatter.string(from: sender.date)
        
        if let buttonColor2 = UIColor(hexString: "#3A7BD5"){
            
            
            if self.endTimeBtn.backgroundColor == buttonColor2{
                self.progressViewSetup(value: 12, isadded: false)
            }else{
                
                self.progressViewSetup(value: 12, isadded: true)
            
            }
            self.endTimeBtn.backgroundColor = buttonColor2
        }
        
         endTimeBtn.setTitle(endTimeField.text, for: .normal)
    }
    
    @objc func textResignSetup(){
        
        
        if isContentAnimation == true{
            UIView.animate(withDuration: 0.4, animations: { // 3.0 are the seconds
                
                
            })
            
            isContentAnimation = false
            
        }
        
        
        self.endTimeBtn.layer.borderColor = UIColor.clear.cgColor
        
        self.endTimeBtn.setTitleColor(UIColor.white, for: .normal)

        endTimeField.resignFirstResponder()
        
        
        if let buttonColor2 = UIColor(hexString: "#3A7BD5"){
            
            
            if self.selectCityBtn.backgroundColor == buttonColor2{
                
                self.progressViewSetup(value: 12, isadded: true)
                
            }else{
                
                self.progressViewSetup(value: 12, isadded: false)
                
            }
            
        }
        
    }
    
    @objc func textResignSetup1(){
        if isContentAnimation == true{
        UIView.animate(withDuration: 0.4, animations: { // 3.0 are the seconds

            //self.scrollingView.contentOffset.y = self.scrollingView.contentOffset.y - 150
        })

            isContentAnimation = false

    }
        
        if let buttonColor2 = UIColor(hexString: "#3A7BD5"){
            
            self.startTimeBtn.backgroundColor = buttonColor2
        }
        
        if let buttonColor2 = UIColor(hexString: "#3A7BD5"){
           
            if self.selectCityBtn.backgroundColor == buttonColor2{
                
                self.progressViewSetup(value: 11, isadded: true)
                
            }else{
                
                self.progressViewSetup(value: 11, isadded: false)
                
            }
            
        }
        self.startTimeBtn.layer.borderColor = UIColor.clear.cgColor
        
        self.startTimeBtn.setTitleColor(UIColor.white, for: .normal)
        startTimeField.resignFirstResponder()
        
        
    }
    
    @objc func startFieldAction(){
        
        if isContentAnimation == false{
        UIView.animate(withDuration: 0.4, animations: { // 3.0 are the seconds

           // self.scrollingView.contentOffset.y = self.scrollingView.contentOffset.y + 150
        })


        isContentAnimation = true
        }
    }
    
    @objc func endFieldAction(){
//         if isContentAnimation == false{
//
//        UIView.animate(withDuration: 0.4, animations: { // 3.0 are the seconds
//
//            //self.scrollingView.contentOffset.y = self.scrollingView.contentOffset.y + 150
//        })
//
//            isContentAnimation = true
        //}
        
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        
        
        print("Tag pressed: \(title), \(sender)")
        
        tagView.isSelected = !tagView.isSelected
        
        
        
        if title == "All"{
            
        }
        
        for tas in tagListView.selectedTags(){
            
            if tas.isSelected{
                
                
                if added == true{
                    
                    added = false
                    
                    self.progressViewSetup(value: 11, isadded: true)
                    
                }
        
            }else{
                
                if added == true{
                    
                    added = false
                    
                    self.progressViewSetup(value: 11, isadded: true)
                    
                }
                
            }
            
        }
        
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
    
    
    @IBAction func languageTextFieldAction(_ sender: Any) {
        
        
    }
    
    
    func textApiSetUp(){
        
        ApiHelper().restRequest(url: EndPoints().storeSettings, method: "GET", params: [:]) { (result) in
            
            let jsonResult: NSDictionary = result as! NSDictionary
            
            
            if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                
                var cityDict = responesJson.value(forKey: "city") as! [NSDictionary]
                
                let languageDict = responesJson.value(forKey: "language") as! [NSDictionary]
                
                 let workingDays = responesJson.value(forKey: "WorkingDays") as! [NSDictionary]
                
                for value in cityDict{
                    
                    let cityobj = City()
                    
                    cityobj.title = value.value(forKey: "title") as? String
                    
                    cityobj.value = value.value(forKey: "value") as? String
                    
                    self.cityArray.append(cityobj.title!)
                    
                    self.cityDictc.append(cityobj)
                    
                    
                    
                    
                }
                
                for value in workingDays{
                    
                    let dayObj = Day()
                    
                    dayObj.title = value.value(forKey: "title") as? String
                    
                    dayObj.value = value.value(forKey: "value") as? String
                    
                    self.daysArray.append(dayObj.title!)
                    
                    self.daysDictc.append(dayObj)
                    
                }
                
                
                for values in languageDict{
                    
                    let languageObj = Language()
                    
                    languageObj.title = values.value(forKey: "title") as? String
                    
                    languageObj.value = values.value(forKey: "value") as? String
                    
                    self.languageArray.append(languageObj.title!)
                    
                    self.languageDictc.append(languageObj)
                    
                }
                
                DispatchQueue.main.async(execute: {
                    
                    self.tagListView.addTags(self.daysArray)
                    
                    self.languageDropDown.optionArray = self.languageArray
                    
                    self.cityDropDownField.optionArray = self.cityArray
                    
                })
            }
            
        }
        
    }
    @IBAction func saveBtnAction(_ sender: Any) {
        
        for tag in tagListView.selectedTags(){
            
            
            if let index = daysArray.index(of: (tag.titleLabel?.text)!){
                
                selectedDayIndexs.append(index)
                
            }
        }
        
        
        for index  in selectedDayIndexs{
            
            let obj = daysDictc[index]
            
            reqDayArray.append(obj.value!)
            
            print(reqDayArray)
            
            
        }
        
        if let index = cityArray.index(of: (selectCityBtn.titleLabel?.text)!){
            
            let obj = cityDictc[index]
            
            if let text = obj.value {
                
                selectedCityText = text
                
            }
            print(selectedCityText!)
            
        }
        
        if let index = languageArray.index(of: (selectLanguageBtn.titleLabel?.text)!){
            
            let obj = languageDictc[index]
            
            
            if let text = obj.value{
                
                languageText = text
                
                
            }
            
            print(languageText!)
            
        }
        
        ApiHelper().postRequest(url: EndPoints().storeSave1, method: "POST", params: [
            "storeName": storeNameTextfield.text!,
            "storeManagerName": yourNameTextField.text!,
            "workingDays": reqDayArray,
            "workingHours": [
                "start": "08.00.00",
                "end": "12.00.00"
            ],
            "storeAddress": storeAddressTextField,
            "storeContact": storeContactTextField.text!,
            "storeLanguage": languageText!,
            "storeCity": selectedCityText!
            
        ]) { (result) in
            
            print(result)
            
            let jsonResult: NSDictionary = (result as? NSDictionary)!
            
            DispatchQueue.main.async(execute: {
                
                
                if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                    
                    print(responesJson)
                    
                    let jsonResult: NSDictionary = (result as? NSDictionary)!
                    
                    DispatchQueue.main.async(execute: {
                            if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                                
                                
                              let dict = responesJson.value(forKey: "data") as? NSDictionary
                                
                                UserDefaults.standard.set(dict?.value(forKey: "id"), forKey: "StoreId")
                                
                        }
                        
                        ApiHelper().patchRequest(url: EndPoints().storeSave2 + UserDefaults.standard.string(forKey:"userId")!, method: "patch", params: [
                            
                            "storeId": UserDefaults.standard.string(forKey:"userId")!
                            
                        ]) { (result) in
                            
                            print(result)
                            
                            let jsonResult: NSDictionary = (result as? NSDictionary)!
                            
                            DispatchQueue.main.async(execute: {
                                
                                
                                if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                                    
                                    print(responesJson)
                                    
                                    
                                    
                                    DispatchQueue.main.async(execute: {
                                        
                                        ApiHelper().postRequest(url: EndPoints().storePost, method: "POST", params: [ "tId": UserDefaults.standard.string(forKey:"StoreId")!]) { (result) in
                                            
                                            print(result)
                                            
                                            if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                                                
                                                print(responesJson)
                                                
                                                DispatchQueue.main.async(execute: {
                                                 self.navigationController?.popViewController(animated: true)
                                                    
                                                })
                                            }
                                            
                                        }
                                      
                                    })
                                    
                                    
                                    
                                }else {
                                    
                                    DispatchQueue.main.async(execute: {
                                        
                                        self.alert(message: jsonResult.value(forKey: "message") as! String)
                                        
                                        
                                        
                                    })
                                }
                                
                                
                            })
                            
                        }
                        
                        
                        
                        
                        
                    })
                    
                    
                    
                }else {
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.alert(message: jsonResult.value(forKey: "message") as! String)
                        
                        
                        
                    })
                }
                
                
            })
            
        }
  
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
       
    }
    func progressViewSetup(value : Int ,isadded : Bool){
        
        if isadded == false{
            
            Indvalue = Indvalue - 11
            
        }else{
            Indvalue = Indvalue + 11
        }
        
        if Indvalue == 11{
            
            strenthLabel.text = "Business Strength 👌"
            
            errorLabel.text = "Your information can help us serve you better"
            
            completeLabel.text = "\(Indvalue) % Complete"
            
            if let backColor = UIColor(hexString: "#D2925A"){
             
                errorLabel.textColor = backColor
                
                progressView.progress = 0.11
                
                progressView.progressTintColor = backColor
                
            }
            
        }else if Indvalue == 22{
        
            strenthLabel.text = "Business Strength 👍"
            
            errorLabel.text = "Good start"
            
            completeLabel.text = "\(Indvalue) % Complete"
            
            if let backColor = UIColor(hexString: "#c957dc"){
                
                
                errorLabel.textColor = backColor
                
                progressView.progress = 0.22
                
                progressView.progressTintColor = backColor
                
            }
            
            
            
        }else if Indvalue == 33{
            
            strenthLabel.text = "Business Strength 🤮"
            
            errorLabel.text = "Quick Leap"
            
            completeLabel.text = "\(Indvalue) % Complete"
            
            if let backColor = UIColor(hexString: "#77EC98"){
                
                
                errorLabel.textColor = backColor
                
                progressView.progress = 0.33
                
                progressView.progressTintColor = backColor
                
            }
            
           
            
            
        }else if Indvalue == 44{
            
            strenthLabel.text = "Business Strength 😎"
            
            errorLabel.text = "Mid way through"
            
            completeLabel.text = "\(Indvalue) % Complete"
            
            if let backColor = UIColor(hexString: "#1baf44"){
                
                
                errorLabel.textColor = backColor
                
                progressView.progress = 0.44
                
                progressView.progressTintColor = backColor
                
            }
            
            
        }else if Indvalue == 55{
            
            strenthLabel.text = "Business Strength 😎"
            
            errorLabel.text = "Way to go"
            
            completeLabel.text = "\(Indvalue) % Complete"
            
            if let backColor = UIColor(hexString: "#EBC460"){
                
                
                errorLabel.textColor = backColor
                
                progressView.progress = 0.55
                
                progressView.progressTintColor = backColor
                
            }
            
            
        }else if Indvalue == 66{
            
            strenthLabel.text = "Business Strength 🙌"
            
            errorLabel.text = "Almost there"
            
            completeLabel.text = "\(Indvalue) % Complete"
            
            if let backColor = UIColor(hexString: "#b4ccfc"){
                
                
                errorLabel.textColor = backColor
                
                progressView.progress = 0.66
                
                progressView.progressTintColor = backColor
                
            }
            
            
        } else if Indvalue == 77{
            
            strenthLabel.text = "Business Strength 💪"
            
            errorLabel.text = "Perfect streak"
            
            completeLabel.text = "\(Indvalue) % Complete"
            
            if let backColor = UIColor(hexString: "#7C90B8"){
                
                
                errorLabel.textColor = backColor
                
                progressView.progress = 0.77
                
                progressView.progressTintColor = backColor
                
            }
            
            
            
            
        }
        else if Indvalue == 88{
            
            strenthLabel.text = "Business Strength 👐"
            
            errorLabel.text = "Perfect streak"
            
            completeLabel.text = "\(Indvalue) % Complete"
            
            if let backColor = UIColor(hexString: "#7C90B8"){
                
                
                errorLabel.textColor = backColor
                
                progressView.progress = 0.80
                
                progressView.progressTintColor = backColor
                
            }
            
        } else if Indvalue == 99{
            
            strenthLabel.text = "Business Strength 🎉 "
            
            errorLabel.text = "You are Awesome"
            
            completeLabel.text = "100% Complete"
            
            if let backColor = UIColor(hexString: "#4886ff"){
                
                
                errorLabel.textColor = backColor
                
                progressView.progress = 1
                
                progressView.progressTintColor = backColor
                
            }
            
            bottomView.isHidden = false
            
        }
        
//        else{
//            strenthLabel.text = "Business Strength 😶"
//
//            errorLabel.text = "Your information can help us serve you better"
//
//            completeLabel.text = "0-10 % Complete"
//
//            if let backColor = UIColor(hexString: "#D2925A"){
//
//
//                errorLabel.textColor = backColor
//
//                progressView.progress = 0.15
//
//                progressView.progressTintColor = backColor
//                 bottomView.isHidden = true
//            }
        //}
        
    }
}

extension StoreSettingsViewController : UITextFieldDelegate {
    
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
        
        if textField.text == ""{
            
            progressViewSetup(value: 11, isadded: false)
            
            bottomView.isHidden = false
            
        }else{
            
            progressViewSetup(value: 11, isadded: true)
            
        }
        
        activeField = nil
    }
}

class Language : NSObject{
    
    var title : String?
    
    var value : String?
}


class City : NSObject{
    
    var title : String?
    
    var value : String?
}

class Day : NSObject{
    
    var title : String?
    
    var value : String?
}
