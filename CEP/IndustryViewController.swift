//
//  IndustryViewController.swift
//  CEP
//
//  Created by jaya kumar on 10/11/18.
//  Copyright © 2018 jaya kumar. All rights reserved.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView

enum DeviceTypeModel{
    case iphoneX
    case iphone8Plus
    case iphone8
    case iphoneSE //SE is the like iphone 5 and iphone 5s
    case iphone4s
}



class IndustryViewController: UIViewController {

    @IBOutlet weak var industryCollectionView: UICollectionView!
    
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    var industryList = [String]()
    var industrySubList = [String]()
    var selectedIndex = Int ()
    
    var isAnimation: Bool!
    
    var industryArray: [Industry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        proceedBtn.isHidden = true
        
        let pulse1 = CASpringAnimation(keyPath: "transform.scale")
        pulse1.duration = 0.6
        pulse1.fromValue = 1.0
        pulse1.toValue = 1.12
        pulse1.autoreverses = true
        pulse1.repeatCount = 1
        pulse1.initialVelocity = 0.5
        pulse1.damping = 0.8
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2.7
        animationGroup.repeatCount = 1000
        animationGroup.animations = [pulse1]
        
        proceedBtn.layer.add(animationGroup, forKey: "pulse")
        
       isAnimation = false
        let loader = NVActivityIndicatorView(frame: self.view.frame, type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballSpinFadeLoader.rawValue), color: UIColor.red, padding: 10.0)
        
       // loader.startAnimating()
        
        self.view.addSubview(loader)

        
    industryCollectionView.isHidden = true

        
        industryList = ["Luxury", "Opticals", "Apparels", "Cosmetics", "Watches", "Saloon & Sap", "Shoes", "Micro Business"]

