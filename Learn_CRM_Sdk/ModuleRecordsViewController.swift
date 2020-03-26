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
    var customViews : [ZCRMCustomView] = [ZCRMCustomView]()
    var crmRecord : [ZCRMRecord] = [ZCRMRecord]()
    
    var records : [[String : Any]] = [[String : Any]]()
    var module_Name : String!
    var leadStatus : String = "All Leads"
    var cvRow : Int = 0
    var ofFieldAPIName : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupModulesTableView()
        self.getCustomeView(moduleName: module_Name)
        
        self.setupCustomListButton()
        
        
    }
    
    func changeToCustomView(_ leadStatus: String , _ cvRow : Int) {
        self.leadStatus = leadStatus
        self.cvRow = cvRow
        self.getCustomeView(moduleName: module_Name)
        self.navigationItem.title = leadStatus
        
        
        
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
    
    
    func getCustomeView(moduleName : String){
        
        ZCRMSDKUtil.getModuleDelegate(apiName: moduleName ).getCustomViews { (result) in
            switch result{
            case .success(let customViews, let bulkResponce):
                self.customViews = customViews
                if self.customViews.count != 0{
                    self.getRecords(moduleName : self.module_Name , cvId : self.customViews[self.cvRow].id)
                    self.leadStatus = self.customViews[self.cvRow].name
                    
                }else{
                    self.getRecords(moduleName : self.module_Name )
                    
                }
                
            case .failure(let error):
                print("Error  -  \(error)")
                self.getRecords(moduleName : self.module_Name )
            }
        }
        
    }
    
    func getRecords(moduleName : String , cvId : Int64){
        
        ZCRMSDKUtil.getModuleDelegate(apiName: moduleName).getRecords(cvId: cvId, recordParams: ZCRMQuery.GetRecordParams()) { (result) in
            switch result{
            case .success(let records, let bulkResponce):
                self.crmRecord = records
                DispatchQueue.main.async {
                    self.navigationItem.title = self.leadStatus
                    self.recordsTableView.reloadData()
                    
                }
                
                
                
            case .failure(let error):
                print("Error  -  \(error)")
                self.navigationItem.title = "No Records"
                
            }
        }
        
        
    }
    
    func getRecords(moduleName : String ){
        
        ZCRMSDKUtil.getModuleDelegate(apiName: moduleName).getRecords(recordParams: ZCRMQuery.GetRecordParams()) { (result) in
            switch result{
            case .success(let records, let bulkResponce):
                self.crmRecord = records
                
                DispatchQueue.main.async {
                    self.navigationItem.title = self.leadStatus
                    self.recordsTableView.reloadData()
                    
                }
                
            case .failure(let error):
                print("Error  -  \(error)")
                DispatchQueue.main.async {
                    self.navigationItem.title = "No Records"
                }
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
        CustomViewsVC.customViews = self.customViews
        CustomViewsVC.cv_Delegate = self
        self.present(CustomViewsVC, animated: true, completion: nil)
    }
    
}

extension ModuleRecordsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.crmRecord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordsTableView.dequeueReusableCell(withIdentifier: "records", for: indexPath)
        let objectOfRecord = self.crmRecord[indexPath.row]
        
        do{
            if  module_Name == "Leads" ||  module_Name == "Contacts"{
                ofFieldAPIName  = "Full_Name"
            }else if module_Name == "Accounts" || module_Name == "Deals" {
                var moduleName : String = module_Name!
                moduleName.removeLast()
                ofFieldAPIName  = "\(moduleName)_Name"
            }else{
                ofFieldAPIName = "What_Id"
            }
            
            if let name : String = try objectOfRecord.getString(ofFieldAPIName: ofFieldAPIName) {
                cell.textLabel?.text = name
            }else if let recordDelegate : ZCRMRecordDelegate = try objectOfRecord.getZCRMRecordDelegate(ofFieldAPIName: ofFieldAPIName) {
                let name : String = recordDelegate.label!
                cell.textLabel?.text = name
            }
            
        }catch{
            print("error - \(error)")
        }
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let personVC  : personViewController = personViewController()
        let singlePersonRecord = crmRecord[indexPath.row]
        personVC.crmRecord = [singlePersonRecord]
        self.navigationController?.pushViewController(personVC, animated: true)
    }
}
