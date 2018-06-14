//
//  Constants.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 22/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import Foundation
import UIKit
import DualSlideMenu

typealias ValidationResult = (error:String,isValid:Bool)

enum SuccessMessage{
    
    case passwordResetMail,userCreated,loginSuccessfull,orderPlaced,profileUpdated,passwordChanged
    
    var stringValue:String{
        
        switch self {
            
        case .orderPlaced:
            return "Order placed successfully."
            
        case .passwordResetMail:
            return "Password reset mail has been sent successfully. Please check your inbox."

        case .userCreated:
            return "User has been registered successfully. We have sent you a verification mail, Verify your mail to login."
            
        case .loginSuccessfull:
            return "Login Successfull."
            
        case .profileUpdated:
            return "Profile updated successfully."
            
        case .passwordChanged:
            return "Password changed successfully."
        }
        
    }
    
}

enum ErrorMessage{
    
    case emptyEmail,invalidEmail,emptyPassword,invalidPassword
    case emptyFirstName,emptyLastName,passwordNotMatch,verifyEmail
    case incorrectPreviousPassword
    
    var stringValue:String{
        
        switch self {
        case .emptyEmail:
            return "Please enter email address."
        case .invalidEmail:
            return "Please enter valid email address."
        case .emptyPassword:
            return "Please enter password."
        case .invalidPassword:
            return "Password should contain atleast 1 capital, 1 digit and 1 special character with minimum lenght of 8 characters."
        case .emptyFirstName:
            return "Please enter first name."
        case .emptyLastName:
            return "Please enter last name."
        case .passwordNotMatch:
            return "Password and confirm password not match."
        case .verifyEmail:
            return "Your email is not verified. Please verify it first."
            
        case .incorrectPreviousPassword:
            return "You have entered incorrect previous password."
        
        }
        
    }
    
}

enum AppNotifications:String{
    
    case logout,login,productQtyChange
    
    var instance:Notification{
        
        return Notification(name: Notification.Name(self.rawValue))
        
    }
    
}

struct Device {
    
    let id = UIDevice.current.identifierForVendor?.uuidString
    let type = UIDevice.current.model
    var token = ""
    let osVersion = UIDevice.current.systemVersion
    
}

enum AppStoryBoard:String{
    
    case Login,Main
    
    var instance:UIStoryboard{
        
        return UIStoryboard(name: self.rawValue, bundle: nil)
        
    }
    
}

class Constants: NSObject {
    
    static let AppName = "ITT Cafe"
    
    static var device = Device()
    
    static let adminPushID = "632817096151@gcm.googleapis.com"
    
    static let screenHeight = UIScreen.main.bounds.height

    static let screenWidth = UIScreen.main.bounds.width

    static var sideMenuController:DualSlideMenuViewController!
    
    static let dateFormatter = DateFormatter()
    
    class func generateOTP()->String{
        
        var result = ""
        
        repeat{
            
            result += "\(arc4random_uniform(10000))"
            
        }while(result.count < 4)
        
        return result
        
    }
    
}

enum SwipeDirection:String{

    case left,right
}



