//
//  User.swift
//  Design2
//
//  Created by LeeX on 4/5/18.
//  Copyright © 2018 LeeX. All rights reserved.
//

import Foundation

struct User: Codable {
    var name: String!
    var screenName: String!
    var profileURLString: String!
    
    init(name: String, screenName: String, profileURLString: String) {
        self.name = name
        self.screenName = screenName
        self.profileURLString = profileURLString
    }
}
