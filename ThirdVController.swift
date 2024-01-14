//
//  ThirdVController.swift
//  PushUpsSmart
//
//  Created by Amaury C. Rivera on 9/14/23.
//

import UIKit
import GoogleMobileAds

class ThirdVController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, GADBannerViewDelegate {
    
    //Logo Image Reference;
    @IBOutlet weak var logoImageReference: UIImageView!
    //Picker View Reference;
    @IBOutlet weak var PViewReference: UIPickerView!
    //User Input;
    @IBOutlet weak var PushUpInput: UITextField!
    
    @IBOutlet weak var banner: GADBannerView!
    
    //..Core Data Purposes:
    var pushUpsEnteredCore: Int16 = 0
    var pushUpsConvertion: String = ""
    var week1low1SavedData: [String] = []
    
    //Product ID
    let productID: String = "PushUpsSmartNoAds"
    
    //User Defaults Reference from the Second View Controller;
    let userDefaultsReference = SecondVController()
    
    //References of the View Controller variables;
    var variablesViewController = ViewController()

    //WeeksReferenceProgram..
    var WeeksDays: [String] = []
        
    //FourthViewController Reference Variables..
    var titlesReferences: FourthVController?
    var userObjectReferences: FourthVController?
    var week1day1Data: Weeks?
    var week1day2Data: Weeks?
    var week1day3Data: Weeks?
    var week2day1Data: Weeks?
    var week2Day2Data: Weeks?
    var week2Day3Data: Weeks?
    var week3Day1Data: Weeks?
    var week3Day2Data: Weeks?
    var week3Day3Data: Weeks?
    var week4Day1Data: Weeks?
    var week4Day2Data: Weeks?
    var week4Day3Data: Weeks?
    var week5Day1Data: Weeks?
    var week5Day2Data: Weeks?
    var week5Day3Data: Weeks?
    var week6Day1Data: Weeks?
    var week6Day2Data: Weeks?
    var week6Day3Data: Weeks?
        
    var pickerViewDaySelected: String = "0"
    
