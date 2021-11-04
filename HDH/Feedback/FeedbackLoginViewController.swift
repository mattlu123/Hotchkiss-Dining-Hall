//
//  FeedbackLoginViewController.swift
//  HDH
//
//  Created by Matt Lu and Ayman Rahadian on 12/4/18.
//  Copyright © 2018 pronto. All rights reserved.
//

import UIKit
import GoogleSignIn

class FeedbackLoginViewController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
