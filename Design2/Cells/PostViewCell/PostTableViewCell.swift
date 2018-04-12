//
//  PostTableViewCell.swift
//  Design2
//
//  Created by LeeX on 4/9/18.
//  Copyright © 2018 LeeX. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import Alamofire
import AlamofireImage

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvatar: UIImageView!
    
    // Using KMPlaceholderTextView library
    @IBOutlet weak var postTextView: KMPlaceholderTextView!
    
    var currentUser:[User] = []
    
    //var currentStatus:String = ""
    
    var realText = NSMutableAttributedString()
    
    var parentVC : PostViewController!
    
    //var postText:String = ""
    
    //var characterCount:Int = 0
    
    let errorColor: UIColor =  UIColor(red: 212.0/255.0, green: 53.0/255.0, blue: 140.0/255.0, alpha: 0.5)
    
    var tweetModel = TweetModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tweetModel.tweetDelegate = self
        tweetModel.getCurrentUser()
        tweetModel.getCurrentStatus()

    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupAvatar()
        setupTextView()
        
    }

    func setupAvatar() {
        
        // Circle avatar
        self.userAvatar.layer.borderWidth = 1
        self.userAvatar.layer.masksToBounds = false
        self.userAvatar.layer.borderColor = UIColor.clear.cgColor
        self.userAvatar.layer.cornerRadius = userAvatar.frame.height/2
        self.userAvatar.clipsToBounds = true
        
        let indexPathRow = parentVC.indexPathRow
        
        let avatar = currentUser[indexPathRow].profileURLString!
        
        Alamofire.request(avatar).responseImage { response in
            if let avatar = response.result.value {
                self.userAvatar.image = avatar
            }
        }
    }
    
    func setupTextView() {
        postTextView.delegate = self
        postTextView.font = UIFont.systemFont(ofSize: 16.0)
        postTextView.placeholder = "What is happening?"
        if postTextView.attributedText != nil {
            parentVC.isEdit = true
            let postTextViewString = postTextView.attributedText.string
            parentVC.postText = postTextViewString
            addAttr(textView: postTextView)
        }
        postTextView.becomeFirstResponder()
    }
    
    func addAttr(textView: KMPlaceholderTextView!) {
        let attributedString = NSMutableAttributedString(string: textView.text)
        let normalAttributes = [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16.0, weight: .light) ]
        attributedString.addAttributes(normalAttributes, range: NSMakeRange(0, textView.text.count))
        if textView.text.count > 150 {
            let errorAttribute = [ NSAttributedStringKey.backgroundColor: self.errorColor,
                                   NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16.0, weight: .light) ]
            attributedString.addAttributes(errorAttribute, range: NSMakeRange(150, textView.text.count - 150))
            textView.attributedText = attributedString
        } else {
            textView.attributedText = attributedString
        }
    }
}

extension PostTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        parentVC.postText = textView.text
        parentVC.characterCount = textView.text.count
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = textView.text.components(separatedBy: chararacterSet)
        let words = components.filter { !$0.isEmpty }
        parentVC.wordCount = words.count
     
        if textView.text == "" {
            parentVC.isEdit = false
        } else {
            parentVC.isEdit = true
        }
        
        addAttr(textView: textView as! KMPlaceholderTextView)
        
//        if words.count > 2 {
//            let errorAttribute = [ NSAttributedStringKey.backgroundColor: errorColor,
//                                   NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16.0, weight: .light) ]
//            //attributedString.addAttributes(errorAttribute, range: NSMakeRange(,))
//            self.postTextView.attributedText = attributedString
//        } else {
//            self.postTextView.attributedText = attributedString
//        }
    }
}

extension PostTableViewCell: TweetModelDelegate {
    func didReceiveTweet(tweetArray: [Tweet]) {
        //print("DID RECEIVE TWEET")
    }
    
    func didReceiveCurrentUser(currentUser: [User]) {
        self.currentUser = currentUser
        //self.layoutSubviews()
    }
    
    func didReceiveCurrentStatus(currentStatus: String) {
        let attributedString = NSMutableAttributedString(string: currentStatus)
        let normalAttributes = [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16.0, weight: .light) ]
        attributedString.addAttributes(normalAttributes, range: NSMakeRange(0, currentStatus.count))
        self.postTextView.attributedText = attributedString
        //self.layoutSubviews()
    }
}
