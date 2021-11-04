//
//  ViewController.swift
//  HDH
//
//  Created by Matt Lu and Ayman Rahadian on 11/15/18.
//  Copyright © 2018 pronto. All rights reserved.
//

import UIKit
import WebKit
import SwiftSoup

//List of Meal Items of the day from the entire menu
var testMeals: [MealItem] = []

//Checks if the day is Sunday
var isSunday = false

//List of Meal Items of the day from the breakfast menu
var MealsBfast: [MealItem] = []

//List of Meal Items of the day from the lunch menu
var MealsLunch: [MealItem] = []

//List of Meal Items of the day from the dinner menu
var MealsDinner: [MealItem] = []

//List of Meal Items of the day from the brunch menu
var MealsBrunch: [MealItem] = []

//Stuct of details obtained from the Daily Menu website
struct mealDetails {
    var detail: String
    var filter: [String]
}

class ViewController: UIViewController {

    //Segmented Control that differentiates the Breakfast, Lunch, and Dinner menu
    @IBOutlet weak var scSegment: UISegmentedControl!

    //Label for the date of the menu
    @IBOutlet weak var lblDate: UILabel!
    
    //Label for the title (Main meal) of the menu
    @IBOutlet weak var lblTitle: UILabel!
    
    //Label for the time range of the menu
    @IBOutlet weak var lblTime: UILabel!
    
    //Text view that displays the menu
    @IBOutlet weak var txtBody: UITextView!
    
    //The day of the menu
    var myMealDay = [mealDetails]()
    
    //The title (main meal) of the menu
    var myMealTitle = [mealDetails]()
    
    //The time range of the menu
    var myMealTime = [mealDetails]()
    
    //Array of HTML elements of individual meal items from the breakfast menu
    var myMealList1 = [mealDetails]()
    
    //Array of HTML elements of individual meal items from the lunch menu
    var myMealList2 = [mealDetails]()
    
    //Array of HTML elements of individual meal items from the dinner menu
    var myMealList3 = [mealDetails]()
    
    //Array of String elements of individual meal items from the breakfast menu
    var myMealList1Details = [String]()
    
    //Array of String elements of individual meal items from the lunch menu
    var myMealList2Details = [String]()
    
    //Array of String elements of individual meal items from the dinner menu
    var myMealList3Details = [String]()
    
    //A single String that contains the entire breakfast menu
    var myMealList1Final: String = ""
    
    //A single String that contains the entire lunch menu
    var myMealList2Final: String = ""
    
    //A single String that contains the entire dinner menu
    var myMealList3Final: String = ""
    
    //Calendar object
    let calendar = Calendar.current
    
    //Date object
    var clock = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hour = calendar.component(.hour, from: clock)
        //let minutes =calendar.component(.minute, from: clock)
        
        if hour >= 0 && hour <= 9{
            scSegment.selectedSegmentIndex = 0
        }else if hour >= 10 && hour <= 13{
            scSegment.selectedSegmentIndex = 1
        }else{
            scSegment.selectedSegmentIndex = 2
        }
        
