//
//  ViewController.swift
//  Learn_CRM_Sdk
//
//  Created by ZU-IOS on 04/03/20.
//  Copyright © 2020 ZU-IOS. All rights reserved.
//

import UIKit
import ZCRMiOS
import CoreData

class ViewController: UIViewController {
    
    let logoutButton : UIBarButtonItem = UIBarButtonItem()
    let getModulesButton : UIButton = UIButton()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        view.backgroundColor = .white
        self.showLogin()
        self.setupLogoutButton()
        self.setupGetModulesButton()
    }
    
    func setupLogoutButton(){
        self.navigationItem.rightBarButtonItem = logoutButton
        logoutButton.title = "Logout"
        logoutButton.action = #selector(logout)
        logoutButton.target = self
        logoutButton.style = .done
        logoutButton.tintColor = .blue
        
    }
    
    func showLogin(){
        ZCRMSDKClient.shared.isUserSignedIn { (isUserSignedIn) in
            if isUserSignedIn {
                print( "Already User Signed In")
            }
            else{
                DispatchQueue.main.async {
                    ZCRMSDKClient.shared.showLogin { ( success ) in
                        if( success == true )
                        {
                            print( "Login successful" )
                        }
                        else{
                            print( "unable to show login")
                        }
                    }
                }
            }
        }
        
    }

    
    @objc func logout(){
        ZCRMSDKClient.shared.logout { ( success ) in
            if success {
                print("logout successful")
                
                DispatchQueue.main.async {
                    ZCRMSDKClient.shared.showLogin { ( success ) in
                        if( success == true )
                        {
                            print( "Login successful" )
                        }
                        else{
                            print( "unable to show login")
                        }
                    }
                }
            }
        }
  
    }
    
    
    func setupGetModulesButton(){
        self.view.addSubview(getModulesButton)
        getModulesButton.setTitle("Get Modules", for: .normal)
        getModulesButton.setTitleColor(.blue, for: .normal)
        getModulesButton.backgroundColor = .lightGray
        getModulesButton.addTarget(self, action: #selector(NavigateToModulesViewController), for: .touchUpInside)
        getModulesButton.frame = CGRect(x: 100, y: 300, width: 200, height: 100)
        
    }
    
    
    @objc func NavigateToModulesViewController(){
        let modulesviewController : ModulesListViewController = ModulesListViewController()
        self.navigationController?.pushViewController(modulesviewController, animated: true)
        
        
    }
    
    
}

