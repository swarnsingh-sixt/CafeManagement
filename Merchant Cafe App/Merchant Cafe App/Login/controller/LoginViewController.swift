/**
 *  @author Swarn Singh.
 */

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MBProgressHUD

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: CustomTextField!
    
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    @IBOutlet weak var loginButton: CustomButton!
    
    @IBOutlet weak var forgotPasswordLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func isValidEmail(email:String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@",emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func isValidPassword(password:String?) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{6,}"
        
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        
        return passwordTest.evaluate(with: password!)
    }
    
    private func showAlert(message:String?) {
        let alert = UIAlertController(title: "Alert?", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func isLoginFieldValid(email:String?, password:String?) -> Bool {
        var isFieldsValid = true
        if (email == nil || email == "") {
            showAlert(message: ErrorMessage.emptyEmail.stringValue)
            isFieldsValid = false
        } else {
            if (!isValidEmail(email: email)) {
                showAlert(message: ErrorMessage.invalidEmail.stringValue)
                isFieldsValid = false
            }
        }
        
        if (password == nil || password == "") {
            showAlert(message: ErrorMessage.emptyPassword.stringValue)
            isFieldsValid = false
        } else {
            if (!isValidPassword(password: password)) {
                isFieldsValid = false
                showAlert(message: ErrorMessage.invalidPassword.stringValue)
            }
        }
        return isFieldsValid
    }
    
    @IBAction func onResetPassword(_ sender: Any) {
        
    }
    
    private func isMerchantUser(email: String?) -> Bool {
        
        let emails = Constants.config.admins.map{$0.email}
        
        return emails.contains(email!)
    }
    
    @IBAction func onLogin(_ sender: Any) {
        
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (isLoginFieldValid(email: email, password: password)) {
            if Connectivity.isConnectedToInternet {
                if isMerchantUser(email: email) {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    
                    Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                        
                        if (error == nil && user != nil) {
                            
                            let device = ["device":["id":Constants.device.id ?? "",
                                                    "model":Constants.device.type,
                                                    "os_version":Constants.device.osVersion,
                                                    "token":Constants.device.token]]
                            
                            var userInfo = Constants.config.admins.filter{$0.email == email!}.first!.jsonRepresentation as [String:Any]
                            userInfo["account_info"] = device
                            
                            Constants.db.collection(Database.Collection.admin.rawValue).document("1").setData(userInfo, merge: true, completion: { (error) in
                                
                                if error == nil {
                                    
                                    PreferenceManager.setUserLogin(isUserLogin: true)
                                    Firestore.firestore().collection(Database.Collection.admin.rawValue).document("1").getDocument(completion: { (snapshot, error) in
                                        
                                        if error == nil {
                                            
                                            User.current.email = email!
                                            
                                            User.current.syncWithFirebase {
                                                MBProgressHUD.hide(for: self.view, animated: true)
                                                self.dismiss(animated: true, completion: nil)
                                            }
                                        }  else {
                                            MBProgressHUD.hide(for: self.view, animated: true)
                                        }
                                    })
                                } else {
                                   MBProgressHUD.hide(for: self.view, animated: true)
                                }
                            })
                        } else {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            PreferenceManager.setUserLogin(isUserLogin: false)
                            let errorMsg = (error?.localizedDescription ?? "Username or Password is invalid!")
                            self.showAlert(errorMsg)
                            print("Error Logged In : \(errorMsg) ")
                        }
                    }
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    showAlert(message: "You are not an authorized merchant user!")
                }
            } else {
                showAlert(message: ErrorMessage.internetConnection.stringValue)
            }
        }
    }
}
