//
//  TweetModel.swift
//  Design2
//
//  Created by LeeX on 4/4/18.
//  Copyright © 2018 LeeX. All rights reserved.
//


import UIKit
import AFNetworking

protocol TweetModelDelegate: class {
    func didReceiveTweet(tweetArray: [Tweet])
    func didReceiveCurrentUser(currentUser: [User])
    func didReceiveCurrentStatus(currentStatus: String)
}

class TweetModel {

    var tweetDelegate: TweetModelDelegate?
    
    func fetchTweet() {        
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets) in
            var no = 0
            var tweetArray:[Tweet] = []

            for tweet in tweets {
                no += 1
                let user = tweet["user"] as! [String:AnyObject]
                let name = user["name"] as! String
                let screenName = user["screen_name"] as! String
                let avatar = user["profile_image_url_https"] as! String
                let text = tweet["text"] as! String
                let favouriteCount = tweet["favorite_count"] as! Int
                let favouriteCountString = String(favouriteCount)
                let retweetCount = tweet["retweet_count"] as! Int
                let retweetCountString = String(retweetCount)
                
                let timestampString = tweet["created_at"] as? String
                var timeStamp = Date()
                var InitTime = Int()
                var timeSince = String()
                
                let formatter = DateFormatter()
                formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
                
                if let timestampString = timestampString {
                    timeStamp = formatter.date(from: timestampString)!
                    
                }
                let now = Date()
                let then = timeStamp
                InitTime = Int(now.timeIntervalSince1970 - then.timeIntervalSince1970)
                
                if InitTime >= 86400 {
                    timeSince = String(InitTime / 86400)+"d"
                }
                if (3600..<86400).contains(InitTime) {
                    timeSince = String(InitTime/3600)+"h"
                }
                if (60..<3600).contains(InitTime) {
                    timeSince = String(InitTime/60)+"m"
                }
                if InitTime < 60 {
                    timeSince = String(InitTime)+"s"
                }
                
                tweetArray.append(Tweet(avatar: avatar,
                                        retweeted: "",
                                        name: name,
                                        screenName: screenName,
                                        time: timeSince,
                                        content: text,
                                        retweetCount: retweetCountString,
                                        favouriteCount: favouriteCountString))
                
                print("Tweet \(no)")
                print(" name: \(name)")
                print(" screen name: \(screenName)")
                print(" text: \(text)")
                print(" Image URL: \(avatar)")
                print(" time since: \(timeSince)")
                print(" retweet count: \(retweetCountString)")
                print(" favourite count: \(favouriteCountString)")
                print("\n")
                
            }
            self.tweetDelegate?.didReceiveTweet(tweetArray: tweetArray)
        })
    }
    
    func saveCurrentUser(currentUser: [User]) {
        
        let defaults = UserDefaults.standard
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(currentUser) {
            defaults.set(savedData, forKey: "currentUser")
            print("Saved \(savedData)")
        } else {
            print("Failed to save user.")
        }
    }
    
    func saveCurrentStatus(currentStatus: String) {
        
        let defaults = UserDefaults.standard
        defaults.set(currentStatus, forKey: "currentStatus")
        print(currentStatus)
    }
    
    func getCurrentUser() {
        
        let defaults = UserDefaults.standard
        if let savedContact = defaults.object(forKey: "currentUser") as? Data {
            let jsonDecoder = JSONDecoder()
           
            do {
                let currentUser = try jsonDecoder.decode([User].self, from: savedContact)
                print("Loaded Contact!!!")
                self.tweetDelegate?.didReceiveCurrentUser(currentUser: currentUser)
            } catch {
                print("Failed to load people")
            }
        }
    }
    
    func getCurrentStatus() {
        let defaults = UserDefaults.standard
        let savedStatus = defaults.string(forKey: "currentStatus")
        if savedStatus != nil {
            self.tweetDelegate?.didReceiveCurrentStatus(currentStatus: savedStatus!)
        } else {
            print("There is no current status")
            self.tweetDelegate?.didReceiveCurrentStatus(currentStatus: "")
        }
    }
    
    func removeCurrentStatus() {
        let defaults = UserDefaults.standard
        let savedStatus = defaults.string(forKey: "currentStatus")
        if savedStatus != nil {
            defaults.removeObject(forKey: "currentStatus")
        }    
    }
 
    func logout() {
        TwitterClient.sharedInstance?.logout()
        print("User did logout!!!!!")
    }
    
    func postTweet(postText: String) {
        TwitterClient.sharedInstance?.postTweet(text: postText, success: {
            print("Posted")
        })
    }
}
