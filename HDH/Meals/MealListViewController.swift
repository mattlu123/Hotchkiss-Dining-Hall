//
//  MealListViewController.swift
//  HDH
//
//  Created by Matt Lu and Ayman Rahadian on 3/30/19.
//  Copyright © 2019 pronto. All rights reserved.
//

import UIKit

//Temporary list of Meal Item
var tempMeals: [MealItem] = []

//Counter for number of filters that are false
var counter = 0

//Array of filter that are selected by the user
var addedFilter: [String] = []

class MealListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //The table view that contains the meal items
    @IBOutlet weak var MealListTable: UITableView!
    
    //The button that brings user to the FilterOptionsViewController
    @IBOutlet weak var filterButton: UIButton!
    
    //The name of the meal based on the time selected (Breakfast, Lunch, or Dinner)
    var name = ""
    
    //Refreshes the MealListTable when dragged down
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(MealListViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.blue
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = name

        filterButton.layer.cornerRadius = filterButton.frame.size.width / 2
        MealListTable.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return tableMeals[section].count
        
        return tempMeals.count
    }
    
    //Reloads the table
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        MealListTable.reloadData()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! MealListCell
        
        if tempMeals.count != 0{
            //let food = tableMeals[indexPath.section][indexPath.row]
            let food = tempMeals[indexPath.row]
            
            cell.mealItem = food
            cell.mealFilter = food.filter
            cell.titleLabel?.text = food.name
            cell.subtitleLabel?.text = food.descript
            cell.cellImage?.image = UIImage(named: "defaultImage")
            if food.name == "Menu is Unavailable"{
                cell.isUserInteractionEnabled = false
            } else{
                cell.isUserInteractionEnabled = true
            }
            
        }
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tempMeals = []
        counter = 0
        addedFilter = []
        
        let numFalse = Array(myFilterChoice.values)
        for idx in numFalse{
            if idx == false{
                counter += 1
            }
        }
        
        if counter == 8{
            if name == "Breakfast"{
                tempMeals = MealsBfast
            }
            else if name == "Lunch"{
                tempMeals = MealsLunch
            }
            if name == "Dinner"{
                tempMeals = MealsDinner
            }
            if name == "Brunch"{
                tempMeals = MealsBrunch
            }
        }
        
        if name == "Breakfast"{
            let temp: [MealItem] = MealsBfast
            
            let keyArray = Array(myFilterChoice.keys)
            
            for num in 0...keyArray.count-1{
                if myFilterChoice[keyArray[num]] == true{
                    addedFilter.append(keyArray[num])
                }
            }
            
            for items in temp{
                let categories = items.filter
                counter = 0
                if addedFilter.count != 0{
                    if addedFilter.count <= categories!.count{
                        for idx in 0...addedFilter.count-1{
                            if categories!.contains(addedFilter[idx]){
                                counter += 1
                            }
                        }
                        if counter == addedFilter.count{
                            tempMeals.append(items)
                        }
                    }
                }
            }
        }
        else if name == "Lunch"{
            let temp: [MealItem] = MealsLunch
            
            let keyArray = Array(myFilterChoice.keys)
            
            for num in 0...keyArray.count-1{
                if myFilterChoice[keyArray[num]] == true{
                    addedFilter.append(keyArray[num])
                }
            }
            
            for items in temp{
                let categories = items.filter
                counter = 0
                if addedFilter.count != 0{
                    if addedFilter.count <= categories!.count{
                        for idx in 0...addedFilter.count-1{
                            if categories!.contains(addedFilter[idx]){
                                counter += 1
                            }
                        }
                        if counter == addedFilter.count{
                            tempMeals.append(items)
                        }
                    }
                }
            }
        }
        if name == "Dinner"{
            let temp: [MealItem] = MealsDinner
            
            let keyArray = Array(myFilterChoice.keys)
            
            for num in 0...keyArray.count-1{
                if myFilterChoice[keyArray[num]] == true{
                    addedFilter.append(keyArray[num])
                }
            }
            
            for items in temp{
                let categories = items.filter
                counter = 0
                if addedFilter.count != 0{
                    if addedFilter.count <= categories!.count{
                        for idx in 0...addedFilter.count-1{
                            if categories!.contains(addedFilter[idx]){
                                counter += 1
                            }
                        }
                        if counter == addedFilter.count{
                            tempMeals.append(items)
                        }
                    }
                }
            }
        }
        if name == "Brunch"{
            let temp: [MealItem] = MealsBrunch
            
            let keyArray = Array(myFilterChoice.keys)
            
            for num in 0...keyArray.count-1{
                if myFilterChoice[keyArray[num]] == true{
                    addedFilter.append(keyArray[num])
                }
            }
            
            for items in temp{
                let categories = items.filter
                counter = 0
                if addedFilter.count != 0{
                    if addedFilter.count <= categories!.count{
                        for idx in 0...addedFilter.count-1{
                            if categories!.contains(addedFilter[idx]){
                                counter += 1
                            }
                        }
                        if counter == addedFilter.count{
                            tempMeals.append(items)
                        }
                    }
                }
            }
        }
        
        MealListTable.reloadData()
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
    */

    /*
    Prepares for segue from MealListViewContorller to MealChoiceViewController,
    as well as transfering additional information regarding the selected meal item.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mealChoice" {
            if let destination = segue.destination as? MealChoiceViewController {
                let cell = sender as! MealListCell
                if let food = cell.titleLabel?.text {
                    destination.pic = UIImage(named: food)
                    destination.name = food
                    destination.title = food
                }
                if let description = cell.subtitleLabel?.text
                {
                    destination.descript = description
                }
                if let meal = cell.mealFilter{
                    destination.filter = meal
                }
                if let meal = cell.mealItem{
                    destination.rating = meal.rating
                    destination.mealItem = meal
                }
            }
        }
    }    
}
