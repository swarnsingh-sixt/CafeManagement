//
//  ProfileViewController.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 14/06/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import UIKit
import AlamofireImage
import FirebaseStorage
import MBProgressHUD

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var firstNameTextField:UITextField!
    @IBOutlet weak var lastNameTextField:UITextField!

    @IBOutlet weak var profilePictureButton:UIButton!
    
    var imagePath:String?
    
    var isProfilePictureChanged = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Account"
        
        self.setupView()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView(){
        
        profilePictureButton.imageView?.contentMode = .scaleAspectFill
        profilePictureButton.imageView?.clipsToBounds = true
        
        imagePath = User.current.image
        
        if imagePath?.count ?? 0 > 0{
            
            let url = URL(string:imagePath ?? "")
            
            profilePictureButton.af_setImage(for: .normal, url: url!)
            
        }
        
        firstNameTextField.text = User.current.firstName
        lastNameTextField.text = User.current.lastName
        emailTextField.text = User.current.email
        
    }
    
    //MARK: Button Methods
    
    @IBAction func profileButtonPressed(_ sender:UIButton){
        
        if profilePictureButton.image(for: .normal) != nil{
            
            self.showProfilePictureOption()
            
        }else{
            
            self.openImagePickerActionSheet()

        }
        
    }
    
    @IBAction func updateButtonPressed(_ sender:UIButton){
        
        self.validate { result in
            
            if result.isValid{
                
                if self.isProfilePictureChanged{
                    
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    
                    let name = User.current.id + ".png"
                    
                    let storage = Storage.storage().reference(withPath: "ProfilePicture/\(name)")
                    
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/png"
                    
                    let data = UIImagePNGRepresentation((self.profilePictureButton.imageView?.image)!)!
                    
                    storage.putData(data, metadata: metadata, completion: { (metadata, error) in
                        
                        if error == nil{
                            
                            storage.downloadURL(completion: { (url, error) in
                                
                                MBProgressHUD.hide(for: self.view, animated: true)
                                
                                if error == nil{
                                    
                                    self.imagePath = url?.absoluteString
                                    
                                    self.updateData()
                                    
                                }else{

                                    self.showAlert(ErrorMessage.profilePhotoUploadFailed.stringValue)
                                    
                                }
                                
                            })
                            
                        }else{
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            self.showAlert(ErrorMessage.profilePhotoUploadFailed.stringValue)
                            
                        }
                        
                    })
                    
                }else{
                    
                    self.updateData()
 
                }

            }else{
                
                self.showAlert(result.error)
                
            }
            
        }
        
    }
    
    @IBAction func changePasswordButtonPressed(_ sender:UIButton){
        
        
    }

}
