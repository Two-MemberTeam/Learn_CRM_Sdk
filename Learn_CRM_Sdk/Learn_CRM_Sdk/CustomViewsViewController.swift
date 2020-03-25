//
//  CustomViewsViewController.swift
//  Learn_CRM_Sdk
//
//  Created by ZU-IOS on 10/03/20.
//  Copyright © 2020 ZU-IOS. All rights reserved.
//

import UIKit
import ZCRMiOS

protocol customViewDelegate : class{
    func changeToCustomView(_ leadStatus : String , _ cvRow : Int)
}

class CustomViewsViewController: UIViewController {

    let customViewTableView : UITableView = UITableView()
    var customViews : [ZCRMCustomView] = [ZCRMCustomView]()

    var customViewRecords : [[String : Any]] = [[String : Any]]()
    var module_Name : String!
    var cv_Delegate : customViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCustomViewTableView()

    }
    
    func setupCustomViewTableView(){
        self.view.addSubview(customViewTableView)
        customViewTableView.delegate = self
        customViewTableView.dataSource = self
        customViewTableView.register(UITableViewCell.self, forCellReuseIdentifier: "customView")
        
        self.addConstraint(whichView: customViewTableView, forView: self.view, top: 60, bottom: -30, leading: 20, trailing: -10)
        
    }
    
    
    func addConstraint(whichView : UIView , forView : UIView , top : CGFloat , bottom : CGFloat , leading : CGFloat , trailing : CGFloat ){
        
        whichView.translatesAutoresizingMaskIntoConstraints = false
        
        whichView.topAnchor.constraint(equalTo: forView.topAnchor, constant: top).isActive = true
        whichView.bottomAnchor.constraint(equalTo: forView.bottomAnchor, constant: bottom).isActive = true
        whichView.leadingAnchor.constraint(equalTo: forView.leadingAnchor, constant: leading).isActive = true
        whichView.trailingAnchor.constraint(equalTo: forView.trailingAnchor, constant: trailing).isActive = true
    }
    
    
}

extension CustomViewsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customViews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customViewTableView.dequeueReusableCell(withIdentifier: "customView", for: indexPath)
        
        let objectOfCustomView = customViews[indexPath.row]
        cell.textLabel?.text = objectOfCustomView.displayName as? String
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let LeadStatus : String = customViews[indexPath.row].displayName as! String
        
        cv_Delegate?.changeToCustomView(LeadStatus , indexPath.row)
        
        self.dismiss(animated: false, completion: nil)

    }
    
    
}




