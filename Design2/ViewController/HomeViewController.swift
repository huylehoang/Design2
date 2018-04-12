//
//  ViewController.swift
//  Design2
//
//  Created by LeeX on 3/12/18.
//  Copyright © 2018 LeeX. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tweetArray:[Tweet] = []
    
    var tweetModel = TweetModel()
    
    var timer = Timer()
    
    //let slideAnimator = SlideAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 130
        
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(new))
        //navigationController?.navigationBar.barTintColor = UIColor(red: 46/255.0, green: 183/255.0, blue: 255/255.0, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        tweetModel.tweetDelegate = self  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tweetModel.fetchTweet()
        timer.invalidate()

        timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    @objc func timerAction() {
        loading()
    }
    
    func loading() {
        
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                DispatchQueue.main.async {
                    self.tweetModel.fetchTweet()
                    print("Loaded")
                }
            })
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func signOut() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { Void in
            self.tweetModel.logout()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated:true)
    }
    
    @objc func new() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC = storyboard.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        present(postVC, animated: true, completion: nil)
    }

}

extension HomeViewController: TweetModelDelegate {
    func didReceiveCurrentUser(currentUser: [User]) {
        print("DID RECEIVE CURRENT USER")
    }
    
    func didReceiveTweet(tweetArray: [Tweet]) {
        self.tweetArray = tweetArray
        self.tableView.reloadData()
    }
    
    func didReceiveCurrentStatus(currentStatus: String) {
        print("DID RECEIVE CURRENT STATUS")
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweetArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! HomeTableViewCell
        cell.addCell(avatar: self.tweetArray[indexPath.row].avatar,
                     retweeted: self.tweetArray[indexPath.row].retweeted,
                     name: self.tweetArray[indexPath.row].name,
                     screenName: self.tweetArray[indexPath.row].screenName,
                     time: self.tweetArray[indexPath.row].time,
                     content: self.tweetArray[indexPath.row].content,
                     retweetCount: self.tweetArray[indexPath.row].retweetCount,
                     favouriteCount: self.tweetArray[indexPath.row].favouriteCount)
        return cell
    }
}




