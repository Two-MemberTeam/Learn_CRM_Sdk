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
    var crmRecord : [ZCRMRecord] = [ZCRMRecord]()

    
    
    var person : [String : Any] = [String : Any]()
    var personKeys : [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupModulesTableView()
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
    
    func setupModulesTableView(){
        self.view.addSubview(modulesTableView)
        
        modulesTableView.delegate = self
        modulesTableView.dataSource = self
        modulesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "person")
        
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
        var cell = modulesTableView.dequeueReusableCell(withIdentifier: "person", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "person")
        let objectOfRecord = self.crmRecord[0]
        if let recordsValue : [String : Any] = objectOfRecord.getData() as? [String : Any]{
            print(recordsValue)
            let key : String = personKeys[indexPath.row]
            
            if let textValue : String = recordsValue[key] as? String {
                cell.detailTextLabel?.text = textValue
                cell.detailTextLabel?.font = .systemFont(ofSize: 24)
            }
            cell.textLabel?.text = key
            cell.textLabel?.font = .systemFont(ofSize: 18)

        }

        return cell
    }
    
    
    
    
}
