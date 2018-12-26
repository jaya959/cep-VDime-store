//
//  BusinessSettingsViewController.swift
//  CEP
//
//  Created by jaya kumar on 11/11/18.
//  Copyright © 2018 jaya kumar. All rights reserved.
//

import UIKit
import Kingfisher


protocol BusinessSettingsDelegate: class {
    func startApi()
   
}

class BusinessSettingsViewController: UIViewController {
    //@IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var numberCollectionView: UICollectionView!
    
    @IBOutlet weak var othersTextField: UITextField!
    
    @IBOutlet weak var businessCollectionView: UICollectionView!
    @IBOutlet weak var roleCollectionView: UICollectionView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var numberOfStoreLabel: UILabel!
    
    @IBOutlet weak var scrollingView: UIScrollView!
    
    @IBOutlet weak var industryLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var IndustryBtn: UIButton!
    @IBOutlet weak var strenthLabel: UILabel!
    
    @IBOutlet weak var completeLabel: UILabel!
    
    @IBOutlet weak var saveBtnAction: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
     weak var delegate: BusinessSettingsDelegate?
    
    var userTypeArray: [UserType] = []
     var businessArray: [Business] = []
    
     var storeCountArray: [StoreCount] = []
    
    var businessSelectedIndex : Int?
    
    var storeSelectedIndex : Int?
    
    var roleSelectedIndex : Int?
    
    var isBusinessSelected : Bool?
    
    var isStoreSelected : Bool?
    
    var isRoleSelected : Bool?
    
    var isSingelStore : Bool?
    
    var roleSelectedtext : String?
    
    var inds : Int?
    
    
    var animation:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.addBorder(toEdges: [.top], color: UIColor.appDarkGreenColor, thickness: 1)

        
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
        let logoutButton:UIBarButtonItem = UIBarButtonItem(title:"Business Settings",
                                                           style:UIBarButtonItem.Style.plain,
                                                           target:self,
                                                           action:nil)
        self.navigationItem.setLeftBarButton(logoutButton, animated: true)
        
        
        
        othersTextField.AddImage(direction: .Left, imageName: "", Frame: CGRect.init(x: 0, y: 0, width: 10.0, height: othersTextField.frame.height), backgroundColor: UIColor.clear)
    
        
       isBusinessSelected = false
        
       isStoreSelected = false
        
       isRoleSelected = false
        
        isSingelStore = false
        
        animation = false
        bottomView.isHidden = true
        
        self.othersTextField.transform = CGAffineTransform.init(translationX: self.view.frame.width, y: 0)
        
//        progressView.transform = progressView.transform.scaledBy(x: 1, y: 5)
        
//        progressView.progress = 0.25
        
        progressViewSetup(value: 25)
        
        if let backColor = UIColor(hexString: "#0f92d4"){
            
            
            IndustryBtn.backgroundColor = backColor
            
        }
        
      // segmentControl.selectedSegmentIndex = 1


