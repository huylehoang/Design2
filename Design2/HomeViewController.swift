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

    var tweet = [NSDictionary]()
    
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
                     tweetName: self.tweetNames[indexPath.row],
                     time: self.times[indexPath.row],
                     content: self.contents[indexPath.row])
        return cell
    }
}



