//
//  FilterOptionsViewController.swift
//  HDH
//
//  Created by Matt Lu and Ayman Rahadian on 3/30/19.
//  Copyright © 2019 pronto. All rights reserved.
//

import UIKit

class FilterOptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //The table view that contains the filter options
    @IBOutlet weak var filterTableView: UITableView!
    
    //Outlet for the Back button that brings user back to MealListViewController
    @IBOutlet weak var backButton: UIButton!

    //Action for the Back button that brings user back to MealListViewController
    @IBAction func backButtonAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.layer.cornerRadius = backButton.frame.size.width / 2
        self.navigationItem.setHidesBackButton(true, animated:true)

        filterTableView.delegate = self
        filterTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return FilterItem.category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterOptionCell", for: indexPath)
        
        var filterNames = Array(FilterItem.category.values)
        var filterLogos = Array(FilterItem.category.keys)
        
        let cat = filterNames[indexPath.row]
        let picName = filterLogos[indexPath.row]
        let pic = UIImage(named: picName)
        
        cell.textLabel?.text = cat
        cell.imageView?.image = pic
        
        if myFilterChoice[cat] == true{
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1.0)
        }
        else{
            cell.accessoryType = .none
            cell.textLabel?.textColor = .black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        if let filterName = selectedCell?.textLabel?.text{
            myFilterChoice[filterName] = !myFilterChoice[filterName]!
        }
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        tempMeals.removeAll()
    }

    /*
    Action for the clear filter that clears any selected filter
    and brings user back to the MealListViewController
    */
    @IBAction func clearFilterButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
        let keyArray = Array(myFilterChoice.keys)
        for num in 0...keyArray.count-1{
            myFilterChoice[keyArray[num]] = false
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
