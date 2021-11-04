//
//  FIlterLogoViewController.swift
//  HDH
//
//  Created by Matt Lu and Ayman Rahadian on 2/10/19.
//  Copyright © 2019 pronto. All rights reserved.
//

import UIKit

class FIlterLogoViewController: UIViewController {
    
    //header of the filter logo
    @IBOutlet weak var label: UILabel!
    //view container for the pop up
    @IBOutlet weak var myView: UIView!
    //image for the filter logo
    @IBOutlet weak var image: UIImageView!
    //label of description corresponding to filter logo
    @IBOutlet weak var descript: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        showAnimate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //closes the popup
    @IBAction func closePopUp(_ sender: UIButton) {
        hideAnimate()
    }
    
    //animation for when popup appears
    func showAnimate() {
        myView.layer.cornerRadius = 20
        myView.clipsToBounds = true
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    //animation for when popup closes
    func hideAnimate() {
        myView.layer.cornerRadius = 20
        myView.clipsToBounds = true
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished: Bool) in
            if finished{
                self.view.removeFromSuperview()
            }
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
