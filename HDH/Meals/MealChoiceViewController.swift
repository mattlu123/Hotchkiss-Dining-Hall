//
//  MealChoiceViewController.swift
//  HDH
//
//  Created by Matt Lu and Ayman Rahadian on 12/1/18.
//  Copyright © 2018 pronto. All rights reserved.
//

import UIKit

//dictionary of ID : Ratings for saving data locally
//return returns the dictionary
var ratings: [Int: Double?] = {
    
    var temp: [Int: Double?] = [:]
    for element in testMeals{
        temp.updateValue(nil, forKey: element.myID)
    }
    return temp
}()

class MealChoiceViewController: UIViewController {
    
    //backendless object
    let backendless = Backendless.sharedInstance()!
    
    //image of yellow star for ratings
    let image = UIImage(named: "yellowstar")
    
    //image of empty star for ratings
    let emptyImage = UIImage(named: "emptystar")
    
    //array of buttons for the filter logos
    @IBOutlet var labelCollection: [UIButton]!
    
    //image of the meal item
    @IBOutlet weak var FoodImage: UIImageView!
    
    //label of the meal item description
    @IBOutlet weak var descriptionLabel: UITextView!
    
    //label of the meal item name
    @IBOutlet weak var nameLabel: UILabel!
    
    //label of the thank you message after rating submission
    @IBOutlet weak var thanksLabel: UILabel!
    
    //the submit ratings button
    @IBOutlet weak var submitButton: UIButton!
    
    //meal item image passed from prepare segue function
    var pic: UIImage?
    
    //meal item name passed from prepare segue function
    var name: String?
    
    //meal item description passed from prepare segue function
    var descript: String?
    
    //meal item object passed from prepare segue function
    var mealItem: MealItem?
    
    //array of buttons for the rating system
    @IBOutlet var ratingCollection: [UIButton]!
    
    //Filter of the meal item
    var filter: [String]?
    
    //given rating for the meal item
    var rating = 0.0
    
    //type of the selected filter logo
    var logoType = ""
    
    //header of the selected filter logo
    var logoHeader = ""
    
    //description of filter logo
    var logoDescription = "Default"
    
    //the current day of month
    //return returns current day of month
    var day = { () -> Int in
        let calendar = Calendar.current
        var clock = Date()
        return calendar.component(.day, from: clock)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("")
        var mealIdentification = self.mealItem?.myID
        print("Meal ID: \(mealIdentification)")
        print("")
        
        FoodImage.image = UIImage(named: "defaultImage")
        nameLabel.text = name
        descriptionLabel.text = descript
        
        ratingSetup()
        
        filterSetup()
        
        for num in 0...labelCollection.count-1 {
            labelCollection[num].addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }
        
        //loadDataFromTable()
        print("Day: \(day)")
        updateMealTime()
    }
    
    //resets the ratings every 24 hours
    func updateMealTime(){
        
        let preferences = UserDefaults.standard
        let tempDay = preferences.integer(forKey: "day")
        print("Old Day: \(tempDay), Current Day: \(day)")
        if tempDay != day {
            preferences.set(day, forKey: "day")
            preferences.removeObject(forKey: "dict1")
        }
    }
    
    //button to select the filter logos
    //@param sender -- the button being referenced
    @objc func buttonAction(sender: UIButton!) {
        if sender.currentTitle == "DF"{
            logoType = "DF"
            logoHeader = FilterItem.category["DF"]!
            logoDescription = "NO dairy"
        }else if sender.currentTitle == "GF"{
            logoType = "GF"
            logoHeader = FilterItem.category["GF"]!
            logoDescription = "Does not contain wheat/gluten"
        }else if sender.currentTitle == "FF"{
            logoType = "FF"
            logoHeader = FilterItem.category["FF"]!
            logoDescription = "Vegetables and proteins from Hotchkiss Farm"
        }else if sender.currentTitle == "HS"{
            logoType = "HS"
            logoHeader = FilterItem.category["HS"]!
            logoDescription = "House-smoked (Ham, bacon, etc.)"
        }else if sender.currentTitle == "L"{
            logoType = "L"
            logoHeader = FilterItem.category["L"]!
            logoDescription = "Products sourced within 100 miles"
        }else if sender.currentTitle == "O"{
            logoType = "O"
            logoHeader = FilterItem.category["O"]!
            logoDescription = "All beans, legumes, and most grains"
        }else if sender.currentTitle == "V"{
            logoType = "V"
            logoHeader = FilterItem.category["V"]!
            logoDescription = "NO meat"
        }else if sender.currentTitle == "VG"{
            logoType = "VG"
            logoHeader = FilterItem.category["VG"]!
            logoDescription = "NO meat, dairy, eggs, or honey"
        }
        
        popOverSetup()
    }
    
    //sets up the popover screen for the filter logos
    func popOverSetup(){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUp") as! FIlterLogoViewController
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        popOverVC.image.image = UIImage(named: logoType)
        popOverVC.descript.text = logoDescription
        popOverVC.label.text = logoHeader
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }

