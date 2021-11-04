
//
//  WebViewController.swift
//  GoogleToolboxForMac
//
//  Created by Matt Lu and Ayman Rahadian on 4/8/19.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    //Web view display for the feedback form
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://docs.google.com/forms/d/e/1FAIpQLSfhwNzJ6e2q29mYRdcpGulkBy-kX_JN-rUCz2dQEjc-IY5-Rg/viewform?usp=sf_link")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
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
