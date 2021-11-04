//
//  FeedbackTableViewCell.swift
//  GoogleToolboxForMac
//
//  Created by Matt Lu and Ayman Rahadian on 4/18/19.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {

    //Label for name of meal
    @IBOutlet weak var mealLabel: UILabel!
    //label for the average rating
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
