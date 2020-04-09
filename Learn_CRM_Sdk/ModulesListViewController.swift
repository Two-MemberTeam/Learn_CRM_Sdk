//
//  ModulesViewController.swift
//  Learn_CRM_Sdk
//
//  Created by ZU-IOS on 06/03/20.
//  Copyright © 2020 ZU-IOS. All rights reserved.
//

import UIKit
import ZCRMiOS

class ModulesListViewController: UIViewController {
    
    let modulesListTableView : UITableView = UITableView()
    var modules : [ZCRMModule] = [ZCRMModule]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showModuleList()
        self.setupModulesListTableView()
        
        self.navigationItem.title = "Modules"
    }
    
    func setupModulesListTableView(){
        self.view.addSubview(modulesListTableView)
        modulesListTableView.delegate = self
        modulesListTableView.dataSource = self
        modulesListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Module")
        self.addConstraint(whichView: modulesListTableView, forView: self.view, top: 88, bottom: -30, leading: 0, trailing: 0)
    }
    
    func showModuleList(){
        
        ZCRMSDKUtil.getModules { (result) in
            switch result{
            case .success(let modules, _):
                self.modules = modules
                
                DispatchQueue.main.async {
                    self.modulesListTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
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

extension ModulesListViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = modulesListTableView.dequeueReusableCell(withIdentifier: "Module", for: indexPath)
        
        let moduleRecord = modules[indexPath.row]
        cell.textLabel?.text = moduleRecord.pluralLabel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moduleRecordsVC  : RecordListViewController = RecordListViewController()
        
        let objectOfModule = modules[indexPath.row]
        let moduleName : String = objectOfModule.pluralLabel
        moduleRecordsVC.moduleName = moduleName

        if objectOfModule.name.contains("CustomModule"){
            moduleRecordsVC.isCustomModule = true
        }else {
            moduleRecordsVC.isCustomModule = false
        }
        
        self.navigationController?.pushViewController(moduleRecordsVC, animated: true)
    }
    
}
