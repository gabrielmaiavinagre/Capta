//
//  LoginVC.swift
//  Capta
//
//  Created by Erika Bueno on 09/06/15.
//  Copyright (c) 2015 Erika Bueno. All rights reserved.
//edited by  Gabriel Vinagre

import UIKit

class LoginVC: UIViewController, FBSDKLoginButtonDelegate, FBSDKGraphRequestConnectionDelegate {
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In 1")
        
        self.performSegueWithIdentifier("hasLogged", sender: self) // First login
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "logginImageBg")!)
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            println("IF DO TOKEN")
           self.performSegueWithIdentifier("hasLogged", sender: self) // User is already logged
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            println("ELSE DO TOKEN")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            println("IF DO TOKEN")
            //self.performSegueWithIdentifier("hasLogged", sender: self) // User is already logged
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            println("ELSE DO TOKEN")
        }

        
        
    }
    
}