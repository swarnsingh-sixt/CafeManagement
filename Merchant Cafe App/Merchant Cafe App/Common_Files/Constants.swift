/**
 *  @author Swarn Singh.
 */

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import SideMenuSwift

typealias ValidationResult = (error:String,isValid:Bool)

enum SuccessMessage{
    
    case passwordResetMail,userCreated,loginSuccessfull
    case orderReady, orderPicked, orderAccepted, productUpdated
    
    var stringValue:String{
        
        switch self {
            
        case .passwordResetMail:
            return "Password reset mail has been sent successfully. Please check your inbox."
            
        case .userCreated:
            return "User has been registered successfully. We have sent you a verification mail, Verify your mail to login."
            
        case .loginSuccessfull:
            return "Login Successfull."
        case .orderReady:
            return "Order Ready message sent Successfully"
        case .orderPicked:
            return "Order Picked up Successfully"
        case .orderAccepted:
            return "Order Accepted Successfully"
        case .productUpdated:
            return "Product Updated Successfully"
        }
        
    }
    
}

enum ErrorMessage {
    
    case emptyEmail,invalidEmail,emptyPassword,invalidPassword
    case emptyFirstName,emptyLastName,passwordNotMatch,verifyEmail
    case internetConnection, emptyProducts, orderDeclined
    
    var stringValue:String {
        
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
        case .internetConnection:
            return "Please check your internet connection!"
        case .emptyProducts:
            return " don't have any products. Please add new products by clcik on add button"
        case .orderDeclined:
            return "Order Declined Successfully"
        }
    }
    
}

enum AppNotifications:String{
    
    case logout,login
    
    var instance:Notification{
        
        return Notification(name: Notification.Name(self.rawValue))
        
    }
    
}

enum AppStoryBoard:String{
    
    case OrderDetail,Main,Reports
    
    var instance:UIStoryboard{
        
        return UIStoryboard(name: self.rawValue, bundle: nil)
        
    }
    
}


struct Device {
    
    let id = UIDevice.current.identifierForVendor?.uuidString
    let type = UIDevice.current.model
    var token = ""
    let osVersion = UIDevice.current.systemVersion
    
}

class Constants: NSObject {
    
    static var sideMenu: SideMenuController!
    
    static var device = Device()
    
    static var config = Config()
    
    static let dateFormatter = DateFormatter()
    
    static let AppName = "MerchantCafe"
    
    static let ALERT = "Alert"
    
    static let BLANK = ""
    
    static let screenHeight = UIScreen.main.bounds.height
    
    static let screenWidth = UIScreen.main.bounds.width
    
    public static let db: Firestore = Firestore.firestore()
    
    public static let HOME_SEGUE = "HomeViewController"
    
    public static let LOGIN_SEGUE = "LoginViewController"
    
    public static let CATEGORY_PRODUCT_SEGUE = "CategoryProductViewController"
    
    public static let PRODUCT_VIEW_SEGUE = "ProductViewController"
    
    public static let PRODUCT_OP_VIEW_SEGUE = "ProductOperationsViewController"
    
    public static let Category_OP_VIEW_SEGUE = "AddCategoryFormViewController"
    
    public static let ORDER_DETAIL_VIEW_SEGUE = "OrderDetailViewController"
    
    public static let REPORTS_VIEW_SEGUE = "MerchantReportViewController"
    
    public static let PROFILE_VIEW_SEGUE = "ProfileViewController"
    
}
