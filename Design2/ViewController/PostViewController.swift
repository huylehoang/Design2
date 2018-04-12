//
//  PostViewController.swift
//  Design2
//
//  Created by LeeX on 4/6/18.
//  Copyright © 2018 LeeX. All rights reserved.
//

import UIKit
import Foundation

class PostViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cancelImage: UIImageView!
 
    @IBOutlet weak var tweetButton: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lineBreak: UIView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var wordCountLabel: UILabel!
    
    var tweetModel = TweetModel()
    
    //var currentUser:[User] = []
    
    var currentTableViewHeight:CGFloat = 0.0
    
    var postText:String = ""
    
    var wordCount = 0 {
        didSet {
            //print(wordCountLabel)
            if countLabel != nil {
                //print("Number of character \(self.wordCountLabel)")
                checkCharacterLimit()
            }
        }
    }
    
    var characterCount = 0 {
        didSet {
            //print(countLabel)
            if countLabel != nil {
                //print("Number of character \(self.characterCount)")
                checkCharacterLimit()
            }
        }
    }
    
    var indexPathRow = 0
    
    let normalColor:UIColor = UIColor(red: 29/255.0, green: 202/255.0, blue: 255/255.0, alpha: 1)
    
    let errorColor: UIColor =  UIColor(red: 212.0/255.0, green: 53.0/255.0, blue: 140.0/255.0, alpha: 1)
    
    var isEdit:Bool = false
    
    // we set a variable to hold the contentOffSet before scroll view scrolls
    var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tweetModel.tweetDelegate = self
        tweetModel.getCurrentUser()
    }

    override func viewWillAppear(_ animated: Bool) {
        isEdit = false
        lineBreak.isHidden = true
        countLabel.textColor = normalColor
        countLabel.text = "Character: \(characterCount)"
        wordCountLabel.textColor = normalColor
        wordCountLabel.text = "Word: \(wordCount)"
        setupCancelImage()
        setupTweetButton()
        setupTableView()
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionClose(_:))))       
    }
    
    func dismissView() {
        self.view.endEditing(true)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        // do whatever you want with this keyboard height
        self.tableViewHeight.constant = self.view.frame.height - self.topView.frame.height - 50 - 20 - keyboardHeight
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        //self.tableView.rowHeight = self.view.frame.height - self.topView.frame.height - 20 - keyboardHeight
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        // keyboard is dismissed/hidden from the screen
        self.tableViewHeight.constant = self.view.frame.height - self.topView.frame.height - 50 - 20
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    @objc func actionTweet() {
        //print("Tweeted")
        //print(postText)
        //print(postText.count)
        let textURL = postText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        //print(textURL)

        if self.postText == "" {
            let alert = UIAlertController(title: "", message: "Status cannot be blank.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true)
        }
        else if self.postText.count > 150 {
            let alert = UIAlertController(title: "", message: "150 characters limited", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true)
        }
        else {
            tweetModel.postTweet(postText: textURL)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.dismissView()
            })
        }
    }
    
    @objc func actionClose(tapGestureRecognizer: UITapGestureRecognizer) {
        //print("Tapped")
        if isEdit == true {
            let alert = UIAlertController(title: "", message: "Do you want to save current status", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
                self.tweetModel.saveCurrentStatus(currentStatus: self.postText)
                self.dismissView()
            })
            let noAction = UIAlertAction(title: "No", style: .default, handler: { (alert) in
                self.tweetModel.removeCurrentStatus()
                self.dismissView()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(noAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        } else {
            self.tweetModel.removeCurrentStatus()
            dismissView()
        }
    }
    
    func setupCancelImage() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionClose(tapGestureRecognizer:)))
        cancelImage.isUserInteractionEnabled = true
        cancelImage.addGestureRecognizer(tapGestureRecognizer)
        cancelImage.image = #imageLiteral(resourceName: "ic_delete")
    }
    
    func setupTweetButton() {
        tweetButton.addTarget(self, action: #selector(actionTweet), for: .touchUpInside)
        tweetButton.setTitle("Tweet", for: .normal)
        tweetButton.setTitleColor(UIColor.white, for: .normal)
        tweetButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        tweetButton.contentEdgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        tweetButton.layer.cornerRadius = 15
        tweetButton.layer.borderWidth = 0.5
        tweetButton.layer.borderColor = UIColor(red: 29/255.0, green: 202/255.0, blue: 255/255.0, alpha: 1).cgColor
        tweetButton.backgroundColor = UIColor(red: 29/255.0, green: 202/255.0, blue: 255/255.0, alpha: 1)
    }
    
    func checkCharacterLimit() {
        if characterCount >= 0 && characterCount <= 150 {
            countLabel.textColor = normalColor
            countLabel.text = "Characer: \(characterCount)"
            wordCountLabel.textColor = normalColor
            wordCountLabel.text = "Word: \(wordCount)"
        } else if characterCount > 150 {
            countLabel.textColor = errorColor
            countLabel.text = "Character: \(characterCount)(-\(characterCount - 150))"
            wordCountLabel.textColor = errorColor
            wordCountLabel.text = "Word: \(wordCount)"
        }
        
//        if wordCount >= 0 && wordCount <= 150 {
//            wordCountLabel.textColor = normalColor
//            wordCountLabel.text = "Word: \(wordCount)"
//            countLabel.text = "Character: \(characterCount)"
//        } else if wordCount > 150 {
//            wordCountLabel.textColor = errorColor
//            wordCountLabel.text = "Word: \(wordCount)(-\(wordCount - 150))"
//            countLabel.textColor = errorColor
//            countLabel.text = "Character: \(characterCount))"
//        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        cell.parentVC = self
        self.indexPathRow = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewHeight.constant
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.brown
        tableView.allowsSelection = false
        
        // top safe area = 19 or 20
        tableViewHeight.constant = self.view.frame.height - self.topView.frame.height - 50 - 20
        tableView.rowHeight = tableViewHeight.constant
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.tableView.layoutSubviews()

    }
}

// Changing table view background base on scrolling up or down
extension PostViewController: UIScrollViewDelegate {
    
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = tableView.contentOffset.y
    }
    
    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > 0 {
//            self.lineBreak.isHidden = false
//        }
//        else {
//            self.lineBreak.isHidden = true
//        }
   
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            print("Scrolling up")
            tableView.backgroundColor = UIColor.white
            view.backgroundColor = UIColor.white
            self.lineBreak.isHidden = false
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            print("Scrolling down")
            tableView.backgroundColor = UIColor.lightGray
            self.lineBreak.isHidden = true
        } else {
            print("Didn't scroll")
            self.lineBreak.isHidden = true
        }
    }
}