        loadDailyMeal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    /*
    Loads daily menu by extracting information from the Hotchkiss' Daily Menu website and
    displaying them on the appropriate labels and text fields
    */
    func loadDailyMeal() {
        let url = URL(string: "https://www.hotchkiss.org/todays-menu")!
        print("Website URL: \(url)")
        print("")
        
        testMeals = []
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                let htmlContent = NSString(data: data!, encoding:
                    String.Encoding.utf8.rawValue)
                
                do {
                    let doc: Document = try SwiftSoup.parse(htmlContent as! String)
                    let body: Element = doc.body()!
                    
                    let mealDate: [Element] = try
                        body.getElementsByClass("fsDate").array()
                    
                    let mealTitle: [Element] = try
                        body.getElementsByClass("fsTitle").array()
                    
                    let mealTimeR: [Element] = try
                        body.getElementsByClass("fsTimeRange").array()
                    
                    let mealDescription: [Element] = try
                        body.getElementsByClass("fsDescription").array()
                    
                    print("MealDescription Array HTML:")
                    print(mealDescription)
                    print("")
                    
                    //Displays the label of the meal day and date
                    print("Meal Day/Dates:")
                    for element in mealDate {
                        let text = try element.text()
                        
                        print(text)
                        
                        if text.contains("Sun"){
                            isSunday = true
                        }
                        else{
                            isSunday = false
                        }
                        
                        self.myMealDay.append(mealDetails(detail: text, filter: []))
                    }
                    
                    print("")
                    
                    //Displays the label of the meal titles
                    print("Meal Titles:")
                    for element in mealTitle {
                        let text = try element.text()
                        
                        print(text)
                        
                        self.myMealTitle.append(mealDetails(detail: text, filter: []))
                    }
                    print("")
                    
                    //Displays the label of the meal times
                    print("Meal Times:")
                    for element in mealTimeR {
                        let text = try element.text()
                        
                        print(text)
                        
                        self.myMealTime.append(mealDetails(detail: text, filter: []))
                    }
                    print("")
                    
                    //Separate mealDescription into Categories
                    for idx in 0...mealDescription.count-1{
                        print("MEAL NUMBER \(idx+1)")
                        
                        print("MealDescription Array \(idx+1) HTML:")
                        print(mealDescription[idx])
                        print("*   *   *")
                        
                        let mealData = mealDescription[idx]
                        
                        let idvMeal: [Element] = try
                            mealData.getElementsByTag("p").array()
                        
                        print("Array of Individual Meal Items:")
                        print(idvMeal)
                        print("*   *   *")
                        
                        if idx == 0 {
                            for element in idvMeal {
                                let text = try element.text()
                                let imageURL = try element.select("img[src]")
                                let imageURLString: [String?] = imageURL.array().map {
                                    try? $0.attr("src").description
                                }
                                
                                print(text)
                                print(imageURLString)
                                
                                if text != "--" && text != "" {
                                    self.myMealList1.append(mealDetails(detail: text, filter: imageURLString as! [String]))
                                }
                            }
                            print("")
                        }
                        else if idx == 1{
                            for element in idvMeal {
                                let text = try element.text()
                                let imageURL = try element.select("img[src]")
                                let imageURLString: [String?] = imageURL.array().map {
                                    try? $0.attr("src").description
                                }
                                
                                print(text)
                                print(imageURLString)
                                
                                if text != "--" && text != "" {
                                    self.myMealList2.append(mealDetails(detail: text, filter: imageURLString as! [String]))
                                }
                            }
                            print("")
                        }
                        else if idx == 2{
                            for element in idvMeal {
                                let text = try element.text()
                                let imageURL = try element.select("img[src]")
                                let imageURLString: [String?] = imageURL.array().map {
                                    try? $0.attr("src").description
                                }
                                
                                print(text)
                                print(imageURLString)
                                
                                if text != "--" && text != "" {
                                    self.myMealList3.append(mealDetails(detail: text, filter: imageURLString as! [String]))
                                }
                            }
                            print("")
                        }
                    }
                    
                    for idx in 0...self.myMealList1.count-1 {
                        let temp = self.myMealList1[idx].detail
                        let filTemp = self.myMealList1[idx].filter
                        
                        self.myMealList1Details.append(temp)
                        
                        if isSunday == false{
                            var MealOne = MealItem(name: temp, descript: "Breakfast", filter: filTemp)
                            testMeals.append(MealOne)
                            MealsBfast.append(MealOne)
                            
                        }
                        else{
                            var sundayMealOne = MealItem(name: temp, descript: "Brunch", filter: filTemp)
                            testMeals.append(sundayMealOne)
                            MealsBrunch.append(sundayMealOne)
                        }
                        
                        for filt in filTemp {
                            if filt == "/uploaded/images/Dining_Hall/b_O.jpg"{
                                testMeals[idx].filter!.append(FilterItem.category["O"]!)
                                if isSunday == false{
                                    MealsBfast[idx].filter!.append(FilterItem.category["O"]!)
                                }
                                if isSunday == true{
                                    MealsBrunch[idx].filter!.append(FilterItem.category["O"]!)
                                }
                            }
                            else if filt == "/uploaded/images/Dining_Hall/b_L.jpg"{
                                testMeals[idx].filter!.append(FilterItem.category["L"]!)
                                if isSunday == false{
                                    MealsBfast[idx].filter!.append(FilterItem.category["L"]!)
                                }
                                if isSunday == true{
                                    MealsBrunch[idx].filter!.append(FilterItem.category["L"]!)
                                }
                            }
                            else if filt == "/uploaded/images/Dining_Hall/b_DF.jpg"{
                                testMeals[idx].filter!.append(FilterItem.category["DF"]!)
                                if isSunday == false{
                                    MealsBfast[idx].filter!.append(FilterItem.category["DF"]!)
                                }
                                if isSunday == true{
                                    MealsBrunch[idx].filter!.append(FilterItem.category["DF"]!)
                                }
                            }
                            else if filt == "/uploaded/images/Dining_Hall/b_V.jpg"{
                                testMeals[idx].filter!.append(FilterItem.category["V"]!)
                                if isSunday == false{
                                    MealsBfast[idx].filter!.append(FilterItem.category["V"]!)
                                }
                                if isSunday == true{
                                    MealsBrunch[idx].filter!.append(FilterItem.category["V"]!)
                                }
                            }
                            else if filt == "/uploaded/images/Dining_Hall/b_VG.jpg"{
                                testMeals[idx].filter!.append(FilterItem.category["VG"]!)
                                if isSunday == false{
                                    MealsBfast[idx].filter!.append(FilterItem.category["VG"]!)
                                }
                                if isSunday == true{
                                    MealsBrunch[idx].filter!.append(FilterItem.category["VG"]!)
                                }
                            }
                            else if filt == "/uploaded/images/Dining_Hall/b_GF.jpg"{
                                testMeals[idx].filter!.append(FilterItem.category["GF"]!)
                                if isSunday == false{
                                    MealsBfast[idx].filter!.append(FilterItem.category["GF"]!)
                                }
                                if isSunday == true{
                                    MealsBrunch[idx].filter!.append(FilterItem.category["GF"]!)
                                }
                            }
                            else if filt == "/uploaded/images/Dining_Hall/b_FF.jpg"{
                                testMeals[idx].filter!.append(FilterItem.category["FF"]!)
                                if isSunday == false{
                                    MealsBfast[idx].filter!.append(FilterItem.category["FF"]!)
                                }
                                if isSunday == true{
                                    MealsBrunch[idx].filter!.append(FilterItem.category["FF"]!)
                                }
                            }
                            else if filt == "/uploaded/images/Dining_Hall/b_HS.jpg"{
                                testMeals[idx].filter!.append(FilterItem.category["HS"]!)
                                if isSunday == false{
                                    MealsBfast[idx].filter!.append(FilterItem.category["HS"]!)
                                }
                                if isSunday == true{
                                    MealsBrunch[idx].filter!.append(FilterItem.category["HS"]!)
                                }
                            }
                        }
                    }
                    
                    for idx in 0...self.myMealList2.count-1 {
                        let temp = self.myMealList2[idx].detail
                        let filTemp = self.myMealList2[idx].filter
                        
                        //self.idvCounter = 0
                        
                        self.myMealList2Details.append(temp)
                        
                        if isSunday == false{
                            var MealTwo = MealItem(name: temp, descript: "Lunch", filter: filTemp)
                            testMeals.append(MealTwo)
                            MealsLunch.append(MealTwo)
                        }
                        else{
                            var sundayMealTwo = MealItem(name: temp, descript: "Dinner", filter: filTemp)
                            testMeals.append(sundayMealTwo)
                            MealsDinner.append(sundayMealTwo)
                        }
                        
                        for filt in filTemp {
                            if filt == "/uploaded/images/Dining_Hall/b_O.jpg"{
                                testMeals[self.myMealList1.count+idx].filter!.append(FilterItem.category["O"]!)
                                if isSunday == false{
                                    MealsLunch[idx].filter!.append(FilterItem.category["O"]!)
                                }
                                if isSunday == true{
                                    MealsDinner[idx].filter!.append(FilterItem.category["O"]!)
                                }
                            }
                            else if filt == "/uploaded/images/Dining_Hall/b_L.jpg"{
                                testMeals[self.myMealList1.count+idx].filter!.append(FilterItem.category["L"]!)
                                if isSunday == false{
                                    MealsLunch[idx].filter!.append(FilterItem.category["L"]!)
                                }
                                if isSunday == true{
                                    MealsDinner[idx].filter!.append(FilterItem.category["L"]!)
                                }
                            }
                            else if filt == "/uploaded/images/Dining_Hall/b_DF.jpg"{
                                testMeals[self.myMealList1.count+idx].filter!.append(FilterItem.category["DF"]!)
                                if isSunday == false{
                                    MealsLunch[idx].filter!.append(FilterItem.category["DF"]!)
                                }
                                if isSunday == true{
                                    MealsDinner[idx].filter!.append(FilterItem.category["DF"]!)
                                }
                            }
                            else if filt == "/uploaded/images/Dining_Hall/b_V.jpg"{
                                testMeals[self.myMealList1.count+idx].filter!.append(FilterItem.category["V"]!)
                                if isSunday == false{
                                    MealsLunch[idx].filter!.append(FilterItem.category["V"]!)
                                }
                                if isSunday == true{
                                    MealsDinner[idx].filter!.append(FilterItem.category["V"]!)
                                }
                            }
                            else if filt == "/uploaded/images/Dining_Hall/b_VG.jpg"{
                                testMeals[self.myMealList1.count+idx].filter!.append(FilterItem.category["VG"]!)
                                if isSunday == false{
                                    MealsLunch[idx].filter!.append(FilterItem.category["VG"]!)
                                }
                                if isSunday == true{
                                    MealsDinner[idx].filter!.append(FilterItem.category["VG"]!)
                                }
                            }
                            else if filt == "/uploaded/images/Dining_Hall/b_GF.jpg"{
                                testMeals[self.myMealList1.count+idx].filter!.append(FilterItem.category["GF"]!)
                                if isSunday == false{
                                    MealsLunch[idx].filter!.append(FilterItem.category["GF"]!)
                                }
                                if isSunday == true{
                                    MealsDinner[idx].filter!.append(FilterItem.category["GF"]!)
                                }
                            }
                            else if filt == "/uploaded/images/Dining_Hall/b_FF.jpg"{
                                testMeals[self.myMealList1.count+idx].filter!.append(FilterItem.category["FF"]!)
                                if isSunday == false{
                                    MealsLunch[idx].filter!.append(FilterItem.category["FF"]!)
                                }
                                if isSunday == true{
                                    MealsDinner[idx].filter!.append(FilterItem.category["FF"]!)
                                }
                            }
                            else if filt == "/uploaded/images/Dining_Hall/b_HS.jpg"{
                                testMeals[self.myMealList1.count+idx].filter!.append(FilterItem.category["HS"]!)
                                if isSunday == false{
                                    MealsLunch[idx].filter!.append(FilterItem.category["HS"]!)
                                }
                                if isSunday == true{
                                    MealsDinner[idx].filter!.append(FilterItem.category["HS"]!)
                                }
                            }
                        }
                    }
                    
                    if self.myMealList3.count != 0{
                        for idx in 0...self.myMealList3.count-1 {
                            let temp = self.myMealList3[idx].detail
                            let filTemp = self.myMealList3[idx].filter
                            
                            self.myMealList3Details.append(temp)
                            
                            var MealThree = MealItem(name: temp, descript: "Dinner", filter: filTemp)
                            
                            testMeals.append(MealThree)
                            MealsDinner.append(MealThree)
                            
                            
                            for filt in filTemp {
                                if filt == "/uploaded/images/Dining_Hall/b_O.jpg"{
                                    testMeals[self.myMealList1.count+self.myMealList2.count+idx].filter!.append(FilterItem.category["O"]!)
                                    MealsDinner[idx].filter!.append(FilterItem.category["O"]!)
                                }
                                else if filt == "/uploaded/images/Dining_Hall/b_L.jpg"{
                                    testMeals[self.myMealList1.count+self.myMealList2.count+idx].filter!.append(FilterItem.category["L"]!)
                                    MealsDinner[idx].filter!.append(FilterItem.category["L"]!)
                                }
                                else if filt == "/uploaded/images/Dining_Hall/b_DF.jpg"{
                                    testMeals[self.myMealList1.count+self.myMealList2.count+idx].filter!.append(FilterItem.category["DF"]!)
                                    MealsDinner[idx].filter!.append(FilterItem.category["DF"]!)
                                }
                                else if filt == "/uploaded/images/Dining_Hall/b_V.jpg"{
                                    testMeals[self.myMealList1.count+self.myMealList2.count+idx].filter!.append(FilterItem.category["V"]!)
                                    MealsDinner[idx].filter!.append(FilterItem.category["V"]!)
                                }
                                else if filt == "/uploaded/images/Dining_Hall/b_VG.jpg"{
                                    testMeals[self.myMealList1.count+self.myMealList2.count+idx].filter!.append(FilterItem.category["VG"]!)
                                    MealsDinner[idx].filter!.append(FilterItem.category["VG"]!)
                                }
                                else if filt == "/uploaded/images/Dining_Hall/b_GF.jpg"{
                                    testMeals[self.myMealList1.count+self.myMealList2.count+idx].filter!.append(FilterItem.category["GF"]!)
                                    MealsDinner[idx].filter!.append(FilterItem.category["GF"]!)
                                }
                                else if filt == "/uploaded/images/Dining_Hall/b_FF.jpg"{
                                    testMeals[self.myMealList1.count+self.myMealList2.count+idx].filter!.append(FilterItem.category["FF"]!)
                                    MealsDinner[idx].filter!.append(FilterItem.category["FF"]!)
                                }
                                else if filt == "/uploaded/images/Dining_Hall/b_HS.jpg"{
                                    testMeals[self.myMealList1.count+self.myMealList2.count+idx].filter!.append(FilterItem.category["HS"]!)
                                    MealsDinner[idx].filter!.append(FilterItem.category["HS"]!)
                                }
                            }
                        }
                    }
                    
                    for string in self.myMealList1Details {
                        self.myMealList1Final += "\(string)\n\n"
                    }
                    
                    for string in self.myMealList2Details {
                        self.myMealList2Final += "\(string)\n\n"
                    }
                    
                    for string in self.myMealList3Details {
                        self.myMealList3Final += "\(string)\n\n"
                    }
                    
                    DispatchQueue.main.async {
                        if isSunday == false{
                            self.lblDate.text = self.myMealDay[self.scSegment.selectedSegmentIndex].detail
                            self.lblTitle.text = self.myMealTitle[self.scSegment.selectedSegmentIndex].detail
                            self.lblTime.text = self.myMealTime[self.scSegment.selectedSegmentIndex].detail
                            
                            if self.scSegment.selectedSegmentIndex == 0{
                                self.txtBody.text = self.myMealList1Final
                            }
                            if self.scSegment.selectedSegmentIndex == 1{
                                self.txtBody.text = self.myMealList2Final
                            }
                            if self.scSegment.selectedSegmentIndex == 2{
                                self.txtBody.text = self.myMealList3Final
                            }
                        } else{
                            if self.scSegment.selectedSegmentIndex == 0{
                                self.lblDate.text = self.myMealDay[self.scSegment.selectedSegmentIndex].detail
                                self.lblTitle.text = self.myMealTitle[self.scSegment.selectedSegmentIndex].detail
                                self.lblTime.text = self.myMealTime[self.scSegment.selectedSegmentIndex].detail
                                self.txtBody.text = self.myMealList1Final
                            }
                            if self.scSegment.selectedSegmentIndex == 1{
                                self.lblDate.text = self.myMealDay[0].detail
                                self.lblTitle.text = self.myMealTitle[0].detail
                                self.lblTime.text = self.myMealTime[0].detail
                                self.txtBody.text = self.myMealList1Final
                            }
                            if self.scSegment.selectedSegmentIndex == 2{
                                self.lblDate.text = self.myMealDay[1].detail
                                self.lblTitle.text = self.myMealTitle[1].detail
                                self.lblTime.text = self.myMealTime[1].detail
                                self.txtBody.text = self.myMealList2Final
                            }
                        }
                    }
                    
                } catch Exception.Error(let type, let message) {
                    print(message)
                } catch {
                    print("error")
                }
            }
            
