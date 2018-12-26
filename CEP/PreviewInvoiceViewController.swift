//
//  PreviewInvoiceViewController.swift
//  CEP
//
//  Created by jaya kumar on 13/12/18.
//  Copyright © 2018 jaya kumar. All rights reserved.
//

import UIKit
import WebKit

class PreviewInvoiceViewController: UIViewController {
    @IBOutlet weak var previewWebView: WKWebView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titlteLabel: UILabel!
    var invoiceIdValue : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomView.addBorder(toEdges: [.top], color: UIColor.appDarkGreenColor, thickness: 1)
        
        let logoutButton:UIBarButtonItem = UIBarButtonItem(title:"Invoice Settings",
                                                           style:UIBarButtonItem.Style.plain,
                                                           target:self,
                                                           action:nil)
        self.navigationItem.setLeftBarButton(logoutButton, animated: true)
        
        ApiHelper().getsRequest(url: EndPoints().getPreview + "\(String(describing: invoiceIdValue!))", method: "GET", params: [:]) { (result) in
        
            
            self.loadHTMLStringImage(string: result as! String)

        }

        // Do any additional setup after loading the view.
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
    func loadHTMLStringImage(string: String) -> Void {
       
        previewWebView.loadHTMLString(string, baseURL: nil)
    }

    @IBAction func cancelBtnAction(_ sender: Any) {
        
    self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
        
    }
}
