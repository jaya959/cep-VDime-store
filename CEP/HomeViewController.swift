//
//  HomeViewController.swift
//  CEP
//
//  Created by jaya kumar on 03/12/18.
//  Copyright © 2018 jaya kumar. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController ,UITabBarDelegate ,BusinessSettingsDelegate,StoreSettingsDelegete,InvoiceSettingsDelegete{
    
    @IBOutlet weak var homeTabbar: UITabBar!
    @IBOutlet weak var HeaderView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genaralLabel: UILabel!
    @IBOutlet weak var taskTableView: UITableView!
    
    var taskArray :[Task] = []
    
    var taskSArray : [NSDictionary] = []
    
    enum TableSection: Int {
        
        case trending = 0, general, alert, escalate, overDue,upNext
    }
    
    // This is the size of our header sections that we will use later on.
    let SectionHeaderHeight: CGFloat = 25
    
    // Data variable to track our sorted data.
    var data = [TableSection: [Task]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortData()
        
       // startApi()
        taskTableView.reloadWithAnimation()
        
        HeaderView.isHidden = true
        homeTabbar.delegate = self
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        
        print("phone size",screenWidth,screenHeight)
    
        homeTabbar.selectedItem = homeTabbar.items![0] as UITabBarItem
        
        taskTableView.separatorStyle = .none

     //  taskTableView.tableHeaderView = HeaderView
        
        if let backColor = UIColor(hexString: "#d9e8f5"){
            
            genaralLabel.backgroundColor = backColor
        }
  
        if let items = self.homeTabbar.items {

            //Get the height of the tab bar

            let height = self.homeTabbar.bounds.height

            //Calculate the size of the items

            let numItems = CGFloat(items.count)
            let itemSize = CGSize(
                width: homeTabbar.frame.width / numItems,
                height: homeTabbar.frame.height)

            
            if screenWidth != 414.0 {
                
                if screenWidth == 375.0{
                
            for (index, _) in items.enumerated() {

                //We don't want a separator on the left of the first item.
                
            
                if index > 0 {

                    //Xposition of the item
                    

                    let xPosition = itemSize.width * CGFloat(index)

                    /* Create UI view at the Xposition,
                     with a width of 0.5 and height equal
                     to the tab bar height, and give the
                     view a background color
                     */
                    let separator = UIView(frame: CGRect(
                        x: xPosition, y: 6, width: 0.5, height: height - 10 ))
                    separator.backgroundColor = UIColor.lightGray
                    homeTabbar.insertSubview(separator, at: 1)
                }}
            }
                else{
                    
                    let xPosition = itemSize.width * CGFloat(0.85)
                    
                    /* Create UI view at the Xposition,
                     with a width of 0.5 and height equal
                     to the tab bar height, and give the
                     view a background color
                     */
                    let separator = UIView(frame: CGRect(
                        x: xPosition, y: 6, width: 0.5, height: height - 10 ))
                    separator.backgroundColor = UIColor.lightGray
                    homeTabbar.insertSubview(separator, at: 1)
                    
                    let xPosition1 = itemSize.width * CGFloat(1.7)
                    
                    /* Create UI view at the Xposition,
                     with a width of 0.5 and height equal
                     to the tab bar height, and give the
                     view a background color
                     */
                    let separator1 = UIView(frame: CGRect(
                        x: xPosition1, y: 6, width: 0.5, height: height - 10 ))
                    separator1.backgroundColor = UIColor.lightGray
                    homeTabbar.insertSubview(separator1, at: 1)
                    
                    let xPosition2 = itemSize.width * CGFloat(2.55)
                    
                    /* Create UI view at the Xposition,
                     with a width of 0.5 and height equal
                     to the tab bar height, and give the
                     view a background color
                     */
                    let separator2 = UIView(frame: CGRect(
                        x: xPosition2, y: 6, width: 0.5, height: height - 10 ))
                    separator2.backgroundColor = UIColor.lightGray
                    homeTabbar.insertSubview(separator2, at: 1)
                    
                }
            }else{
                
                let xPosition = itemSize.width * CGFloat(1.1)
                
                /* Create UI view at the Xposition,
                 with a width of 0.5 and height equal
                 to the tab bar height, and give the
                 view a background color
                 */
                let separator = UIView(frame: CGRect(
                    x: xPosition, y: 6, width: 0.5, height: height - 10 ))
                separator.backgroundColor = UIColor.lightGray
                homeTabbar.insertSubview(separator, at: 1)
                
                let xPosition1 = itemSize.width * CGFloat(2.2)
                
                /* Create UI view at the Xposition,
                 with a width of 0.5 and height equal
                 to the tab bar height, and give the
                 view a background color
                 */
                let separator1 = UIView(frame: CGRect(
                    x: xPosition1, y: 6, width: 0.5, height: height - 10 ))
                separator1.backgroundColor = UIColor.lightGray
                homeTabbar.insertSubview(separator1, at: 1)
                
                let xPosition2 = itemSize.width * CGFloat(3.3)
                
                /* Create UI view at the Xposition,
                 with a width of 0.5 and height equal
                 to the tab bar height, and give the
                 view a background color
                 */
                let separator2 = UIView(frame: CGRect(
                    x: xPosition2, y: 6, width: 0.5, height: height - 10 ))
                separator2.backgroundColor = UIColor.lightGray
                homeTabbar.insertSubview(separator2, at: 1)
                
                
            }
        }
    
        if let lineColor = UIColor(hexString: "#3A7BD5"){
            
            let numberOfItems = CGFloat(homeTabbar.items!.count)
            let tabBarItemSize = CGSize(width: homeTabbar.frame.width / numberOfItems, height: homeTabbar.frame.height)
            homeTabbar.selectionIndicatorImage = UIImage.imageWithColor(color: lineColor, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
        }
        // Do any additional setup after loading the view.
        
        
        

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        
        startApi()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    func startApi() {
        
        taskArray.removeAll()
        
        ApiHelper().getRequest(url: EndPoints().getTask, method: "GET", params: [:]) { (result) in
            
            let jsonResult: NSDictionary = result as! NSDictionary
            
            
            if let responesJson: NSDictionary = jsonResult.value(forKey: "data") as? NSDictionary {
                
                let jsonValue = responesJson.value(forKey: "data") as! [NSDictionary]
                
                for value in jsonValue {
                    
                    let taskObj = Task()
                    
                    taskObj.id = value.object(forKey: "id") as? String
                    
                    taskObj.escalationType  = value.object(forKey:"escalationType") as? String
                    
                    taskObj.isClientOnly = value.object(forKey: "isClientOnly") as? Bool
                    
                    taskObj.isCompleted = value.object(forKey: "isCompleted") as? Bool
                    
                    taskObj.isDeleted = value.object(forKey: "isDeleted") as? String
                    
                    taskObj.name = value.object(forKey: "name") as? String
                    
                    taskObj.subType = value.object(forKey: "subType") as? String
                    
                    taskObj.taskType =   value.object(forKey: "taskType") as? String
                    
                    taskObj.updatedAt = value.object(forKey: "updatedAt") as? String
                    
                    let dict = value.object(forKey: "data") as! NSDictionary
                    
                    taskObj.progress = dict.object(forKey: "progress") as? String
                    
                    self.taskArray.append(taskObj)
                }
                
                
                DispatchQueue.main.async(execute: {
                    
                    self.sortData()
                    
                    let tabbar1 =  self.homeTabbar!.items?.first as! UITabBarItem
                    
                    tabbar1.badgeColor = UIColor.red
                    
                    tabbar1.badgeValue = "\(self.taskArray.count)"
                    
                    // tabbar1.badgeValue = "\(100)"
                })
            }
            
        }
        
    }
    func sortData() {
 
        data[.general] = taskArray.filter({ $0.escalationType == "GENERAL" })
        
        data[.alert] = taskArray.filter({ $0.escalationType == "ALERT" })
        
         data[.overDue] = taskArray.filter({ $0.escalationType == "OVERDUE" })
        
        data[.escalate] = taskArray.filter({ $0.escalationType == "ESCALATED" })
        
        data[.trending] = taskArray.filter({ $0.escalationType == "TRENDING" })
        
         data[.upNext] = taskArray.filter({ $0.escalationType == "UPCOMING" })
        
       taskTableView.reloadWithAnimation()
       
    }
    
    func stringToDate(date:String) -> Date {
        let formatter = DateFormatter()
        
        // Format 1
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let parsedDate = formatter.date(from: date) {
            return parsedDate as Date
        }
        
        // Format 2
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSSZ"
        if let parsedDate = formatter.date(from: date) {
            return parsedDate as Date
        }
        
        // Couldn't parsed with any format. Just get the date
        let splitedDate = date.components(separatedBy: "T")
        if splitedDate.count > 0 {
            formatter.dateFormat = "yyyy-MM-dd"
            if let parsedDate = formatter.date(from: splitedDate[0]) {
                return parsedDate as Date
            }
        }
        
        
        return Date()
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if(item.tag == 0) {
            
           
            if taskTableView.isHidden{
            taskTableView.isHidden = false
            
            taskTableView.reloadWithAnimation()
            
            titleLabel.isHidden = false
            }
            
        }else if(item.tag == 2) {
            
            taskTableView.isHidden = true
            
            titleLabel.isHidden = true
            
        }else if(item.tag == 2) {
            
            taskTableView.isHidden = true
            titleLabel.isHidden = true
        }else{
            
            taskTableView.isHidden = true
            titleLabel.isHidden = true
        }
    }
    
    
    

}

extension HomeViewController : UITableViewDelegate , UITableViewDataSource , UIScrollViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Using Swift's optional lookup we first check if there is a valid section of table.
        // Then we check that for the section there is data that goes with.
        if let tableSection = TableSection(rawValue: section), let movieData = data[tableSection] {
            return movieData.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath as IndexPath)
        
         if let tableSection = TableSection(rawValue: indexPath.section), let movie = data[tableSection]?[indexPath.row] {
            
            let title = cell.viewWithTag(5) as! UILabel

            title.text = movie.name
            
            let textLabel = cell.viewWithTag(7) as! UILabel
            
            textLabel.text = movie.progress
            
            let date = stringToDate(date: movie.updatedAt!)
          
            let timeLabel = cell.viewWithTag(6) as! UILabel
            
            timeLabel.text = date.relativeTime

        }
        
        let firstView = cell.viewWithTag(1)
        
        firstView!.backgroundColor = UIColor.init(hexString: "#89C1F3")

//        firstView!.layer.shadowColor = UIColor.black.cgColor
//        firstView!.layer.shadowOpacity = 1
//        firstView!.layer.shadowOffset = CGSize.zero
//        firstView!.layer.shadowRadius = 10
//        firstView!.layer.shadowPath = UIBezierPath(rect: firstView!.bounds).cgPath
//        firstView!.layer.shouldRasterize = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let taskObj = taskArray[indexPath.row]
        
        
        
        if taskObj.subType == "BUSINESS"{
            
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BusinessSettingsViewController") as! BusinessSettingsViewController
        nextViewController.delegate = self
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
        }else if  taskObj.subType == "STORE"{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "StoreSettingsViewController") as! StoreSettingsViewController
            
        
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else if taskObj.subType == "INVOICE"{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "InvoicePreviewViewController") as! InvoicePreviewViewController
           // nextViewController.delegete = self
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // If we wanted to always show a section header regardless of whether or not there were rows in it,
        // then uncomment this line below:
        //return SectionHeaderHeight
        // First check if there is a valid section of table.
        // Then we check that for the section there is more than 1 row.
        if let tableSection = TableSection(rawValue: section), data[tableSection] != [], taskArray.count > 0 {

            return SectionHeaderHeight
            
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let views = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
        views.backgroundColor = UIColor.groupTableViewBackground
      
        let label = UILabel(frame: CGRect(x: tableView.center.x - 40, y: 10, width: 90, height: SectionHeaderHeight - 5))
        
        label.textAlignment = .center
        label.layer.borderWidth = 0.5
        label.layer.cornerRadius = label.frame.height / 2
        
        label.font = UIFont.init(descriptor: UIFontDescriptor.init(name: "Roboto-Regular", size: 12), size: 12)
        

        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .trending:
                
                if let count = data[.trending]?.count{
                    
                    label.text = "👻 Trending:\(count)"
                    
                    
                }
                
                label.textColor = UIColor.white
                
                label.layer.borderColor =  UIColor.init(red:21.0/255 , green: 68.0 / 255, blue: 141.0/255.0, alpha: 1.0).cgColor
                
                label.layer.masksToBounds = true
                
                label.backgroundColor = UIColor.init(red:55.0/255 , green: 125.0 / 255, blue: 233.0/255.0, alpha: 1.0)
                
            case .general:
                
                if let count = data[.general]?.count{
                    
                    label.text = "🙂 Genaral: \(count)"
                    
                }
               
                label.textColor = UIColor.black
                
            label.layer.borderColor =  UIColor.init(red:137.0/255 , green: 193.0 / 255, blue: 243/255.0, alpha: 1.0).cgColor
               
                
                 label.layer.masksToBounds = true
                
                label.backgroundColor = UIColor.init(red:217.0/255 , green: 232.0 / 255, blue: 245.0/255.0, alpha: 1.0)
            case .overDue:
                if let count = data[.overDue]?.count{
                    
                    label.text = "😕 Overdue: \(count)"
                    
                }
                
                label.textColor = UIColor.black
                
                label.layer.borderColor =  UIColor.init(red:237.0/255 , green: 183.0 / 255, blue: 90.0/255.0, alpha: 1.0).cgColor
               label.layer.masksToBounds = true
                 label.backgroundColor = UIColor.init(red:248.0/255 , green: 220.0 / 255, blue: 171.0/255.0, alpha: 1.0)
                
                
            case .alert:
                
                if let count = data[.alert]?.count{
                    
                    label.text = "😥 Alert:\(count)"
                    
                }
                
                
                label.textColor = UIColor.white
                
                label.layer.borderColor =  UIColor.init(red:238.0/255 , green: 42.0 / 255, blue: 42.0/255.0, alpha: 1.0).cgColor
            label.layer.masksToBounds = true
                label.backgroundColor = UIColor.init(red:255.0/255 , green: 102.0 / 255, blue: 102.0/255.0, alpha: 1.0)
            case .escalate:
                
                if let count = data[.escalate]?.count{
                    
                    label.text = "😩 Escalate: \(count)"
                    
                }
               
                label.textColor = UIColor.darkText
                
                  label.layer.borderColor =  UIColor.init(red:39.0/255 , green: 114.0 / 255, blue: 13.0/255.0, alpha: 1.0).cgColor
                label.layer.masksToBounds = true
                label.backgroundColor = UIColor.init(red:238.0/255 , green: 42.0 / 255, blue: 42.0/255.0, alpha: 1.0)
            default:
                label.textColor = UIColor.black
                if let count = data[.upNext]?.count{
                    
                     label.text = "😎 Up Next: \(count)"
                    
                }
               
              label.layer.borderColor =  UIColor.init(red:29.0/255 , green: 190.0 / 255, blue: 100.0/255.0, alpha: 1.0).cgColor
               label.layer.masksToBounds = true
                label.backgroundColor = UIColor.init(red:120.0/255 , green: 252.0 / 255, blue: 178.0/255.0, alpha: 1.0)
                
            }
        }
        
        views.addSubview(label)
        return views
    }
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        var alpha: CGFloat = 1
//        if scrollView.contentOffset.y < 1 {
//            alpha = 0
//        } else if scrollView.contentOffset.y >= 1 && scrollView.contentOffset.y < 20 {
//            alpha = scrollView.contentOffset.y / CGFloat(20)
//        }
//        task.sectionIndexColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
//        tableView.sectionIndexBackgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: alpha)
//    }
    
    
}

class Task : NSObject{
    
    var id : String?
    
    var escalationType : String?
    
    var  isCompleted: Bool?
    
    var isClientOnly : Bool?
    
    var updatedAt : String?
    
    var taskType  :  String?
    
    var subType : String?
    
    var name : String?
    
    var isDeleted : String?
    
    var progress : String?

}
