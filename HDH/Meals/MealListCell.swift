//
//  MealListCell.swift
//  HDH
//
//  Created by Matt Lu and Ayman Rahadian on 3/30/19.
//  Copyright © 2019 pronto. All rights reserved.
//

import UIKit

class MealListCell: UITableViewCell {
    
    //Label for the title of the meal item
    @IBOutlet weak var titleLabel: UILabel!
    //Label for the description/subtitle of the meal item
    @IBOutlet weak var subtitleLabel: UILabel!
    //Image of the meal item
    @IBOutlet weak var cellImage: UIImageView!
    //Array of filter names
    var mealFilter: [String]?
    //The MealItem object
    var mealItem: MealItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