    var pushUpsEntered: Int = 0
    var pushUpsVerifier: Bool = false
        

    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        //Return just one pickerView component..
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        //It will return and display the grant total of my array..
        return WeeksDays.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return WeeksDays [row]
    }
    
    //Button to move to the next Screen:
    @IBAction func FVControlelrButton(_ sender: UIButton)
    //Cotejar si alguien entro data en el input
    {
        
        if(PushUpInput.text != "")
        {
            pushUpsVerifier = true
            //userDefaultsReference.set(false, forKey: "WorkoutHasBeenSelected")
            //userDefaultsFViewReference.userDefaultsFourthVController.set(false, forKey: "WorkoutHasBeenSelected")
            performSegue(withIdentifier: "FVCIdentifier", sender: self)
            
        }
        else
        {
            Alert.showAlertBox(on: self, with: "Invalid Input❗️", message: "Please fill out the require field ✅")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        var fourthViewController = segue.destination as! FourthVController
        
        if(pushUpsVerifier == true)
        {
            //..It means that the customer didn't enter any number
            fourthViewController.programDataTransfer = week1day1Data
            fourthViewController.daySelected = pickerViewDaySelected
            userDefaultsReference.userDefaults.set(pickerViewDaySelected, forKey: "daySelected")
          
            fourthViewController.programDataWeek1Day2 = week1day2Data
            
            fourthViewController.programDataWeek1Day3 = week1day3Data
            
            fourthViewController.programDataWeek2Day1 = week2day1Data
            
            fourthViewController.programDataWeek2Day2 = week2Day2Data
            
            fourthViewController.programDataWeek2Day3 = week2Day3Data
            
            fourthViewController.programDataWeek3Day1 = week3Day1Data
            
            fourthViewController.programDataWeek3Day2 = week3Day2Data
            
            fourthViewController.programDataWeek3Day3 = week3Day3Data
            
            fourthViewController.programDataWeek4Day1 = week4Day1Data
            
            fourthViewController.programDataWeek4Day2 = week4Day2Data
            
            fourthViewController.programDataWeek4Day3 = week4Day3Data
            
            fourthViewController.programDataWeek5Day1 = week5Day1Data
            
            fourthViewController.programDataWeek5Day2 = week5Day2Data
            
            fourthViewController.programDataWeek5Day3 = week5Day3Data
            
            fourthViewController.programDataWeek6Day1 = week6Day1Data
            
            fourthViewController.programDataWeek6Day2 = week6Day2Data
            
            fourthViewController.programDataWeek6Day3 = week6Day3Data
            pushUpsEntered = Int(PushUpInput.text!)!
            fourthViewController.inputEntered = pushUpsEntered
            userDefaultsReference.userDefaults.set(pushUpsEntered, forKey: "inputEntered")
            
        }
        
        else
        {
           return
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        pickerViewDaySelected = String (row)
   
    }
    

    override func viewDidLoad()
    
    {
        super.viewDidLoad()
        
        //If user actually bought the app
        if isPurchased() {
            
            //..Remove All Ads
            removingAllAds()
        }
        
        else {
            //Show Ads
            showingBannerAds()
        }
        
        banner.isHidden = true
        banner.delegate = self
        banner.adUnitID = "ca-app-pub-3187572158588519/7051416203"
        banner.adSize = kGADAdSizeSmartBannerPortrait
        banner.rootViewController = self
        banner.load(GADRequest())
    
        //..Return key purposes when the user do an input
        PushUpInput.delegate = self
        
        //Adding the placeholderText Text Color
        let placeholderText = NSAttributedString(string: "A Number?", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        PushUpInput.attributedPlaceholder = placeholderText
        
        //..Picker View Reference..
        PViewReference.dataSource = self
        PViewReference.delegate = self
        
        //Disabling the Back button;
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.logoImageReference.image = UIImage(named: "LogoReference")

        WeeksDays = ["Week1-Day1", "Week1-Day2", "Week1-Day3", "Week2-Day1", "Week2-Day2", "Week2-Day3", "Week3-Day1", "Week3-Day2", "Week3-Day3", "Week4-Day1", "Week4-Day2", "Week4-Day3", "Week5-Day1", "Week5-Day2", "Week5-Day3", "Week6-Day1", "Week6-Day2", "Week6-Day3"]
        
        week1day1Data = Weeks (Week: "Week1Day1", Week1Low1: ["2", "3", "2", "2", "+3"], Week1Medium1: ["6", "6", "4", "4", "+5"], Week1High1: ["10", "12", "7", "7", "+9"])
        
        
        week1day2Data = Weeks (Week: "Week1Day2", Week1Low1: ["3", "4", "2", "3", "+4"], Week1Medium1: ["6", "8", "6", "6", "+7"], Week1High1: ["10", "12", "8", "8", "+12"])
        
        week1day3Data = Weeks(Week: "Week1Day3", Week1Low1: ["4", "5", "4", "4", "+5"], Week1Medium1: ["8", "10", "7", "7", "+10"], Week1High1: ["11", "15", "9", "9", "+13"])
        
        week2day1Data = Weeks(Week: "Week2Day1", Week1Low1: ["4", "6", "4", "4", "+6"], Week1Medium1: ["9", "11", "8", "8", "+11"], Week1High1: ["14", "14", "10", "10", "+15"])
        
        week2Day2Data = Weeks(Week: "Week2Day2", Week1Low1: ["5", "6", "4", "4", "+7"], Week1Medium1: ["10", "12", "9", "9", "+13"], Week1High1: ["14", "16", "12", "12", "+17"])
        
        week2Day3Data = Weeks(Week: "Week2Day3", Week1Low1: ["5", "7", "5", "5", "+8"], Week1Medium1: ["12", "13", "10", "10", "15"], Week1High1: ["16", "17", "14", "14", "+20"])
        
        week3Day1Data = Weeks(Week: "Week3Day1", Week1Low1: ["10", "12", "7", "7", "+9"], Week1Medium1: ["12", "17", "13", "13", "+17"], Week1High1: ["14", "18", "14", "14", "+20"])
        
        week3Day2Data = Weeks(Week: "Week3Day2", Week1Low1: ["10", "12", "8", "8", "+12"], Week1Medium1: ["14", "19", "14", "14", "+19"], Week1High1: ["20", "25", "15", "15", "+25"])
        
        week3Day3Data = Weeks(Week: "Week3Day3", Week1Low1: ["11", "13", "9", "9", "+13"], Week1Medium1: ["16", "21", "15", "15", "+21"], Week1High1: ["22", "30", "20", "20", "+28"])
        
        week4Day1Data = Weeks(Week: "Week4Day1", Week1Low1: ["12", "14", "11", "10", "+16"], Week1Medium1: ["18", "22", "16", "16", "+25"], Week1High1: ["21", "25", "21", "21", "+32"])
        
        week4Day2Data = Weeks(Week: "Week4Day2", Week1Low1: ["14", "16", "12", "12", "+18"], Week1Medium1: ["20", "25", "20", "20", "+28"], Week1High1: ["25", "29", "25", "25", "+36"])
        
        week4Day3Data = Weeks(Week: "Week4Day3", Week1Low1: ["16", "18", "13", "13", "+20"], Week1Medium1: ["23", "28", "23", "23", "+33"], Week1High1: ["29", "33", "29", "29", "+40"])
        
        week5Day1Data = Weeks(Week: "Week5Day1", Week1Low1: ["17", "19", "15", "15", "+20"], Week1Medium1: ["28", "35", "25", "22", "+35"], Week1High1: ["36", "40", "30", "24", "+40"])
        
        week5Day2Data = Weeks(Week: "Week5Day2", Week1Low1: ["13", "10", "10", "9", "+25"], Week1Medium1: ["20", "14", "14", "16", "+40"], Week1High1: ["22", "18", "18", "22", "+25"])
        
        week5Day3Data = Weeks(Week: "Week5Day3", Week1Low1: ["15", "12", "12", "10", "+30"], Week1Medium1: ["20", "17", "17", "20", "+45"], Week1High1: ["24", "20", "20", "22", "50"])
        
        week6Day1Data = Weeks(Week: "Week6Day1", Week1Low1: ["25", "30", "20", "15", "+40"], Week1Medium1: ["40", "50", "25", "25", "+50"], Week1High1: ["45", "55", "35", "30", "+55"])
        
        week6Day2Data = Weeks(Week: "Week6Day2", Week1Low1: ["14", "14", "10", "10", "+44"], Week1Medium1: ["20", "20", "18", "18", "+53"], Week1High1: ["24", "24", "18", "18", "+58"])
        
        week6Day3Data = Weeks(Week: "Week6Day3", Week1Low1: ["16", "16", "14", "14", "+50"], Week1Medium1: ["25", "25", "18", "18", "+55"], Week1High1: ["26", "26", "22", "22", "+60"])

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    }
    
    //Tells the delegate an ad request loaded an Ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
        //banner.isHidden = false
        if(isPurchased())
        {
            banner.isHidden = true
        }
        else{
            banner.isHidden = false
        }
        
    }
    
    //Tells the delegate an ad request failed
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        banner.isHidden = true
        
        if(isPurchased())
        {
            banner.isHidden = true
        }
     
    }
    
    func showingBannerAds() {
        
        let removeAllAdsPurchase = userDefaultsReference.userDefaults.bool(forKey: productID)
//        let removeAllAdsPurchase = purchasesSavingData.bool(forKey: productID)
        if(removeAllAdsPurchase)
        {
            //If its true, remove all Ads
            banner.isHidden = true
        }
        else {
            banner.isHidden = false
            
        }
    }

    
    func removingAllAds(){
    
        userDefaultsReference.userDefaults.set(true, forKey: productID)
//    purchasesSavingData.set(true, forKey: productID)
        
    }
    
    // If the application has been bought before;
     func isPurchased() -> Bool {
         let purchasesStatus = userDefaultsReference.userDefaults.bool(forKey: productID)
    //        let purchasesStatus = purchasesSavingData.bool(forKey: productID)
        if purchasesStatus {
            print("Previously Purchased")
            return true
            
            //..Whether Shows Ads or Not;
        }
        
        else{
            print("Never Purchased")
            return false
        }
        
    }

}


//..It's called when return key is press, return NO to ignore;
extension ThirdVController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        PushUpInput.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textField(_ PushUpInput: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Allowed Characters to input on the TextField
        let allowedCharacters = "1234567890"
        let characterSet = CharacterSet(charactersIn: allowedCharacters)
        for character in string {
            if !characterSet.contains(character.unicodeScalars.first!)
            {
                //Entered Character isn't allowed
                //Showing an invalid input message for the user:
                Alert.showAlertBox(on: self, with: "Invalid Input 😅", message: "Please make sure to enter a number in the require field ✅")
                return false
            }
        }
        
        return true
    }
    
}
