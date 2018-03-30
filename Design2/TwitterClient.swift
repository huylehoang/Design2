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
                self.loginSuccess?()
                print(accessToken.token)
                print("Got my access token")

        }) {(error: Error!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
}
