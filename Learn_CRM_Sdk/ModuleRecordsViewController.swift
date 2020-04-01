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
    
    let moduleRecordListTableView : UITableView = UITableView()
    let customViewListButton : UIButton = UIButton()
    var customViews : [ZCRMCustomView] = [ZCRMCustomView]()
    var crmRecord : [ZCRMRecord] = [ZCRMRecord]()
    
    var moduleName : String!
    var customViewName : String!
    var cvRow : Int = 0
    var ofFieldAPIName : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = moduleName
        self.setupModuleListTableView()
        self.getCustomeViewData(moduleName: moduleName)
        self.setupCustomViewListButton()
    }
    
    func changeToCustomView(customViewName: String , cvRow : Int) {
        self.customViewName = customViewName
        self.cvRow = cvRow
        self.getCustomeViewData(moduleName: moduleName)
     }
    
    func setupModuleListTableView(){
        self.view.addSubview(moduleRecordListTableView)
        moduleRecordListTableView.delegate = self
        moduleRecordListTableView.dataSource = self
        moduleRecordListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "moduleRecordList")
        
        self.addConstraint(whichView: moduleRecordListTableView, forView: self.view, top: 130, bottom: -30, leading: 0, trailing: 0)
    }
    func setupCustomViewListButton(){
        self.view.addSubview(customViewListButton)
        customViewListButton.setTitleColor(.white, for: .normal)
        customViewListButton.frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: 50)
        customViewListButton.addTarget(self, action: #selector(customViewList), for: .touchUpInside)
        customViewListButton.backgroundColor = .black
        customViewListButton.titleLabel?.lineBreakMode = .byWordWrapping
    }
    
    
    func getCustomeViewData(moduleName : String){
        
        ZCRMSDKUtil.getModuleDelegate(apiName: moduleName ).getCustomViews { (result) in
            switch result{
            case .success(let customViews, _):
                self.customViews = customViews
                if self.customViews.count != 0{
                    self.getRecords(moduleName : self.moduleName , cvId : self.customViews[self.cvRow].id)
                    self.customViewName = self.customViews[self.cvRow].name
                    
                }else{
                    self.customViewListButton.setTitle("No Records", for: .normal)
                }
            case .failure(let error):
                print("Error  -  \(error)")
            }
        }
        
    }
    
    func getRecords(moduleName : String , cvId : Int64){
        
        ZCRMSDKUtil.getModuleDelegate(apiName: moduleName).getRecords(cvId: cvId, recordParams: ZCRMQuery.GetRecordParams()) { (result) in
            switch result{
            case .success(let records, _):
                self.crmRecord = records
                DispatchQueue.main.async {
                    if self.crmRecord.count != 0 {
                        self.customViewListButton.setTitle("\(self.customViewName!)\n\t\t^", for: .normal)
                        
                    }else{
                        self.customViewListButton.setTitle("No Records", for: .normal)
                    }
                    self.moduleRecordListTableView.reloadData()
                    
                }
           case .failure(let error):
                print("Error  -  \(error)")
                self.navigationItem.title = "No Records"
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
        let cell = moduleRecordListTableView.dequeueReusableCell(withIdentifier: "moduleRecordList", for: indexPath)
        let record = self.crmRecord[indexPath.row]
        cell.textLabel?.text = gettheNameField(record: record)

        return cell

    }
    
    
    func gettheNameField(record : ZCRMRecord ) -> String{
        var NameField : String = String()
        do{
            if  self.moduleName == "Leads" ||  self.moduleName == "Contacts"{
                ofFieldAPIName  = "Full_Name"
            }
            else if self.moduleName == "Invoices" || self.moduleName == "Quotes"{
                ofFieldAPIName  = "Account_Name"
            }else if self.moduleName == "Notes" {
                ofFieldAPIName  = "Parent_Id"
            }
            else if moduleName.last == "s"  {
                var module : String = self.moduleName
                module.removeLast()
                ofFieldAPIName = "\(module)_Name"
            }
            
            if let name : String = try record.getString(ofFieldAPIName: ofFieldAPIName) {
                NameField = name
            }
            else if let recordDelegate : ZCRMRecordDelegate = try record.getZCRMRecordDelegate(ofFieldAPIName: ofFieldAPIName) {
                if let name : String = recordDelegate.label {
                    NameField = name

                }
            }
           
            
        }catch{
            print("error - \(error)")

        }
        
        return NameField
        
    }
    
}

