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
    func changeToCustomView(_ lead_Status : String)
}


class CustomViewsViewController: UIViewController {

    let customViewTableView : UITableView = UITableView()
    var customViewRecords : [[String : Any]] = [[String : Any]]()
    var module_Name : String!
    var cv_Delegate : customViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCustomViewTableView()
        self.getRecords()

    }
    
    func setupCustomViewTableView(){
        self.view.addSubview(customViewTableView)
        customViewTableView.delegate = self
        customViewTableView.dataSource = self
        customViewTableView.register(UITableViewCell.self, forCellReuseIdentifier: "records")
        
        self.addConstraint(whichView: customViewTableView, forView: self.view, top: 60, bottom: -30, leading: 20, trailing: -10)
        
    }
    
    func getRecords(){
        let recordUrlString = "https://www.zohoapis.com/crm/v2/settings/custom_views?module=\(module_Name!)"
        let recordUrl : URL
            = URL(string: recordUrlString)!
        
        ZohoAuth.getOauth2Token { ( token, error ) in
            if error == nil {
                var request = URLRequest(url: recordUrl)
                let oauthtoken = "Zoho-oauthtoken \(token!)"
                request.setValue(oauthtoken, forHTTPHeaderField: "Authorization")
                
                let session = URLSession.shared
                
                let task = session.dataTask(with: request) { (data, responce, error) in
                    if error == nil {
                        do{
                            if let json : [String : Any] = try (JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]) {
                                print(json)
                                if let customViewRecords : [[String : Any]] = json["custom_views"] as? [[String : Any]]{
                                    self.customViewRecords = customViewRecords
                                    DispatchQueue.main.async {
                                        self.customViewTableView.reloadData()
                                    }
                                }
                            }
                        }catch{
                            print("error - \(error)")
                        }
                    }
                }
                task.resume()
            }
        }
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
        return customViewRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customViewTableView.dequeueReusableCell(withIdentifier: "records", for: indexPath)
        
        let objectOfModule = customViewRecords[indexPath.row]
        if let name = (objectOfModule["display_value"] ){
            cell.textLabel?.text = "\(name)"
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objectOfLead = customViewRecords[indexPath.row]
        let Lead_Status : String = objectOfLead["display_value"] as! String
        
        cv_Delegate?.changeToCustomView(Lead_Status)
        
        self.dismiss(animated: false, completion: nil)

    }
    
    
}
