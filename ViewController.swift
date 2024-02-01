//
//  ViewController.swift
//  PushUpsSmart
//
//  Created by Amaury C. Rivera on 9/13/23.
//
import UIKit
import GoogleMobileAds
import StoreKit

//Adding local push notifications
import UserNotifications

class ViewController: UIViewController, SKPaymentTransactionObserver, GADBannerViewDelegate, GADInterstitialDelegate {
   
    @IBOutlet weak var logoImageReference: UIImageView!
    @IBOutlet weak var banner: GADBannerView!
    
    //Remove Ads Label & Restore Purchases References:
    @IBOutlet weak var removeAdsLabel: UIButton!
    @IBOutlet weak var restorePurchasesLabel: UIButton!
    
    
    //Reference of the Get Start Button;
    @IBOutlet weak var startNowButton: UIButton!
   
    //User Defaults Reference froom the Second View Controller
    let userDefaultsReference = SecondVController()
    let purchasesSavingData = UserDefaults()
    
    //Accessing References Variables from the SecondViewController
    
    //Google Ads Test Units:
    //iOS Test Ads Unit: ca-app-pub-3940256099942544/2934735716
    //iOS Test Interestiads Ads: ca-app-pub-3940256099942544/4411468910
    
    //ProductID: "PushUpsSmartNoAds" - No ads.
    let productID: String = "PushUpsSmartNoAds"
    
    public func isPurchased() -> Bool {
        let purchasesStatus = userDefaultsReference.userDefaults.bool(forKey: productID)
        //let purchasesStatus = purchasesSavingData.bool(forKey: productID)
        if purchasesStatus {
            print("Previously Purchased")
            return true
         
        }
        
        else{
            print("Never Purchased")
            return false
        }
        
    }
    
    func removingAllAds(){
    
    userDefaultsReference.userDefaults.set(true, forKey: productID)
        
    }
    
