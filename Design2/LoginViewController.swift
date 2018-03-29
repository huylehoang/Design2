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

let twitterBaseURL = URL(string: "https://api.twitter.com")
let twitterConsumerKey = "mpRTwbf8jz9zwepXlq3pp2Y0m"
let twitterConsumerSecrect = "rioPyS7n7JhBLcnoOorZoDPzhrdXdcnwScSBmCKuT2ajkKU8tF"

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    let twitterClient = BDBOAuth1SessionManager(
        baseURL: twitterBaseURL!,
        consumerKey: twitterConsumerKey,
        consumerSecret: twitterConsumerSecrect)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Open")
        setupLoginButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupLoginButton() {
        loginButton.addTarget(self, action: #selector(twitterLogin), for: .touchUpInside)
        loginButton.setTitle("Twitter Login", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        loginButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        loginButton.backgroundColor = UIColor(red: 0/255.0, green: 132.0/255.0, blue: 180.0/255.0, alpha: 1)
        
    }
    
    @objc func twitterLogin() {
        
        self.login()
    }
    
    func login(){
//        loginSuccess = success
        //        loginFailure = failure
        
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string:"design2://oauth"),
            scope: nil,
            success: {(requestToken: BDBOAuth1Credential!) -> Void in
                print("I got a token!")
                print(requestToken)
                print(requestToken.token)
                
                //                if (UIApplication.shared.canOpenURL(URL(string:"twitter://")!)) {
                //                    UIApplication.shared.openURL(URL(string:"twitter://")!)
                //                    print("Twitter is installed")
                //                } else
                
                if let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)") {
                    print(url as Any)
                    UIApplication.shared.openURL(url)
                }
                
        }) {(error: Error!) -> Void in
            print("error: \(error.localizedDescription)")
            print("You failed")
            //            self.loginFailure?(error)
        }
    }
    
//    func handleOpenUrl(url: URL){
//        let requestToken = BDBOAuth1Credential(queryString: url.query)
//        
//        twitterClient?.fetchAccessToken(
//            withPath: ("oauth/access_token"),
//            method: "POST",
//            requestToken: requestToken,
//            success: {(accessToken: BDBOAuth1Credential!) -> Void in
//                print("Got my access token")
//                self.pushView()
//                
//                self.twitterClient?.requestSerializer.saveAccessToken(accessToken)
//                
//                //                self.verifyCredentials()
//                
//        }) {(error: Error!) -> Void in
//            print("error: \(error.localizedDescription)")
////            self.loginFailure?(error)
//        }
//    }
    
//    func pushView() {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        self.navigationController?.pushViewController(homeViewController, animated: true)
//        
//    }
}


