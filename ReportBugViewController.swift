//
//  ReportBugViewController.swift
//  HDH
//
//  Created by Matt Lu and Ayman Rahadian on 4/24/19.
//  Copyright © 2019 pronto. All rights reserved.
//

import UIKit
import WebKit

class ReportBugViewController: UIViewController {
    
    //Web view display for the report a bug page
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        let myURL = URL(string:"https://docs.google.com/forms/d/e/1FAIpQLSe5h7Zd0FuklgQzjy2r-TwlMzoL5t1erQBHScG9-DVCcWwyLA/viewform?usp=sf_link")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
