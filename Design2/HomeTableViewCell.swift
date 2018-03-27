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
    @IBOutlet weak var tweetName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addCell(avatar: String!, retweeted: String!, name: String!, tweetName: String!, time: String!,
                 content: String!) {
        let image:UIImage = UIImage(named: avatar)!
        self.avatar.image = image
        self.retweeted.text = retweeted + " retweeded"
        self.name.text = name
        self.tweetName.text = "@" + tweetName
        self.time.text = time
        self.content.text = content
        
    }

}
