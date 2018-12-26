//
//  InvoicePreviewViewController.swift
//  CEP
//
//  Created by jaya kumar on 12/12/18.
//  Copyright © 2018 jaya kumar. All rights reserved.
//

import UIKit
import Kingfisher

class InvoicePreviewViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var centerTitleLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var InvoiceDictArray : [InvoiceGet] = []
    
     var taxtypeArray : [TaxType] = []
    
    var currentImage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        currentImage = 0

        bottomView.addBorder(toEdges: [.top], color: UIColor.appDarkGreenColor, thickness: 1)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)) )
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        
        ApiHelper().restRequest(url: EndPoints().storeSettings, method: "GET", params: [:]) { (result) in
            
            let jsonResult: NSDictionary = result as! NSDictionary
            
            
            if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                
                let invoiceFormat = responesJson.value(forKey: "invoiceFormat") as! [NSDictionary]
                
                let texType = responesJson.value(forKey: "taxType") as! [NSDictionary]
                
                for value in invoiceFormat{
                    
                    let invoiceObj = InvoiceGet()
                    
                    invoiceObj.title = value.value(forKey: "title") as? String
                    
                    invoiceObj.src = value.value(forKey: "src") as? String
                    
                    invoiceObj.id = value.value(forKey: "id") as? Int
                    
                    self.InvoiceDictArray.append(invoiceObj)
                }
                
                for value in texType{
                    
                    let texObj = TaxType()
                    
                    texObj.title = value.value(forKey: "title") as? String
                    
                    texObj.value = value.value(forKey: "value") as? String
                    
                    self.taxtypeArray.append(texObj)
                }
                
                
                
                DispatchQueue.main.async(execute: {
                    
                    let invoiceObj = self.InvoiceDictArray[0]
                    
                    let url = URL(string: invoiceObj.src!)!
                    
                    self.imageView.kf.setImage(with: url)
                    
                    self.centerTitleLabel.text = invoiceObj.title
                    
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
    override func viewDidLayoutSubviews() {
        
        if #available(iOS 11.0, *) {
            
            
            let bottomPadding = view.safeAreaInsets.bottom
            
            let views = UIView()
            
            views.frame = CGRect.init(x: 0, y: self.view.frame.height - bottomPadding, width: self.view.frame.width, height: bottomPadding)
            
            views.backgroundColor = UIColor.statusColor
            self.view.addSubview(views)
            
            // ...
        }
    }
    

    @IBAction func forwardBtnAction(_ sender: Any) {
        
        if currentImage == 0 {
            currentImage = InvoiceDictArray.count - 1
        }else{
            currentImage -= 1
        }
        
        let invoiceObj = self.InvoiceDictArray[currentImage]
        
        let url = URL(string: invoiceObj.src!)!
        
        UIView.transition(with: imageView,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: {  self.imageView.kf.setImage(with: url)},
                          completion: nil)
        
       
        
        self.centerTitleLabel.text = invoiceObj.title
        
        
    }
    @IBAction func backBtnAction(_ sender: Any) {
        
        if currentImage == InvoiceDictArray.count - 1 {
            currentImage = 0
            
        }else{
            currentImage += 1
        }
        
        let invoiceObj = self.InvoiceDictArray[currentImage]
        
        let url = URL(string: invoiceObj.src!)!
        
        UIView.transition(with: imageView,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: {  self.imageView.kf.setImage(with: url)},
                          completion: nil)
        
        self.centerTitleLabel.text = invoiceObj.title

        
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                if currentImage == InvoiceDictArray.count - 1 {
                    currentImage = 0
                    
                }else{
                    currentImage += 1
                }
                
                let invoiceObj = self.InvoiceDictArray[currentImage]
                
                let url = URL(string: invoiceObj.src!)!
                
                UIView.transition(with: imageView,
                                  duration: 0.75,
                                  options: .transitionCrossDissolve,
                                  animations: {  self.imageView.kf.setImage(with: url)},
                                  completion: nil)
                
                self.centerTitleLabel.text = invoiceObj.title
                
            case UISwipeGestureRecognizer.Direction.right:
                
                if currentImage == 0 {
                    currentImage = InvoiceDictArray.count - 1
                }else{
                    currentImage -= 1
                }
                
                let invoiceObj = self.InvoiceDictArray[currentImage]
                
                let url = URL(string: invoiceObj.src!)!
                
                UIView.transition(with: imageView,
                                  duration: 0.75,
                                  options: .curveEaseInOut,
                                  animations: {  self.imageView.kf.setImage(with: url)},
                                  completion: nil)
                
                self.centerTitleLabel.text = invoiceObj.title

            default:
                break
            }
        }
    }
    @IBAction func selectAndProceedBtnAction(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "InvoiceSettingsViewController") as! InvoiceSettingsViewController
        let invoiceObj = self.InvoiceDictArray[currentImage]
        nextViewController.invoiceIdValue = invoiceObj.id
        nextViewController.taxArray = taxtypeArray
        self.navigationController?.pushViewController(nextViewController, animated: true)
   
    }
    

    @IBAction func cancelBtnAction(_ sender: Any) {
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

class InvoiceGet : NSObject{
    
    var title : String?
    
    var src: String?
    
    var id : Int?
    
}


class TaxType : NSObject{
    
    var title : String?
    
    var value: String?
    
    
    
}
