//
//  ModuleViewController.swift
//  Learn_CRM_Sdk
//
//  Created by ZU-IOS on 06/03/20.
//  Copyright © 2020 ZU-IOS. All rights reserved.
//

import UIKit
import ZCRMiOS

class RecordListViewController: UIViewController , customViewDelegate {
    
    let RecordListTableView : UITableView = UITableView()
    let customViewListButton : UIButton = UIButton()
    var customViews : [ZCRMCustomView] = [ZCRMCustomView]()
    var crmRecord : [ZCRMRecord] = [ZCRMRecord]()
    
    var moduleName : String!
    var customViewName : String!
    var cvRow : Int = 0
    var ofFieldAPIName : String = String()
    var isCustomModule : Bool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = moduleName
        self.setupModuleListTableView()
        self.setOfFieldAPIName()
        self.getRecords(moduleName: moduleName)
        self.setupCustomViewListButton()
    }
    
    func changeToCustomViewList(customViewName: String , cvRow : Int) {
        self.customViewName = customViewName
        self.cvRow = cvRow
        self.getRecords(moduleName: moduleName)
    }
    
    func setupModuleListTableView(){
        self.view.addSubview(RecordListTableView)
        RecordListTableView.delegate = self
        RecordListTableView.dataSource = self
        RecordListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecordList")
        RecordListTableView.rowHeight = 36
        self.addConstraint(whichView: RecordListTableView, forView: self.view, top: 129, bottom: -30, leading: 0, trailing: 0)
    }
    
    
    func setupCustomViewListButton(){
        self.view.addSubview(customViewListButton)
        customViewListButton.setTitleColor(.systemBlue, for: .normal)
        customViewListButton.frame = CGRect(x: 0, y: 89, width: self.view.frame.width, height: 40)
        customViewListButton.addTarget(self, action: #selector(showCustomViewList), for: .touchUpInside)
        customViewListButton.backgroundColor = .black
        customViewListButton.titleLabel?.numberOfLines = 2
        customViewListButton.titleLabel?.textAlignment = .center

    }
    
    
    func getRecords(moduleName : String){
        
        ZCRMSDKUtil.getModuleDelegate(apiName: moduleName ).getCustomViews { (result) in
            switch result{
            case .success(let customViews, _):
                self.customViews = customViews

                if self.customViews.count != 0{
                    self.getRecords(moduleName : self.moduleName , cvId : self.customViews[self.cvRow].id)
                    self.customViewName = self.customViews[self.cvRow].displayName
                }
                else{
                    DispatchQueue.main.async {
                        self.showAlertforNoRecords(moduleName)
                    }
                }
            case .failure(let error):
                print("Error  -  \(error)")
                DispatchQueue.main.async {
                    self.showAlertforNoRecords(moduleName)
                }
            }
        }
        
    }
    
    func getRecords(moduleName : String , cvId : Int64){
        
        ZCRMSDKUtil.getModuleDelegate(apiName: moduleName).getRecords(cvId: cvId, recordParams: ZCRMQuery.GetRecordParams()) { (result) in
            switch result{
            case .success(let records, _):
                self.crmRecord = records
                
                DispatchQueue.main.async {
                    if self.crmRecord.count == 0 {
                        self.showAlertforNoRecords(self.customViewName)
                    }
                    self.customViewListButton.setTitle("\(self.customViewName!)\n\u{25BE}", for: .normal)
                    self.RecordListTableView.reloadData()
                    
                }
            case .failure(let error):
                print("Error  -  \(error)")
                DispatchQueue.main.async {
                    self.showAlertforNoRecords(self.customViewName!)
                }

            }
        }
        
    }

    func getOfFieldAPIName(moduleName: String){
        
        ZCRMSDKUtil.getModuleDelegate(apiName: moduleName ).getFields { (result) in
            switch result{
            case .success(let fields, _):
                var arrayOfId : [Int64] = [Int64]()
                for field in fields {
                    arrayOfId.append(Int64(field.id))
                }
                arrayOfId.sort()
                let firstId = arrayOfId[0]
                
                ZCRMSDKUtil.getModuleDelegate(apiName: moduleName ).getField(id: firstId) { (result) in
                    switch result {
                    case .success(let field, _):
                        self.ofFieldAPIName = field.apiName
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func setOfFieldAPIName(){
        
        if  self.moduleName == "Leads" ||  self.moduleName == "Contacts"{
            self.ofFieldAPIName  = "Full_Name"
        }
        else if self.moduleName == "Invoices" || self.moduleName == "Quotes"{
            self.ofFieldAPIName  = "Subject"
        }
        else if self.moduleName == "Accounts" {
            self.ofFieldAPIName  = "Account_Name"
        }
        else if self.moduleName == "Deals" {
            self.ofFieldAPIName  = "Deal_Name"
        }
        else if self.moduleName == "Vendors" {
            self.ofFieldAPIName  = "Vendor_Name"
        }
        else if self.isCustomModule {
            self.getOfFieldAPIName(moduleName: moduleName)
        }
        
    }
    
    func addConstraint(whichView : UIView , forView : UIView , top : CGFloat , bottom : CGFloat , leading : CGFloat , trailing : CGFloat ){
        
        whichView.translatesAutoresizingMaskIntoConstraints = false
        
        whichView.topAnchor.constraint(equalTo: forView.topAnchor, constant: top).isActive = true
        whichView.bottomAnchor.constraint(equalTo: forView.bottomAnchor, constant: bottom).isActive = true
        whichView.leadingAnchor.constraint(equalTo: forView.leadingAnchor, constant: leading).isActive = true
        whichView.trailingAnchor.constraint(equalTo: forView.trailingAnchor, constant: trailing).isActive = true
    }
    
    
    @objc func showCustomViewList(){
        let customViewsVC  : CustomViewListViewController = CustomViewListViewController()
        customViewsVC.customViews = self.customViews
        customViewsVC.cv_Delegate = self
        self.present(customViewsVC, animated: true, completion: nil)
    }
    
    func showAlertforNoRecords(_ message : String){
        let alert = UIAlertController(title: "No Records", message: "in \(message)", preferredStyle: .alert)
                
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (alert) in
            self.dismiss(animated: true, completion: nil)
        }))

        self.present(alert, animated: true, completion: nil)

    }
    
}

extension RecordListViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.crmRecord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RecordListTableView.dequeueReusableCell(withIdentifier: "RecordList", for: indexPath)
        let record = self.crmRecord[indexPath.row]
        
        do{
            if let name : String = try record.getString(ofFieldAPIName: ofFieldAPIName) {
                cell.textLabel?.text  = name
            }
            
        }catch{
            print("error - \(error)")
        }
        
        return cell
        
    }
    
    
}