    //Tells the delegate an ad request loaded an Ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
        if isPurchased(){
            
            //If isPurchased function return value is True, then the user already removed the ads
            banner.isHidden = true
        }
        else{
            //User hasn't purchased the item to remove all Ads, show Ads;
            banner.isHidden = false
            
        }
        
    }

    
    //Tells the delegate an ad request failed
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        
        //If there's an request failed, go ahead & hide the banner..
        banner.isHidden = true
        
        //If the user already purchased the item to remove
        if isPurchased(){
            
            //If the user already removed all Ads;
            banner.isHidden = true
        }
    }
    
    //MARK: - In-App Purchase Method - Removing Ads
    func buyAppNoAds(){
        //Checking if the user can actually do the purchase
        if SKPaymentQueue.canMakePayments(){
            
            //Creating a new Request
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
            
        }
        else{
            //Can't make the payment..
            print("Issues with the payment. Unable to process your payment.")
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
    

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
    {
        //Checking each transactions
        for transaction in transactions{
            if transaction.transactionState == .purchased{
                
                //User Payment Successful :)
                print("Transaction Successful")
                
                //Removing AllAds;
                removingAllAds()
                
                //Purchase Successful, Hiding RemoveAds Button
                self.removeAdsLabel.isHidden = true
                
                //Purchases Successful, Hiding the BannerView
                self.banner.isHidden = true
             
                //Once the transaction has been completed, we would need to end the process.
                SKPaymentQueue.default().finishTransaction(transaction)
            }
            else if transaction.transactionState == .failed {
                
                //If its not nil..
                if let error = transaction.error{
                    let errorDescription = error.localizedDescription
                    //User Payment Failed :(
                    print("Transaction Failed due to error \(errorDescription)")
                }
                
                //Once the transaction has been completed, we would need to end the process.
                SKPaymentQueue.default().finishTransaction(transaction)
                
            }
            else if transaction.transactionState == .restored {
                
                //Restoring Purchase;
                removingAllAds()
                print("Transantion Fully Restored")
                
                //If Restore Process is Successful, Hiding the BannerView..
                self.banner.isHidden = true
                
                //Once it gets restored, go ahead ahead and hide the text from the View Controller
                self.removeAdsLabel.isHidden = true
                
                //Terminating Transaction Queue;
                SKPaymentQueue.default().finishTransaction(transaction)
            }
          
        }
        
    }
    
    func restorePurchases(){
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    //Needs to be the actual Current Workout;
    func PerformingSegueToFourthVController()
    {
            if let value = userDefaultsReference.userDefaults.value(forKey: "AgreementAccepted") as? Bool
            {
                userDefaultsReference.userDefaults.set(true, forKey: "InitialWorkout")
                
                    //Hidden Starting, RemoveAds, Restore Purchases Buttons on the View Controller;
                    startNowButton.isHidden = true
                    removeAdsLabel.isHidden = true
                    restorePurchasesLabel.isHidden = true
        
                    //Once the application gets restarted, take them straight to the third View Controller
                    performSegue(withIdentifier: "FVCIdentifier", sender: self)
            }
            
            else {
                return
            }

    }
    
    
    //Remove Ads Label & Restore Purchases References:
    @IBAction func removeAdsButton(_ sender: Any) {
        //Purchase Payment Process:
             buyAppNoAds()
    }
    
    @IBAction func restoreAllPurchasesButton(_ sender: Any) 
    {
            //Restore Purchases Process:
             restorePurchases()
    }
    
    //Checking User Permissions for Notifications;
    func checkUserPermissions(){
        let noticationCenter = UNUserNotificationCenter.current()
        noticationCenter.getNotificationSettings{settings in
            switch settings.authorizationStatus {
                
            case .authorized:
                self.dispatchNotifications()
                
            case .denied:
                return
                
            case .notDetermined:
                noticationCenter.requestAuthorization(options:[.alert, .sound]) {didAllow, error in
                    if(didAllow){
                        self.dispatchNotifications()
                    }
                }
                
            default:
                return
            }
        }
    }
    
    func dispatchNotifications(){
        
        //Identifier for Monday
        let identifierMonday = "PushUps Smart Monday Notification"
        
        //Title Notification
        let title = "Are you ready for your upper body workout today? 😄"
        
        //Message notification
        let body = "Let's get started it now"
        
        //Notification at 3pn
        let hour = 15
        let minute = 0
        let weekDay = 2
        
        //Chage the content of the notification itself;
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        //..Configuring Monday trigger
        var dataComponentMonday = DateComponents()
        dataComponentMonday.hour = hour
        dataComponentMonday.minute = minute
        dataComponentMonday.weekday = weekDay
        
        //Trigger for Monday: It repeats every Monday
        let triggerMonday = UNCalendarNotificationTrigger(dateMatching: dataComponentMonday, repeats: true)
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        //..Removing any previous pending notifications with the same Identifier;
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifierMonday])
        
        //Schedule the notification for Monday again;
        let requestMondayNotification = UNNotificationRequest(identifier: identifierMonday, content: content, trigger: triggerMonday)
        notificationCenter.add(requestMondayNotification)
         
    }
    
    override func viewDidLoad()
    {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        
        //Checking for User Permissions: Local Push Notifications
        checkUserPermissions()
        
        //Hiding the Back Arrow from the Navigation Controller:
        self.navigationItem.hidesBackButton = true
        
        //Assign ourselves to the Delegate Method:
        SKPaymentQueue.default().add(self)
        //If user actually bought the app
        if isPurchased() {
            
            //..Remove All Ads
            removingAllAds()
        } 
        
        else {
            //Show Ads
            showingBannerAds()
        }

        //Checking if the User already agreed to health agreement when the apps gets rebooted;
        PerformingSegueToFourthVController()
        
        //..Reference of Logo Image
        self.logoImageReference.image = UIImage(named: "LogoReference")
        
        //..Enabling Navigation Controller Back Button again;
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)

        //We don't know whether we have an Ad to show to the user;
        banner.isHidden = true
        banner.delegate = self
        banner.adUnitID = "ca-app-pub-3187572158588519/7051416203"
        banner.adSize = kGADAdSizeSmartBannerPortrait
        banner.rootViewController = self
        banner.load(GADRequest())
      }
    
}
