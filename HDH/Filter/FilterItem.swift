//
//  FilterItem.swift
//  HDH
//
//  Created by Matt Lu and Ayman Rahadian on 11/15/18.
//  Copyright © 2018 pronto. All rights reserved.
//

import Foundation

//Designate each filter to true or false based on user's choice
var myFilterChoice: [String : Bool] = [
    "Dairy Free": false,
    "Gluten Free": false,
    "House Smoked": false,
    "Hotchkiss Grown": false,
    "Local": false,
    "Organic": false,
    "Vegetarian": false,
    "Vegan": false,
]

//Designate each filter to its abbreviation
struct FilterItem {
    
    static var category: [String: String] = [
        "DF": "Dairy Free",
        "GF": "Gluten Free",
        "HS": "House Smoked",
        "FF": "Hotchkiss Grown",
        "L": "Local",
        "O": "Organic",
        "V": "Vegetarian",
        "VG": "Vegan"
    ]
}