        searchTextField.setBottomBorder()
        searchTextField.isUserInteractionEnabled = false
        
        
        ApiHelper().restRequest(url: EndPoints().getIndustry, method: "GET", params: [:]) { (result) in
            
            let jsonResult: NSDictionary = result as! NSDictionary
            
            
            if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                
                let industry = responesJson.value(forKey: "industry") as! [NSDictionary]
                
                for indValue in industry{
                    
                     let industryObj = Industry()
                    
                    industryObj.active = indValue.value(forKey: "active") as? Int
                    
                    industryObj.industryId = indValue.value(forKey: "industryId") as? Int
                    
                    industryObj.logo = indValue.value(forKey: "logo") as? String
                    
                    industryObj.subTitle = indValue.value(forKey: "subTitle") as? String
                    
                    industryObj.title = indValue.value(forKey: "title") as? String
                    
                    self.industryArray.append(industryObj)
                    
                }
                DispatchQueue.main.async(execute: {
                    

               self.industryCollectionView.reloadData()
                    
                    self.industryCollectionView.isHidden = false
                    
                })
            }
            
        }
        
        
        
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
        
        
        ApiHelper().postRequest(url: EndPoints().industrySkip, method: "POST", params: [:
]) { (result) in
            
            print(result)
            
            let jsonResult: NSDictionary = (result as? NSDictionary)!
            
            DispatchQueue.main.async(execute: {
                
                
                if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                    
                    print(responesJson)
                   
                    DispatchQueue.main.async(execute: {
                        
                        UserDefaults.standard.set(true, forKey:"industrySkip")
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        
                        self.navigationController?.pushViewController(nextViewController, animated: true)
                        
                       // self.present(nextViewController, animated: true, completion: nil)
                        
                    })
                    
                    
                    
                }else {
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.alert(message: jsonResult.value(forKey: "message") as! String)
                        
                        
                        
                    })
                }
                
                
            })
            
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
    @IBAction func industrySelectionBtnAction(_ sender: Any) {
        
        ApiHelper().postRequest(url: EndPoints().industryProceed, method: "POST", params: [
            "industry": "opticals","industrySettingsDone": true
            
        ]) { (result) in
            
            print(result)
            
             let jsonResult: NSDictionary = (result as? NSDictionary)!
            
            DispatchQueue.main.async(execute: {
                
                
                if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                    
                   print(responesJson)
                    
                    
                    
                   DispatchQueue.main.async(execute: {
                    
                    ApiHelper().postRequest(url: EndPoints().industryDone, method: "POST", params: [
                        "title": "Opticals"
                    ]) { (result) in
                        
                        print(result)
                        
                        if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                            
                            print(responesJson)
                        
                        UserDefaults.standard.set(false, forKey:"industrySkip")
                        
                            DispatchQueue.main.async(execute: {
                                
                                
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        
                        self.navigationController?.pushViewController(nextViewController, animated: true)
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
        
        
    }
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BusinessSettingsViewController") as! BusinessSettingsViewController
//        self.present(nextViewController, animated: true, completion: nil)
        
//        let parameters = ["industry": "opticals","industrySettingsDone": true] as [String : Any]
//
//        //create the url with URL
//        let url = URL(string: EndPoints().industryProceed)! //change the url
//
//        //create the session object
//        let session = URLSession.shared
//
//        //now create the URLRequest object using the url object
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST" //set http method as POST
//
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
//        } catch let error {
//            print(error.localizedDescription)
//        }
//
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("oic-authorization", forHTTPHeaderField:  UserDefaults.standard.value(forKey: "Oic-Auth")! as! String)
//        request.addValue("oic-refresh-token", forHTTPHeaderField:  UserDefaults.standard.value(forKey: "Oic-ref")! as! String)
//
//        //create dataTask using the session object to send data to the server
//        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
//
//            guard error == nil else {
//                return
//            }
//
//            guard let data = data else {
//                return
//            }
//
//            do {
//                //create json object from data
//                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
//                    print(json)
//
//                    let jsonResult: NSDictionary = json as NSDictionary
//
//
//                    if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
//
//                        print(responesJson)
//
//
//
//                        DispatchQueue.main.async(execute: {
//
//
//
//                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//
//                            self.navigationController?.pushViewController(nextViewController, animated: true)
//
//                        })
//
//
//
//                    }else {
//
//                        DispatchQueue.main.async(execute: {
//
//                        self.alert(message: jsonResult.value(forKey: "message") as! String)
//
//
//
//                        })
//                    }
//                    // handle json...
//                }
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        })
//        task.resume()
//
//
//        }
        
}

extension IndustryViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
//        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
//        let size:CGFloat = (collection.frame.size.width - space) / 2.0
//        return CGSize(width: size, height: size)
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return industryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if industryArray.count != 0 {
            
            if isAnimation == false{
            cell.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            UIView.animate(withDuration: 1.0) {
                cell.transform = CGAffineTransform.identity
            }
            }
            

            
        let industryObj = industryArray[indexPath.row]
        
        let industryLogo : UIImageView = cell.viewWithTag(1) as! UIImageView
        
            let url = URL(string: industryObj.logo!)!
            industryLogo.kf.setImage(with: url)
            
            let industryzView : UIView = cell.viewWithTag(5)! as UIView
            
            industryzView.layer.borderColor = UIColor.appDarkGreenColor.cgColor
            
            industryzView.layer.borderWidth = 0.5
            
            industryzView.layer.masksToBounds = true
            
    
        industryLogo.layer.cornerRadius = industryLogo.frame.width / 2
        
        let industryLabel : UILabel = cell.viewWithTag(2) as! UILabel
        
        industryLabel.text = industryObj.title
        
        let subTitle : UILabel = cell.viewWithTag(3) as! UILabel
        
        subTitle.text = industryObj.subTitle
        
        if industryObj.active == 1{

            subTitle.textColor = UIColor.black
            
                
            industryzView.backgroundColor = UIColor.clear
            
            industryLabel.textColor = UIColor.black
            
            industryzView.layer.borderColor = UIColor.appDarkGreenColor.cgColor
            
            industryzView.layer.borderWidth = 0.5
            
            industryzView.layer.masksToBounds = true


        }else{

            if let backColor = UIColor(hexString: "#ede7e7"){

                industryzView.backgroundColor = backColor

            }
            
            industryzView.layer.borderColor = UIColor.clear.cgColor
            
            industryzView.layer.borderWidth = 0.5
            
            industryzView.layer.masksToBounds = true
            subTitle.textColor = UIColor.gray
            industryLabel.textColor = UIColor.gray



        }

        if selectedIndex == 1 {

            if industryObj.active == 1{

                if let backColor = UIColor(hexString: "#0f92d4"){

                   industryzView.backgroundColor = backColor

                    subTitle.textColor = UIColor.black
                    industryLabel.textColor = UIColor.white
                }

            }
        }
        }
  
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        isAnimation = true
        
        if indexPath.row == 0{
            
            
            if selectedIndex == 0{
                
                selectedIndex = 1
                
                proceedBtn.isHidden = false
            }else{
                
                selectedIndex = 0
                
                proceedBtn.isHidden = false

                
            }
            
            collectionView.reloadData()

           
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       
        switch (UIScreen.main.nativeBounds.height){
            
        case 1136:
            return CGSize(width: 130 , height: 70)
            
          default:
            return CGSize(width: 160 , height: 70)
        }
   
    }
    

}
class Industry {
    
    var active: Int?
    var industryId: Int?
    var logo: String?
    var subTitle: String?
    var title:  String?
}