    //sets up the rating system
    func ratingSetup(){
        
        ratings = getRating()
        
        if let value = ratings[mealItem!.myID]{
            if let unwrappedValue = value{
                print("Val: \(unwrappedValue)")
                submitButton.isEnabled = false
                for number in 1...Int(unwrappedValue){
                    updateRatingImage(num: number-1)
                    thanksLabel.text = "Rating submitted"
                }
                for number in 0...4{
                    ratingCollection[number].isEnabled = false
                }
            }
        }
    }
    
    //sets the rating variable to 1 once user interaction
    @IBAction func button1(_ sender: UIButton) {
        resetImage()
        updateRatingImage(num: 0)
        rating = 1
    }
    //sets the rating variable to 2 once user interaction
    @IBAction func button2(_ sender: UIButton) {
        resetImage()
        for num in 0...1{
            updateRatingImage(num: num)
        }
        rating = 2
    }
    //sets the rating variable to 3 once user interaction
    @IBAction func button3(_ sender: UIButton) {
        resetImage()
        for num in 0...2{
            updateRatingImage(num: num)
        }
        rating = 3
    }
    //sets the rating variable to 4 once user interaction
    @IBAction func button4(_ sender: UIButton) {
        resetImage()
        for num in 0...3{
            updateRatingImage(num: num)
        }
        rating = 4
    }
    //sets the rating variable to 5 once user interaction
    @IBAction func button5(_ sender: UIButton) {
       resetImage()
        for num in 0...4{
            updateRatingImage(num: num)
        }
        rating = 5
    }
    
    //Submits selected rating to backendless, disables the ratings, triggers the "thank you for rating" message
    @IBAction func submitButton(_ sender: UIButton) {
        if rating == 0{
            thanksLabel.text = "Please choose a rating"
        }else{
            for num in 0...4{
                ratingCollection[num].isEnabled = false
            }
            submitButton.isEnabled = false
            thanksLabel.text = "Rating submitted"
            //count += 1
            
            updateRating()
            mealItem?.updateRating(newRating: rating)
            saveRating()
            saveDataToTable()
        }
    }
    
    //saves the given rating for meal item locally
    func saveRating(){
        let preferences = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: ratings)
        preferences.set(encodedData, forKey: "dict1")
    }
    
    //retrieves the locally saved rating for meal item
    //return returns the locally saved dictionary if it exists
    func getRating() -> [Int: Double?] {
        let preferences = UserDefaults.standard
        
        print("")
        print("Ratings: \(ratings)")
        print("")
        
        if preferences.object(forKey: "dict1") != nil{
            let decoded = preferences.object(forKey: "dict1") as! Data
            let decodedDict = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Int: Double?]
            
            print("Decoded: \(decodedDict)")
            
            return decodedDict
        } else {
            var temp: [Int: Double?] = [:]
            for element in testMeals{
            temp.updateValue(nil, forKey: element.myID)
            }
            return temp
        }
    }
    
    //updates the star images of the rating system
    //@param num -- number of stars to update image for
    func updateRatingImage(num: Int){
        ratingCollection[num].setImage(image, for: .normal)
    }
    
    //resets the star images of the rating system
    func resetImage(){
        for num in 0...4{
            ratingCollection[num].setImage(emptyImage, for: .normal)
        }
    }
    
    //sets up the filter images for the filter logos
    func filterSetup(){
        for filterElement in filter!{
            if filterElement == "Dairy Free"{
                labelCollection[0].setImage(UIImage(named: "DF"), for: .normal)
            }else if filterElement == "Hotchkiss Grown"{
                labelCollection[1].setImage(UIImage(named: "FF"), for: .normal)
            }else if filterElement == "Gluten Free"{
                labelCollection[2].setImage(UIImage(named: "GF"), for: .normal)
            }else if filterElement == "House Smoked"{
                labelCollection[3].setImage(UIImage(named: "HS"), for: .normal)
            }else if filterElement == "Local"{
                labelCollection[4].setImage(UIImage(named: "L"), for: .normal)
            }else if filterElement == "Organic"{
                labelCollection[5].setImage(UIImage(named: "O"), for: .normal)
            }else if filterElement == "Vegetarian"{
                labelCollection[6].setImage(UIImage(named: "V"), for: .normal)
            }else if filterElement == "Vegan"{
                labelCollection[7].setImage(UIImage(named: "VG"), for: .normal)
            }
        }
    }

    //updates the rating dictionary
    func updateRating(){
        for num in 1...ratings.count{
            if mealItem!.myID == Array(ratings.keys)[num-1]{
                ratings.updateValue(rating, forKey: mealItem!.myID)
            }
        }
    }
    
    //sends user to the feedback tab of the app
    //@param sender -- the button referenced
    @IBAction func addFeedButton(_ sender: UIButton) {
        tabBarController?.selectedIndex = 2
    }
    
    //saves rating data to backendless
    func saveDataToTable() {
        
        let writeStore = backendless.data.of(MealItem.ofClass())
        if let meal = self.mealItem {
            Types.tryblock({() -> Void in
                    _ = writeStore?.save(meal) as Any
                
            },
                           catchblock: { (exception) -> Void in
                            print("Server reported an error: \(String(describing: exception))")
            })
            print("Save done!")
        }
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
