//
//  Email.swift
//  HDH
//
//  Created by Matt Lu and Ayman Rahadian on 5/13/19.
//  Copyright © 2019 pronto. All rights reserved.
//

import Foundation

@objcMembers
struct Email: NSObject, Codable{
    
    var email: String?
    
    init(email: String){
        self.email = email
        super.init()
    }
    
    override init() {
        super.init()
    }
}
