//
//  HomeTableViewCell.swift
//  Design2
//
//  Created by LeeX on 3/12/18.
//  Copyright © 2018 LeeX. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var retweeted: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favouriteCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addCell(avatar: String!, retweeted: String!, name: String!, screenName: String!, time: String!,
                 content: String!, retweetCount: String!, favouriteCount: String!) {
//        let image:UIImage = UIImage(named: avatar)!
        
        let avatarURL = URL(string: avatar)
        if avatarURL != nil {
            let avatar = NSData(contentsOf: avatarURL!)
            self.avatar.image = UIImage(data: avatar! as Data)
        }
        
//        self.avatar.image = image
        self.retweeted.text = retweeted + " retweeded"
        self.name.text = name
        self.screenName.text = "@" + screenName
        self.time.text = time
        self.content.text = content
        self.retweetCount.text = retweetCount
        self.favouriteCount.text = favouriteCount
        
    }

}
