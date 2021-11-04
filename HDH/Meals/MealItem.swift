//
//  MealItem.swift
//  HDH
//
//  Created by Matt Lu and Ayman Rahadian on 11/15/18.
//  Copyright © 2018 pronto. All rights reserved.
//

import Foundation

@objcMembers
class MealItem: NSObject, Codable {
   
    //name of meal item
    var name: String?
    
    //description of meal item (breafast, lunch dinner, brunch)
    var descript: String?
    
    //filters for meal item
    var filter: [String]?
    
    //ID of meal item
    var myID: Int = nextID + 1
    
    //rating of meal item
    var rating: Double = 0
    
    //static variable for the ID of a meal item
    static var nextID: Int = 0
    
    init(name: String, descript: String, filter: [String]) {
        self.name = name
        self.descript = descript
        self.filter = filter
        MealItem.nextID += 1
        
        super.init()
    }
    
    //updates the rating of a meal item
    //@param newRating -- the new rating
    func updateRating(newRating: Double){
        //self.count += 1
        self.rating = newRating
        //self.total = total + newRating
    }

    override init() {
        super.init()
    }
    
}
