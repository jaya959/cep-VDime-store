//
//  EndPoints.swift
//  CEP
//
//  Created by jaya kumar on 27/11/18.
//  Copyright © 2018 jaya kumar. All rights reserved.
//

import UIKit

class EndPoints: NSObject {
    
    var baseUrl: String
    var registerUserUrl: String
    var verifyUrl: String
    var setPassword : String
    var enterPassword : String
     var resentOtp : String
    var getIndustry : String
    
    var cancelApi: String
    var industryProceed : String
    
    var userStoreSettings : String
    
    var businessSettingsSave1 : String
    
    var businessSettingsSave2 : String
    
    var storeSettings : String
    
    var storeSave1 : String
    
    var storeSave2 : String
    
    var uploadKey : String
    
    var sarverImg : String
    
    var invoicePatch : String
    
    var getPreview : String
    
    var getTask : String
    
    var industryDone : String
    
    var industrySkip : String
    
    var storePost: String
    
    var businessPost : String
    
        // MARK: - Init functions
    override init() {
        
        sarverImg  = "https://upload.oicapps.com/"
        
        baseUrl = "https://accounts-dev.oicapps.com/"
        
        registerUserUrl = baseUrl + "api/v1/account_service/auth/accounts"
        
        verifyUrl = baseUrl + "api/v1/account_service/auth/accounts/verify"
       
        setPassword = baseUrl + "api/v1/account_service/auth/accounts/setpassword"
        
        enterPassword = baseUrl + "api/v1/account_service/auth/accounts/setpassword"
        
        resentOtp = baseUrl + "api/v1/account_service/auth/accounts/resendotp"
        
        
        cancelApi = baseUrl + "api/v1/account_service/auth/accounts/cancelotp"
        
        getIndustry = baseUrl + "api/v1/account_service/auth/accounts/meta/accounts"
        
        industryProceed = baseUrl + "api/v1/account_service/account"
        
        userStoreSettings = baseUrl + "api/v1/account_service/auth/accounts/meta/users"
        
        businessSettingsSave1 = baseUrl + "api/v1/account_service/account"
        
        
        businessSettingsSave2 = baseUrl + "api/v1/account_service/users/" 
        
        storeSettings = baseUrl + "api/v1/account_service/auth/accounts/meta/stores"
        
        
        storeSave1 = baseUrl + "api/v1/account_service/stores/"
        
        storeSave2 = baseUrl + "api/v1/account_service/users/"
        
        uploadKey = sarverImg + "api/v1/upload/admin"
        
        invoicePatch = baseUrl + "api/v1/account_service/stores/"
        
        getPreview = baseUrl + "api/v1/account_service/stores/getinvoice/"
        
        getTask = baseUrl + "api/v1/account_service/tasks"
        
        industryDone = baseUrl + "api/v1/account_service/tasks/taskengine/cg2"
        
        industrySkip = baseUrl + "api/v1/account_service/tasks/taskengine/cg1"
        
        storePost = baseUrl + "api/v1/account_service/tasks/taskengine/cg4"
        
        businessPost = baseUrl + "api/v1/account_service/tasks/taskengine/cg3"
    }
}


