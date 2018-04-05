//
//  LoginViewController.swift
//  Design2
//
//  Created by LeeX on 3/29/18.
//  Copyright © 2018 LeeX. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupLoginButton() {
        loginButton.addTarget(self, action: #selector(twitterLogin), for: .touchUpInside)
        loginButton.setTitle("Log in with Twitter", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        loginButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        loginButton.backgroundColor = UIColor(red: 0/255.0, green: 132.0/255.0, blue: 180.0/255.0, alpha: 1)
        
    }
    
    @objc func twitterLogin() {
        
        TwitterClient.sharedInstance?.login(success: {[unowned self] in
            print("I have log in")
            self.loading()
            
            }, failure: {(error: Error) -> () in
            print("Error: \(error.localizedDescription)")
        })     
    }
    
    func loading() {

        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)

        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when){

            loadingIndicator.stopAnimating()
            
            alert.dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.performSegue(withIdentifier: "moveToHomeVC", sender: nil)
            })

        }
    }
}


