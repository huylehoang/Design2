//
//  ViewController.swift
//  Design2
//
//  Created by LeeX on 3/12/18.
//  Copyright © 2018 LeeX. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
//    var avatars:[String] = ["avatar1", "avatar2", "avatar3", "avatar4","avatar1", "avatar2", "avatar3", "avatar4"]
//
//    var retweeteds:[String] = ["wafflettchnlgy", "John Wu", "nil", "CodePath", "wafflettchnlgy", "John Wu", "wafflettchnlgy", "John Wu"]
//
//    var names:[String] = ["Michael Moran", "Michael Rooney", "Twiiter", "GitHub", "Michael Moran", "Michael Rooney", "Twiiter", "GitHub"]
//
//    var screenNames:[String] = ["TheMichaelMoran", "MikeRooney", "twitter", "github", "TheMichaelMoran", "MikeRooney", "twitter", "github"]
//
//    var times:[String] = ["4h", "14h", "2h", "1/14/14", "4h", "14h", "2h", "1/14/14"]
//
//    var contents:[String] = ["I have seen the future",
//                             "Did you know you can tell if someone is a programmer simply by saying the word \"timezones\" and seeing if they are cringe ",
//                             "We're bringing new filters to search on http://t.co/eNvqKTup1d: by videos, news, people you follow, and more. http://t.co/vkxfkNf2ou",
//                             "Learn GitHub at GitHub! Checkout Patchwork, a new event for aspiring open source contributors https://t.co/eK0RshEkj8",
//                             "I have seen the future of newspaper: http://t.co/UfmWt2OTCP",
//                             "Did you know you can tell if someone is a programmer simply by saying the word \"timezones\" and seeing if they are cringe ",
//                             "We're bringing new filters to search on http://t.co/eNvqKTup1d: by videos, news, people you follow, and more. http://t.co/vkxfkNf2ou",
//                             "Learn GitHub at GitHub! Checkout Patchwork, a new event for aspiring open source contributors https://t.co/eK0RshEkj8"]
    
    var avatars:[String] = []
    
    var retweeteds:[String] = []
    
    var names:[String] = []
    
    var screenNames:[String] = []
    
    var times:[String] = []
    
    var contents:[String] = []
    
    var retweetCounts:[String] = []
    
    var favouriteCounts:[String] = []
    
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
       
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets) in
            var no = 0
            for tweet in tweets {
                no += 1
                let user = tweet["user"] as! [String:AnyObject]
                let name = user["name"] as! String
                let text = tweet["text"] as! String
                let screenName = user["screen_name"] as! String
                let avatar = user["profile_image_url_https"] as! String
                let timestampString = tweet["created_at"] as? String
                let favouriteCount = tweet["favorite_count"] as! Int
                let favouriteCountString = String(favouriteCount)
                let retweetCount = tweet["retweet_count"] as! Int
                let retweetCountString = String(retweetCount)

                let formatter = DateFormatter()
                formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
                var timestamp = Date()
                var InitTime = Int()
                var timeSince = String()
                if let timestampString = timestampString {
                    timestamp = formatter.date(from: timestampString)!
                }
                let now = NSDate()
                let then = timestamp
                InitTime = Int(now.timeIntervalSince(then))

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
                
                self.avatars.append(avatar)
                self.retweeteds.append("")
                self.names.append(name)
                self.screenNames.append(screenName)
                self.contents.append(text)
                self.times.append(timeSince)
                
                if retweetCountString == "0" {
                    self.retweetCounts.append("")
                } else {
                    self.retweetCounts.append(retweetCountString)
                }
                
                if favouriteCountString == "0" {
                    self.favouriteCounts.append("")
                } else {
                    self.favouriteCounts.append(favouriteCountString)
                } 
                
                self.tableView.reloadData()
                
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
            
            for (key,value) in tweets[0] {
                print("KEY: :\(key)")
                print("VALUE: :\(value)")
            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func signOut() {
        
    }
    
    @objc func new() {
        
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
                     screenName: self.screenNames[indexPath.row],
                     time: self.times[indexPath.row],
                     content: self.contents[indexPath.row],
                     retweetCount: self.retweetCounts[indexPath.row],
                     favouriteCount: self.favouriteCounts[indexPath.row])
        return cell
    }
}



