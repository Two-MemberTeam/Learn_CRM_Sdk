//
//  ModuleViewController.swift
//  Learn_CRM_Sdk
//
//  Created by ZU-IOS on 06/03/20.
//  Copyright © 2020 ZU-IOS. All rights reserved.
//

import UIKit
import ZCRMiOS

class ModuleRecordsViewController: UIViewController , customViewDelegate {
    
    
    let recordsTableView : UITableView = UITableView()
    let customListButton : UIButton = UIButton()
    var records : [[String : Any]] = [[String : Any]]()
    var module_Name : String!
    var lead_Status : String = "All Leads"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupModulesTableView()
        self.getRecords()
        self.setupCustomListButton()
        self.navigationItem.title = lead_Status

        
    }
    
    func changeToCustomView(_ lead_Status: String) {
            if lead_Status != "All Leads"{
            self.navigationItem.title = lead_Status
            self.lead_Status = lead_Status
            for record in self.records{
                if lead_Status == "All Leads"{
                    self.records.removeAll()
                }
                let lead_Status : String = record["Lead_Status"] as! String
                if  self.lead_Status == lead_Status {
                    self.records.append(record)
                }
            }
            self.recordsTableView.reloadData()

        }else{
            print("heloo")
        }

        
    }

    func setupModulesTableView(){
        self.view.addSubview(recordsTableView)
        recordsTableView.delegate = self
        recordsTableView.dataSource = self
        recordsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "records")
        
        self.addConstraint(whichView: recordsTableView, forView: self.view, top: 130, bottom: -30, leading: 0, trailing: 0)
    }
    func setupCustomListButton(){
        self.view.addSubview(customListButton)
        customListButton.setTitle("^", for: .normal)
        customListButton.setTitleColor(.white, for: .normal)
        customListButton.frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: 50)
        customListButton.addTarget(self, action: #selector(customViewList), for: .touchUpInside)
        customListButton.backgroundColor = .black
    }
    
    func getRecords(){
        let recordUrlString = "https://www.zohoapis.com/crm/v2/Leads"
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
                                if let recordsList : [[String : Any]] = json["data"] as? [[String : Any]]{
                                    self.records = recordsList
                                  DispatchQueue.main.async {
                                        self.recordsTableView.reloadData()
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
    
    
    @objc func customViewList(){
        let CustomViewsVC  : CustomViewsViewController = CustomViewsViewController()
        CustomViewsVC.module_Name = module_Name
        CustomViewsVC.cv_Delegate = self
        self.present(CustomViewsVC, animated: true, completion: nil)
    }
    
}

extension ModuleRecordsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordsTableView.dequeueReusableCell(withIdentifier: "records", for: indexPath)
        
        let objectOfModule = records[indexPath.row]
        if let name = (objectOfModule["Lead_Status"] ){
            cell.textLabel?.text = "\(name)"
        }
        
        return cell
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let personVC  : personViewController = personViewController()
//        let objectOfPerson = records[indexPath.row]
//        personVC.person = objectOfPerson
//        self.navigationController?.pushViewController(personVC, animated: true)
//    }
    
    
}
