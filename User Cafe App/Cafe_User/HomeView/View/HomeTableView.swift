//
//  HomeTableView.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 25/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return categoryArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let category = categoryArray[indexPath.section]
        
        let labelCell = cell?.viewWithTag(101) as! UILabel
        let imageCell = cell?.viewWithTag(102) as! UIImageView
        
        labelCell.text = category.name
        imageCell.image = nil
        
        if category.image.count > 0{
            
            let url = URL(string:category.image)!
            
            imageCell.af_setImage(withURL: url, placeholderImage: nil, filter: nil, progress: nil, progressQueue: .main, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: nil)
            
        }
        
        cell?.selectionStyle = .none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()

    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let category = categoryArray[indexPath.section]
        
        let productVC = AppStoryBoard.Main.instance.instantiateViewController(withIdentifier: "Product") as! ProductViewController
        
        productVC.cateogry = category
        
        self.navigationController?.pushViewController(productVC, animated: true)
        
    }
    
}
