//
//  HomeViewController.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 25/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import UIKit
import DualSlideMenu
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    @IBOutlet weak var categoryListTableView:UITableView!
    
    var categoryArray = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryListTableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name: AppNotifications.logout.instance.name, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBadge), name: AppNotifications.productQtyChange.instance.name, object: nil)
        
        self.navigationController?.navigationBar.tintColor = .white
        
        self.getCategories()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if User.current.state == .loggedOut{
         
            performSegue(withIdentifier: "login", sender: self)
            
        }
        
        self.updateBadge()
        
    }
    
    //MARK: Notification Listner
    
    @objc func userDidLogout(){
        
        performSegue(withIdentifier: "login", sender: self)
        
    }
    
    //MARK: Button Methods

    @IBAction func sideMenuPressed(_ sender:UIButton){
        
        Constants.sideMenuController.toggle(swipeDirection: SwipeDirection.right.rawValue)
    }
    
    @IBAction func cartButtonPressed(_ sender:UIButton){
        
        Constants.sideMenuController.toggle(swipeDirection: SwipeDirection.left.rawValue)
        
    }
    
}

extension HomeViewController{
        
    //MARK: WebAPI Method
    
    func getCategories(){
        
        Firestore.firestore().collection(Database.Collection.category.rawValue).whereField("is_active", isEqualTo: true).addSnapshotListener { (snapshot, error) in
            
            if error == nil{
                
                self.categoryArray.removeAll()
                
                for document in (snapshot?.documents)!{
                    
                    let category = Category(info: document.data(), id: document.documentID)
                    self.categoryArray.append(category)
                }
                
                self.categoryArray = self.categoryArray.filter{$0.products.count > 0}

                self.categoryArray = self.categoryArray.sorted(by: { (cat1, cat2) -> Bool in
                    return cat1.name.localizedCaseInsensitiveCompare(cat2.name) == .orderedAscending
                })
                
                self.categoryListTableView.reloadData()
                
            }
            
        }
        
    }
    
}
