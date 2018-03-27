//
//  ViewController.swift
//  Design2
//
//  Created by LeeX on 3/12/18.
//  Copyright © 2018 LeeX. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

let twitterBaseURL = URL(string: "https://api.twitter.com")
let twitterConsumerKey = "mpRTwbf8jz9zwepXlq3pp2Y0m"
let twitterConsumerSecrect = "rioPyS7n7JhBLcnoOorZoDPzhrdXdcnwScSBmCKuT2ajkKU8tF"

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    let avatars:[String] = ["avatar1", "avatar2", "avatar3", "avatar4","avatar1", "avatar2", "avatar3", "avatar4"]
    
    let retweeteds:[String] = ["wafflettchnlgy", "John Wu", "nil", "CodePath", "wafflettchnlgy", "John Wu", "wafflettchnlgy", "John Wu"]
    
    let names:[String] = ["Michael Moran", "Michael Rooney", "Twiiter", "GitHub", "Michael Moran", "Michael Rooney", "Twiiter", "GitHub"]
    
    let tweetNames:[String] = ["TheMichaelMoran", "MikeRooney", "twitter", "github", "TheMichaelMoran", "MikeRooney", "twitter", "github"]
    
    let times:[String] = ["4h", "14h", "2h", "1/14/14", "4h", "14h", "2h", "1/14/14"]
    
    let contents:[String] = ["I have seen the future",
                             "Did you know you can tell if someone is a programmer simply by saying the word \"timezones\" and seeing if they are cringe ",
                             "We're bringing new filters to search on http://t.co/eNvqKTup1d: by videos, news, people you follow, and more. http://t.co/vkxfkNf2ou",
                             "Learn GitHub at GitHub! Checkout Patchwork, a new event for aspiring open source contributors https://t.co/eK0RshEkj8",
                             "I have seen the future of newspaper: http://t.co/UfmWt2OTCP",
                             "Did you know you can tell if someone is a programmer simply by saying the word \"timezones\" and seeing if they are cringe ",
                             "We're bringing new filters to search on http://t.co/eNvqKTup1d: by videos, news, people you follow, and more. http://t.co/vkxfkNf2ou",
                             "Learn GitHub at GitHub! Checkout Patchwork, a new event for aspiring open source contributors https://t.co/eK0RshEkj8"]
    
    let twitterClient = BDBOAuth1SessionManager(
        baseURL: twitterBaseURL!,
        consumerKey: twitterConsumerKey,
        consumerSecret: twitterConsumerSecrect)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 130
        
        
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(new))
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        setupLoginButton()
        
        self.loginView.isHidden = false
        self.tableView.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func signOut() {
        
    }
    
    @objc func new() {
        
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
        self.login(success: { () -> Void in
            print("I've logged in!")
            self.loginView.isHidden = true
            self.tableView.isHidden = false

        }) {(error: Error) -> () in
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()){
        loginSuccess = success
        loginFailure = failure
        
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string: "design2://oauth-callback/instagram"),
            scope: nil,
            success: {(requestToken: BDBOAuth1Credential!) -> Void in
                print("I got a token!")
                print(requestToken)
                print(requestToken.token)
                if let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)") {
                    print(url as Any)
                    UIApplication.shared.openURL(url)
                }
        }) {(error: Error!) -> Void in
            print("error: \(error.localizedDescription)")
            print("You failed")
            self.loginFailure?(error)
        }
    }
    
    func handleOpenUrl(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        twitterClient?.fetchAccessToken(
            withPath: ("oauth/access_token"),
            method: "POST",
            requestToken: requestToken,
            success: {(accessToken: BDBOAuth1Credential!) -> Void in
//                self.loginSuccess?()
                print("Got my access token")
                self.twitterClient?.requestSerializer.saveAccessToken(accessToken)
                self.verifyCredentials()
                
        }) {(error: Error!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func verifyCredentials() {
        twitterClient?.get("1.1/account/verify_credentials.json", parameters: nil, success:
            {(task: URLSessionDataTask, response: AnyObject?) -> Void in
                print(response!)
                self.loginSuccess?()
        } as? (URLSessionDataTask, Any?) -> Void,
            failure:  {(task: URLSessionDataTask?, error: Error) -> Void in
            self.loginFailure?(error)
        })
        
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! HomeTableViewCell
        cell.addCell(avatar: self.avatars[indexPath.row],
                     retweeted: self.retweeteds[indexPath.row],
                     name: self.names[indexPath.row],
                     tweetName: self.tweetNames[indexPath.row],
                     time: self.times[indexPath.row],
                     content: self.contents[indexPath.row])
        return cell
    }
}



