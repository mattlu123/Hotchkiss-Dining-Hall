//
//  MealTimeViewController.swift
//  HDH
//
//  Created by Matt Lu and Ayman Rahadian on 3/28/19.
//  Copyright © 2019 pronto. All rights reserved.
//

import UIKit

class MealTimeViewController: UIViewController {
    
    /*
    @IBAction func bfastButton(_ sender: Any) {
    }
    @IBAction func lunchButton(_ sender: Any) {
    }
    @IBAction func dinnerButton(_ sender: Any) {
    }
    @IBAction func brunchButton(_ sender: Any) {
    }
    */
 
    override func viewDidLoad() {
        
        let imageView = UIImageView()
        imageView.frame.size.width = 1
        imageView.frame.size.height = 1
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "Icon text")
        imageView.image = image
        navigationItem.titleView = imageView
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MealListViewController{
            if segue.identifier == "breakfast"{
                destination.name = "Breakfast"
            }else if segue.identifier == "lunch"{
                destination.name = "Lunch"
            }else if segue.identifier == "dinner"{
                destination.name = "Dinner"
            }else if segue.identifier == "brunch"{
                destination.name = "Brunch"
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
