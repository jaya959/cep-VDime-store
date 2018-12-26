//
//  ApiHelper.swift
//  CEP
//
//  Created by jaya kumar on 27/11/18.
//  Copyright © 2018 jaya kumar. All rights reserved.
//

import UIKit
import Alamofire


class ApiHelper: NSObject {
    
    func patchRequest(url:String, method: String, params: [String: Any], completion: @escaping (AnyObject)->() ){
        
        
        
        let headers = ["oic-authorization" : "Bearer "+"\(UserDefaults.standard.value(forKey: "Oic-Auth")!)","oic-refresh-token":"Bearer "+"\(UserDefaults.standard.value(forKey: "Oic-ref")!)",
            "Content-Type": "application/json"]
        
        Alamofire.request(url, method: .patch, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let JSON):
                print(response)
                
                completion(JSON as AnyObject)
                
                break
            case .failure(let error):
                
                print(error)
                
                completion(error as AnyObject)
            }
        }
        
    }
    
     func postRequest(url:String, method: String, params: [String: Any], completion: @escaping (AnyObject)->() ){
        
        let headers = ["oic-authorization" : "Bearer "+"\(UserDefaults.standard.value(forKey: "Oic-Auth")!)","oic-refresh-token":"\(UserDefaults.standard.value(forKey: "Oic-ref")!)",
            "Content-Type": "application/json"]
    
    Alamofire.request(url, method: .post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
    response in
    switch response.result {
    case .success(let JSON):
    print(response)
    
    completion(JSON as AnyObject)
    
    break
    case .failure(let error):
    
    print(error)
        
    completion(error as AnyObject)
    }
        }
        
    }
   
    
    func restRequest(url:String, method: String, params: [String: Any], completion: @escaping (AnyObject)->() ){
        if Reachability.isConnectedToNetwork(){
        
        if let nsURL = NSURL(string:url) {
            let request = NSMutableURLRequest(url: nsURL as URL)
            if method == "POST" {
                // convert key, value pairs into param string
               let postString = params.map { "\($0.0)=\($0.1)" }.joined(separator: "&")
                request.httpMethod = "POST"
                request.httpBody = postString.data(using: String.Encoding.utf8)


            }
            else if method == "GET" {
                _ = params.map { "\($0.0)=\($0.1)" }.joined(separator: "&")
                request.httpMethod = "GET"
            }
            else if method == "PUT" {
                let putString = params.map { "\($0.0)=\($0.1)" }.joined(separator: "&")
                request.httpMethod = "PUT"
                request.httpBody = putString.data(using: String.Encoding.utf8)
            }else if method == "PATCH" {
                
                request.httpMethod = "PATCH"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")

                let jsonData = try? JSONSerialization.data(withJSONObject: params)
                request.httpBody = jsonData
                print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
               
            }
           
           if method == "PATCH" && url != EndPoints().verifyUrl && url != EndPoints().registerUserUrl &&  url != EndPoints().resentOtp{
                
                
            let config = URLSessionConfiguration.default

                config.httpAdditionalHeaders = ["oic-authorization" : "Bearer "+"\(UserDefaults.standard.value(forKey: "Oic-Auth")!)","oic-refresh-token":"Bearer "+"\(UserDefaults.standard.value(forKey: "Oic-ref")!)",
                    "Content-Type": "application/json"]
            }
            
//            if   url  == EndPoints().industryProceed ||   {
//
//                let config = URLSessionConfiguration.default
//
//                config.httpAdditionalHeaders = [
//                    "Content-Type": "application/json",
//                    "oic-authorization": UserDefaults.standard.value(forKey: "Oic-Auth")!,
//                    "oic-refresh-token" : UserDefaults.standard.value(forKey: "Oic-ref")!
//
//                ]
//
//            }
            // Add other verbs here
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                (data, response, error) in
                do {
                    
                    // what happens if error is not nil?
                    // That means something went wrong.
                    
                    // Make sure there really is some data
                    if let data = data {
                        let response = try JSONSerialization.jsonObject(with: data, options:  JSONSerialization.ReadingOptions.mutableContainers)
                        completion(response as AnyObject)
                    }
                    else {
                        // Data is nil.
                    }
                } catch let error as NSError {
                    print("json error: \(error.localizedDescription)")
                    
                    completion([] as AnyObject)
                }
            }
            task.resume()
        }
        else{
            // Could not make url. Is the url bad?
        }      // You could call the completion handler (callback) here with some value indicating an error
        }else{
            print("Internet Connection not Available!")
        }
    }
    
    
    
     func getRequest(url:String, method: String, params: [String: Any], completion: @escaping (AnyObject)->() ){
        
        let headers = ["oic-authorization" : "bearer "+"\(UserDefaults.standard.value(forKey: "Oic-Auth")!)","oic-refresh-token":"\(UserDefaults.standard.value(forKey: "Oic-ref")!)",
            "Content-Type": "application/json"]
        
        
        Alamofire.request(url, method : .get, parameters : params, encoding : JSONEncoding.default , headers : headers).responseJSON { dataResponse in

            print(dataResponse)
            switch dataResponse.result {
            case .success(let JSON):
                
                completion(JSON as AnyObject )
                
                break
            case .failure(let error):
                
                print(error)
                
                completion(error as AnyObject)
            }
            
            
        }

    }
    
    
    func getsRequest(url:String, method: String, params: [String: Any], completion: @escaping (AnyObject)->() ){
        
        let headers = ["oic-authorization" : "Bearer "+"\(UserDefaults.standard.value(forKey: "Oic-Auth")!)","oic-refresh-token":"Bearer "+"\(UserDefaults.standard.value(forKey: "Oic-ref")!)",
            "Content-Type": "application/json"]
        
        
        Alamofire.request(url, method : .get, parameters : params, encoding : JSONEncoding.default , headers : headers).responseString(completionHandler: {(response) in
            
            
            completion(response.result.value as AnyObject)
            
        })
        
    }
    
    }
    

// "phoneNumber=919597420472&code=&passwordPresent=true&password=test"

//"phoneNumber=919176401224&code=841369&passwordPresent=false&password=test"
import SystemConfiguration

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}
