//
//  FeedbackViewController.swift
//  HDH
//
//  Created by Matt Lu and Ayman Rahadian on 12/4/18.
//  Copyright © 2018 pronto. All rights reserved.
//

import UIKit
import GoogleSignIn

class FeedbackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Table view for average ratings
    @IBOutlet weak var table: UITableView!
    
    //Fake navigation bar
    @IBOutlet weak var navBar: UINavigationBar!
    
    //Dictionary of meal names : average ratings
    var mealArr:[String:Double] = [:]
    
    override func viewDidLoad() {
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        loadDataFromTable()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedbackCell", for: indexPath) as! FeedbackTableViewCell
        //print(mealArr)
        cell.mealLabel.text = Array(mealArr.keys)[indexPath.row]
        cell.ratingLabel.text = String(Array(mealArr.values)[indexPath.row])
        
        return cell
    }
    
    //Checks backendless for data and aggregates it with the average function
    func loadDataFromTable() {
        let backendless = Backendless.sharedInstance()!
        let readStore = backendless.data.of(MealItem.ofClass())
        Types.tryblock({() -> Void in
            let newArray = readStore?.find() as! [MealItem]
            /*
            for meals in newArray{
                if meals.name == self.mealItem?.name{
                    self.mealItem = meals
                }
            }
            */
            let dataQueryBuilder = DataQueryBuilder()!
            dataQueryBuilder.setProperties(["Avg(rating)", "name"])
            dataQueryBuilder.setGroupByProperties(["name"])
            backendless.data.ofTable("MealItem").find(
                dataQueryBuilder,
                response: { response in
                    
                    let temp = response as! [NSDictionary]
                    for element in temp{
                        if let name = element["name"]{
                            let avg: Double = element["avg"] as! Double
                            self.mealArr.updateValue(Double(avg), forKey: name as! String)
                        }
                    }
                    print("**************", self.mealArr)
                    self.table.reloadData()
            },
                error: { fault in
                    print("Server reported an error: \(fault!)")
            })
        },
                       catchblock: { (exception) -> Void in
                        print("Server reported an error: \(String(describing: exception))")
        })
        print("Load done!")
    }
    
    //Signs user out by programatically creating a new navigation controller and segue
    @IBAction func signOutButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settings = storyboard.instantiateViewController(withIdentifier: "Settings") as! UITableViewController
        let login = storyboard.instantiateViewController(withIdentifier: "Login") as! FeedbackLoginViewController
        let navigationController = UINavigationController(rootViewController: settings)
        navigationController.pushViewController(login, animated: false)
        //appDelegate.window?.rootViewController = navigationController
        let tabBar = appDelegate.window?.rootViewController as! UITabBarController
        tabBar.viewControllers![3] = navigationController
        tabBar.viewControllers![3].tabBarItem.title = "Settings"
        tabBar.viewControllers![3].tabBarItem.image = UIImage(named: "Settings Icon")
        
    }
}