            if MealsBfast.count == 0{
                MealsBfast.append(MealItem(name: "Menu is Unavailable", descript: "", filter: []))
            }
            if MealsLunch.count == 0{
                MealsLunch.append(MealItem(name: "Menu is Unavailable", descript: "", filter: []))
            }
            if MealsDinner.count == 0{
                MealsDinner.append(MealItem(name: "Menu is Unavailable", descript: "", filter: []))
            }
            if MealsBrunch.count == 0{
                MealsBrunch.append(MealItem(name: "Menu is Unavailable", descript: "", filter: []))
            }
            
        }
        
        task.resume()
        
    }
    
    //Action that change the labels and texts depending on the Segmented Control
    @IBAction func segmentedControl(_ sender: Any) {
        let controlIndex = scSegment.selectedSegmentIndex
        
        if myMealDay.isEmpty == true {
            
        }else{
            if isSunday == false{
                if controlIndex == 0{
                    lblDate.text = myMealDay[0].detail
                    lblTitle.text = myMealTitle[0].detail
                    lblTime.text = myMealTime[0].detail
                    txtBody.text = myMealList1Final
                }
                else if controlIndex == 1{
                    lblDate.text = myMealDay[1].detail
                    lblTitle.text = myMealTitle[1].detail
                    lblTime.text = myMealTime[1].detail
                    txtBody.text = myMealList2Final
                }
                else if controlIndex == 2{
                    lblDate.text = myMealDay[2].detail
                    lblTitle.text = myMealTitle[2].detail
                    lblTime.text = myMealTime[2].detail
                    txtBody.text = myMealList3Final
                }
            }
            else{
                if controlIndex == 0{
                    lblDate.text = myMealDay[0].detail
                    lblTitle.text = myMealTitle[0].detail
                    lblTime.text = myMealTime[0].detail
                    txtBody.text = myMealList1Final
                }
                else if controlIndex == 1{
                    lblDate.text = myMealDay[0].detail
                    lblTitle.text = myMealTitle[0].detail
                    lblTime.text = myMealTime[0].detail
                    txtBody.text = myMealList1Final
                }
                else if controlIndex == 2{
                    lblDate.text = myMealDay[1].detail
                    lblTitle.text = myMealTitle[1].detail
                    lblTime.text = myMealTime[1].detail
                    txtBody.text = myMealList2Final
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
