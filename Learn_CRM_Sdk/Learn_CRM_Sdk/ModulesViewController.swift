//
//  ModulesViewController.swift
//  Learn_CRM_Sdk
//
//  Created by ZU-IOS on 06/03/20.
//  Copyright © 2020 ZU-IOS. All rights reserved.
//

import UIKit
import ZCRMiOS

class ModulesViewController: UIViewController {
    
    let modulesTableView : UITableView = UITableView()
    var modules : [ZCRMModule] = [ZCRMModule]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getModules()
        self.setupModulesTableView()
    
        self.navigationItem.title = "Modules"
    }
    
    func setupModulesTableView(){
        self.view.addSubview(modulesTableView)
        
        modulesTableView.delegate = self
        modulesTableView.dataSource = self
        modulesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Module")
        
        self.addConstraint(whichView: modulesTableView, forView: self.view, top: 60, bottom: -30, leading: 0, trailing: 0)
    }
    
    func getModules(){
        ZCRMSDKUtil.getModules { (result) in
            switch result{
            case .success(let modules, let bulkResponce):
                self.modules = modules
                for module in self.modules {
                    print(module.name)
                }
                DispatchQueue.main.async {
                    self.modulesTableView.reloadData()
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

extension ModulesViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = modulesTableView.dequeueReusableCell(withIdentifier: "Module", for: indexPath)
        
        let objectOfModule = modules[indexPath.row]
        cell.textLabel?.text = objectOfModule.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moduleRecordsVC  : ModuleRecordsViewController = ModuleRecordsViewController()
        let objectOfModule = modules[indexPath.row]
        let module_Name : String = objectOfModule.name
        moduleRecordsVC.module_Name = module_Name
        self.navigationController?.pushViewController(moduleRecordsVC, animated: true)
    }
    
    
    
}
