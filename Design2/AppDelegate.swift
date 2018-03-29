//
//  AppDelegate.swift
//  Design2
//
//  Created by LeeX on 3/12/18.
//  Copyright © 2018 LeeX. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let twitterBaseURL = URL(string: "https://api.twitter.com")
        let twitterConsumerKey = "mpRTwbf8jz9zwepXlq3pp2Y0m"
        let twitterConsumerSecrect = "rioPyS7n7JhBLcnoOorZoDPzhrdXdcnwScSBmCKuT2ajkKU8tF"
        
        let twitterClient = BDBOAuth1SessionManager(
            baseURL: twitterBaseURL!,
            consumerKey: twitterConsumerKey,
            consumerSecret: twitterConsumerSecrect)

        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        twitterClient?.fetchAccessToken(
            withPath: ("oauth/access_token"),
            method: "POST",
            requestToken: requestToken,
            success: {(accessToken: BDBOAuth1Credential!) -> Void in
                
                print("Got my access token")
                
                //self.twitterClient?.requestSerializer.saveAccessToken(accessToken)
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.window?.rootViewController = UINavigationController(rootViewController: homeViewController)
       
                //self.verifyCredentials()
                
        }) {(error: Error!) -> Void in
            print("error: \(error.localizedDescription)")
            //self.loginFailure?(error)
        }

//        loginViewController.handleOpenUrl(url: url)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