        //self.settingsTableView.tableHeaderView = statusView
        
        
        if let backColor = UIColor(hexString: "#f8f8f"){
            
            statusView.backgroundColor = backColor

        }
        ApiHelper().restRequest(url: EndPoints().userStoreSettings, method: "GET", params: [:]) { (result) in
            
            let jsonResult: NSDictionary = result as! NSDictionary
            
            
            if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                
                let userTypeDict = responesJson.value(forKey: "userType") as! [NSDictionary]
                
              
                
                for indValue in userTypeDict{
                    
                    let userObj = UserType()
                    
                    userObj.title = indValue.value(forKey: "title") as? String
                    userObj.logoUrl = indValue.value(forKey: "logo") as? String
                    self.userTypeArray.append(userObj)
                    
                }
                
               
                DispatchQueue.main.async(execute: {
                   
                    self.roleCollectionView.reloadData()
                    
                    self.roleCollectionView.delegate = self
                    self.roleCollectionView.dataSource = self
                    
                    self.numberCollectionView.delegate = self
                    
                    //                    self.numberCollectionView.isHidden = false
                    //
                    //                    num
                    
                })
                
            }
            
        }


        ApiHelper().restRequest(url: EndPoints().getIndustry, method: "GET", params: [:]) { (result) in
            
            let jsonResult: NSDictionary = result as! NSDictionary
            
            
            if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                
                let buisnessType = responesJson.value(forKey: "buisnessType") as! [NSDictionary]
                
                let numberOfStores = responesJson.value(forKey: "numberOfStores") as! [NSDictionary]
                
                for indValue in numberOfStores{
                    
                    let storeObj = StoreCount()
                    
                    storeObj.title = indValue.value(forKey: "title") as? String
                    storeObj.Value = indValue.value(forKey: "value") as? Int
                    self.storeCountArray.append(storeObj)
                    
                }
                
                for indValue in buisnessType{
                    
                    let businessObj = Business()
                    
                    businessObj.title = indValue.value(forKey: "title") as? String
                    
                    self.businessArray.append(businessObj)
                    
                }
                DispatchQueue.main.async(execute: {
                    
                     self.businessArray = self.businessArray.reversed()
                    self.businessCollectionView.reloadData()
                    self.numberCollectionView.reloadData()
                    
                    self.businessCollectionView.delegate = self
                    self.businessCollectionView.dataSource = self
                    
                    self.numberCollectionView.dataSource = self
                    self.numberCollectionView.delegate = self
                    
//                    self.numberCollectionView.isHidden = false
//
//                    num
                    
                })
            }
            
        }
        numberOfStoreLabel.transform = CGAffineTransform.init(translationX: self.view.frame.width, y: 0)
        
        numberCollectionView.transform = CGAffineTransform.init(translationX: self.view.frame.width, y: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
      
       
       self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidLayoutSubviews() {
        
        scrollingView.isScrollEnabled = true
        // Do any additional setup after loading the view
        scrollingView.contentSize = CGSize.init(width: self.view.frame.width, height:self.view.frame.height + 200)
        
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
        contentInset.bottom = keyboardFrame.size.height
        scrollingView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollingView.contentInset
       // contentInset.bottom =  keyboardFrame.size.height
        scrollingView.contentInset = contentInset
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
        
    
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
        
        
        var isSelect : Bool
        
        var storeInt: Int
        
        if businessSelectedIndex == 1{
            isSelect = true
            let storeObj = storeCountArray[storeSelectedIndex!]
            storeInt = storeObj.Value!
        }else{
            isSelect = false
            storeInt = 1
        }
        
        if roleSelectedtext == "Others"{

            
            roleSelectedtext = othersTextField.text
            
        }
        
        ApiHelper().postRequest(url: EndPoints().industryProceed, method: "POST", params: [
            "isMultipleStore": isSelect,
            "storeCount": storeInt
            
        ]) { (result) in
            
            print(result)
            
            let jsonResult: NSDictionary = (result as? NSDictionary)!
            
            DispatchQueue.main.async(execute: {
                
                
                if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                    
                    print(responesJson)
                    
                    
                    
                    DispatchQueue.main.async(execute: {
                        
                        
                        ApiHelper().patchRequest(url: EndPoints().businessSettingsSave2 + UserDefaults.standard.string(forKey:"userId")!, method: "patch", params: [

                            "userType": self.roleSelectedtext!
                            
                        ]) { (result) in
                            
                            print(result)
                            
                            let jsonResult: NSDictionary = (result as? NSDictionary)!
                            
                            DispatchQueue.main.async(execute: {
                                
                                
                                if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                                    
                                    print(responesJson)
                             
                                    DispatchQueue.main.async(execute: {
                                      
                                        ApiHelper().postRequest(url: EndPoints().businessPost, method: "POST", params: [:]) { (result) in
                                            
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
    
    
    @IBAction func segmentAction(_ sender: Any) {
        
        if segmentControl.selectedSegmentIndex == 1 {
            
           
        
        }else{
            
            
        }
        
    }
    
    func progressViewSetup(value : Int){
        
        var indValue = value
        
        inds = value
        
        if roleSelectedtext == "Others"{
            
            if othersTextField.text == ""{
                
                 indValue = 80
                
                bottomView.isHidden = true
                
            }
        }
        
        if indValue == 25{
            
            strenthLabel.text = "Business Strength 👍"
            
            errorLabel.text = "Good start"
            
            completeLabel.text = "\(indValue) % Complete"
            
            if let backColor = UIColor(hexString: "#c957dc"){
                
                
               errorLabel.textColor = backColor
                
                progressView.progress = 0.25
                
                progressView.progressTintColor = backColor
                
            }
            
        }else if indValue == 50{
            
            strenthLabel.text = "Business Strength 😎"
            
            errorLabel.text = "Mid way through"
            
            completeLabel.text = "\(indValue) % Complete"
            
            if let backColor = UIColor(hexString: "#1baf44"){
                
                
                errorLabel.textColor = backColor
                
                progressView.progress = 0.50
                
                progressView.progressTintColor = backColor
                
            }
            
            
        }else if indValue == 75{
            
            strenthLabel.text = "Business Strength 💪"
            
            errorLabel.text = "Almost there"
            
            completeLabel.text = "\(indValue) % Complete"
            
            if let backColor = UIColor(hexString: "#b4ccfc"){
                
                
                errorLabel.textColor = backColor
                
                progressView.progress = 0.75
                
                progressView.progressTintColor = backColor
                
            }
            
            
        }else if indValue == 80{
            
            strenthLabel.text = "Business Strength 💪"
            
            errorLabel.text = "test"
            
            completeLabel.text = "\(indValue) % Complete"
            
            if let backColor = UIColor(hexString: "#b4ccfc"){
                
                
                errorLabel.textColor = backColor
                
                progressView.progress = 0.75
                
                progressView.progressTintColor = backColor
                
            }
        }else{
            
            strenthLabel.text = "Business Strength 🎉"
            
            errorLabel.text = "You are Awesome"
            
            completeLabel.text = "100% Complete"
            
            if let backColor = UIColor(hexString: "#4886ff"){
                
                
                errorLabel.textColor = backColor
                
                progressView.progress = 1
                
                progressView.progressTintColor = backColor
                
            }
            
             bottomView.isHidden = false
            
            
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
extension BusinessSettingsViewController : UICollectionViewDelegate ,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         if collectionView == roleCollectionView{
            
            return userTypeArray.count
            
         }else if collectionView == businessCollectionView{
            
            return businessArray.count
         }else{
            
            return storeCountArray.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == roleCollectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
            cell.backgroundColor = UIColor.clear
            
            let userTypeObj = userTypeArray[indexPath.row]
            
            let image = cell.viewWithTag(1) as! UIImageView
            
            let url = URL(string: userTypeObj.logoUrl!)!
            image.kf.setImage(with: url)
            
            let title = cell.viewWithTag(2) as! UILabel
            
            title.text = userTypeObj.title
            
            title.textColor = UIColor.darkGray
         
            cell.layer.borderColor = UIColor.appDarkGreenColor.cgColor
            
            cell.layer.borderWidth = 1.0
            cell.backgroundColor = UIColor.clear
            
            
            
            if roleSelectedIndex == indexPath.row{
                
                    if let backColor = UIColor(hexString: "#0f92d4"){
                        
                        cell.backgroundColor = backColor
                        
                        
                        cell.layer.borderColor = UIColor.clear.cgColor
                       
                        title.textColor = UIColor.white
                   
                    
                }
            }
            return cell

        }else if collectionView == businessCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCell", for: indexPath as IndexPath)
            cell.backgroundColor = UIColor.clear
            
            let businessObj = businessArray[indexPath.row]
            
            let title = cell.viewWithTag(1) as! UILabel
            
            title.text =  businessObj.title
            
            title.textColor = UIColor.darkGray
            
            cell.layer.borderColor = UIColor.appDarkGreenColor.cgColor
            
            cell.layer.borderWidth = 1.0
            
            cell.backgroundColor = UIColor.clear
            
            if businessSelectedIndex == indexPath.row {
                
                if let backColor = UIColor(hexString: "#0f92d4"){
                    
                    cell.backgroundColor = backColor
                    
                    cell.layer.borderColor = UIColor.clear.cgColor
                    
                    title.textColor = UIColor.white
                    
                }
            }
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath as IndexPath)
            
            let storeObj = storeCountArray[indexPath.row]
            
            let title = cell.viewWithTag(1) as! UILabel
            
           title.text =  storeObj.title
            
            title.textColor = UIColor.darkGray
            
            cell.backgroundColor = UIColor.clear
            
            cell.layer.borderColor = UIColor.appDarkGreenColor.cgColor
            
            cell.layer.borderWidth = 1.0
            
            
            if storeSelectedIndex == indexPath.row {
                
                if let backColor = UIColor(hexString: "#0f92d4"){
                    
                    cell.backgroundColor = backColor
                   
                    cell.layer.borderColor = UIColor.clear.cgColor
                    
                    title.textColor = UIColor.white
                  
                }
            }
            
            return cell
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
       
        
        if collectionView == roleCollectionView{
            
            roleSelectedIndex = indexPath.row
        
            isRoleSelected = true
            
            if isSingelStore == false && isBusinessSelected == false && isSingelStore == false{
                
                 progressViewSetup(value: 50)
                
            }else if isSingelStore == true && isBusinessSelected == false &&  isStoreSelected == true{
                
                progressViewSetup(value: 100)
                
            }else  if isSingelStore == false && isBusinessSelected == true &&  isStoreSelected == false{
                
                progressViewSetup(value: 75)
                
            }else if isSingelStore == false && isBusinessSelected == true &&  isStoreSelected == true{
       
                progressViewSetup(value: 100)
                
            }
            
           
            
            let userTypeObj = userTypeArray[indexPath.row]
            
            if userTypeObj.title == "Others"{
                
                roleSelectedtext = userTypeObj.title
                
                 progressViewSetup(value: 100)
                
                UIView.animate(withDuration: 2.2, delay: 0.05 * Double(0),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    
                    self.othersTextField.transform = CGAffineTransform.identity
                    
                }, completion: nil)
                
            }else{
                roleSelectedtext = userTypeObj.title
                UIView.animate(withDuration: 2.2, delay: 0.05 * Double(0),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    
                    self.othersTextField.transform = CGAffineTransform.init(translationX: self.view.frame.width, y: 0)
                 
                }, completion: nil)
                
            }
            
            
        }else if collectionView == businessCollectionView{
            
            
                businessSelectedIndex = indexPath.row
            
            let businessObj = businessArray[indexPath.row]
            
            if businessObj.title == "Multi Store"{
                
                if isRoleSelected == true{
                    
                    progressViewSetup(value: 75)
                    
                }else{
                    progressViewSetup(value: 50)
                }
                
                isBusinessSelected = true
                
                bottomView.isHidden = true
                
                UIView.animate(withDuration: 2.2, delay: 0.05 * Double(0),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    
                    self.numberOfStoreLabel.transform = CGAffineTransform.identity
                    self.numberCollectionView.transform = CGAffineTransform.identity
                }, completion: nil)
                
            }else{
                
                if isRoleSelected == true {
                    
                    progressViewSetup(value: 100)
                    
                }else{
                    progressViewSetup(value: 50)
                    
                    
                }
                
               
                
                isSingelStore = true
                
                 UIView.animate(withDuration: 2.2, delay: 0.05 * Double(0),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.numberOfStoreLabel.transform = CGAffineTransform.init(translationX: self.view.frame.width, y: 0)
                
                    self.numberCollectionView.transform = CGAffineTransform.init(translationX: self.view.frame.width, y: 0)
                    self.storeSelectedIndex  = nil
                    self.numberCollectionView.reloadData()
               
                }, completion: nil)
            }
            
           
            
                
            }else{
                isStoreSelected = true
            
            if isRoleSelected == true{
                
                progressViewSetup(value: 100)
                
            }else{
                 progressViewSetup(value: 75)
            }
            
            if storeSelectedIndex == nil{
                
            UIView.animate(withDuration: 0.2, animations: { // 3.0 are the seconds
                
                self.scrollingView.contentOffset.y = self.scrollingView.contentOffset.y + 50
            })
            }
        
           storeSelectedIndex = indexPath.row
            
            
            
          
           
            
            
            }
    
            
            collectionView.reloadData()
        
    }
  
}

extension BusinessSettingsViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if inds! > 75 && isSingelStore == true || isBusinessSelected == true {
            progressViewSetup(value: 100)
        }
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
    
}
class Business {
    
    var title: String?
    
}

class StoreCount{
    
    var title: String?
    
    var Value: Int?

}

class UserType{
    
    var title: String?
    
    var logoUrl: String?
    
}
