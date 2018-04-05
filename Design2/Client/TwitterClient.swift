//
//  TwitterClient.swift
//  Design2
//
//  Created by LeeX on 3/29/18.
//  Copyright © 2018 LeeX. All rights reserved.
//

import Foundation
import AFNetworking
import BDBOAuth1Manager

let twitterBaseURL = URL(string: "https://api.twitter.com")
let twitterConsumerKey = "mpRTwbf8jz9zwepXlq3pp2Y0m"
let twitterConsumerSecrect = "rioPyS7n7JhBLcnoOorZoDPzhrdXdcnwScSBmCKuT2ajkKU8tF"

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(
        baseURL: twitterBaseURL!,
        consumerKey: twitterConsumerKey,
        consumerSecret: twitterConsumerSecrect)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    var tweetModel = TweetModel()
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()){
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string:"design2://oauth"),
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

        fetchAccessToken(
            withPath: ("oauth/access_token"),
            method: "POST",
            requestToken: requestToken,
            success: {(accessToken: BDBOAuth1Credential!) -> Void in
                
                self.currentAccount(success: { (user) in
                    self.loginSuccess?()
                    self.tweetModel.saveCurrentUser(currentUser: user)
                })
                
                print(accessToken.token)
                print("Got my access token")
                

        }) {(error: Error!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func homeTimeline(success: @escaping (_ tweets: [[String:AnyObject]]) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation, response) in

            let dictionaries = response as! [[String:AnyObject]]

            success(dictionaries)
        }) { (operation, error) in
            print(error)
        }
    }
    
    func currentAccount(success: @escaping(_ user:[User]) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (operation, response) in
            let userDictionary = response as! [String:AnyObject]
            
            var user:[User] = []
            let name = userDictionary["name"] as! String
            let screenName = userDictionary["screen_name"] as! String
            let profileURLString = userDictionary["profile_image_url_https"] as! String
            
            user.append(User(name: name, screenName: screenName, profileURLString: profileURLString))
            
            success(user)
        }) { (operation, error) in
            print(error)
        }
    }
    
    func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "currentUser")
        TwitterClient.sharedInstance?.deauthorize()
        NotificationCenter.default.post(name: .userDidLogout, object: nil)
    }
    
}

extension Notification.Name {
    static let userDidLogout = Notification.Name("UserDidLogout")
}
