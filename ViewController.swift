//
//  ViewController.swift
//  PushUpsSmart
//
//  Created by Amaury C. Rivera on 9/13/23.
//

import UIKit
import GoogleMobileAds


class ViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate {

    @IBOutlet weak var logoImageReference: UIImageView!
    @IBOutlet weak var banner: GADBannerView!
    
    //Reference of the Get Start Button;
    @IBOutlet weak var startNowButton: UIButton!
    
    //iOS Test Ads Unit: ca-app-pub-3940256099942544/2934735716
    //iOS Test Interestiads Ads: ca-app-pub-3940256099942544/4411468910
    
    //User Defaults Reference froom the Second View Controller
    let userDefaultsReference = SecondVController()
    

    //Tells the delegate an ad request loaded an Ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        banner.isHidden = false
        
    }
    
    //Tells the delegate an ad request failed
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        banner.isHidden = true
    }

    //    Needs to be the actual Current Workout;
        func PerformingSegueToFourthVController()
        {
            if let value = userDefaultsReference.userDefaults.value(forKey: "AgreementAccepted") as? Bool
            {
                userDefaultsReference.userDefaults.set(true, forKey: "InitialWorkout")
                
                    //Hidden Starting Button on the View Controller;
                    startNowButton.isHidden = true
            
                    //Once the application gets restarted, take them straight to the third View Controller
                    performSegue(withIdentifier: "FVCIdentifier", sender: self)
            }
            
            else {
                return
            }

        }
    

    override func viewDidLoad()
    {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        
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
