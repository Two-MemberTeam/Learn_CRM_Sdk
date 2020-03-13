//
//  personViewController.swift
//  Learn_CRM_Sdk
//
//  Created by ZU-IOS on 10/03/20.
//  Copyright © 2020 ZU-IOS. All rights reserved.
//

import UIKit
import ZCRMiOS

class personViewController: UIViewController {
    
    let modulesTableView : UITableView = UITableView()
    let personImageView : UIImageView = UIImageView()
    var person : [String : Any] = [String : Any]()
    let personKeys : [String] = ["Designation", "$review_process", "$approval", "$state", "Country", "Created_By", "Phone", "$converted_detail", "Full_Name", "City", "Email", "Skype_ID", "$approved", "Record_Image", "Fax", "$converted", "Created_Time", "Street", "$review", "No_of_Employees", "Website", "Secondary_Email", "Modified_By", "Industry", "$process_flow", "Modified_Time", "Description", "Owner", "Twitter", "Zip_Code", "Lead_Source", "Email_Opt_Out", "$orchestration", "Last_Activity_Time", "First_Name", "Salutation", "Rating", "Annual_Revenue", "$currency_symbol", "Company", "$editable", "Lead_Status", "Last_Name", "Tag", "id", "Mobile", "State"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupModulesTableView()
        self.getProfileImage()
        self.setupPersonImageView()
        self.navigationItem.title = "Detials"
    }
    
    func setupPersonImageView(){
        let width : CGFloat = self.view.frame.width / 100
        
        self.view.addSubview(personImageView)
        personImageView.image = UIImage(systemName: "ssokit_avatar")
        personImageView.layer.cornerRadius = width * 18
        personImageView.layer.borderWidth = 2
        personImageView.layer.masksToBounds = true
    }
    func getProfileImage(){
        
        let profileUrlString : String = person["Record_Image"] as! String
        let profileUrl = URL(string: profileUrlString)
        
        ZohoAuth.getOauth2Token { ( token, error ) in
            
            if error == nil{
                
                var request = URLRequest(url: profileUrl!)
                let oauthtoken = "Zoho-oauthtoken \(token!)"
                request.setValue(oauthtoken, forHTTPHeaderField: "Authorization")
                
                let session = URLSession.shared
                
                let task = session.dataTask(with: request) { (data, response, error) in
                    if(error == nil){
                        
                        if let imageData = data{
                            DispatchQueue.main.async {
                                self.personImageView.image = UIImage(data: imageData)
                                
                            }
                        }
                    }else{
                        print(error as Any)
                    }
                    
                }
                task.resume()
            }
            
            
            
        }
        
        
        
        
    }
    
    func setupModulesTableView(){
        self.view.addSubview(modulesTableView)
        
        modulesTableView.delegate = self
        modulesTableView.dataSource = self
        modulesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Module")
        
        self.addConstraint(whichView: modulesTableView, forView: self.view, top: 60, bottom: -30, leading: 0, trailing: 0)
    }
    
    
    func addConstraint(whichView : UIView , forView : UIView , top : CGFloat , bottom : CGFloat , leading : CGFloat , trailing : CGFloat ){
        
        whichView.translatesAutoresizingMaskIntoConstraints = false
        
        whichView.topAnchor.constraint(equalTo: forView.topAnchor, constant: top).isActive = true
        whichView.bottomAnchor.constraint(equalTo: forView.bottomAnchor, constant: bottom).isActive = true
        whichView.leadingAnchor.constraint(equalTo: forView.leadingAnchor, constant: leading).isActive = true
        whichView.trailingAnchor.constraint(equalTo: forView.trailingAnchor, constant: trailing).isActive = true
    }
    
    
}

extension personViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = modulesTableView.dequeueReusableCell(withIdentifier: "Module", for: indexPath)
        
        if let text : String = person[personKeys[indexPath.row]] as? String {
            cell.textLabel?.text = text
        }
        
        return cell
    }
    
    
    
    
}
