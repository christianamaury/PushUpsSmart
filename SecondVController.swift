//
//  SecondVController.swift
//  PushUpsSmart
//
//  Created by Amaury C. Rivera on 9/14/23.
//

import UIKit
import GoogleMobileAds

class SecondVController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate, UITextViewDelegate
{
    //Boolean to check if the user has marked the agreement;
    var buttonHasBeenPressed: Bool = false
    
    //Customer already accepted the agreement; Saving the response;
    public let userDefaults = UserDefaults()
    
    @IBOutlet weak var checkMarkReference: UIButton!
        
    //Disclaimer Label Text Reference;
    @IBOutlet weak var disclaimerTitle: UILabel!
    
    @IBOutlet weak var banner: GADBannerView!
   
    
    //Disclaimer Image Reference;
    @IBOutlet weak var disclaimerImage: UIImageView!
    
   //Disclaimer Text View Reference;
    @IBOutlet weak var disclaimerTextView: UITextView!
    
    
    @IBAction func checkMarkButton(_ sender: UIButton)
    {
        //Assigning transparency background to the image for the button;
        sender.backgroundColor = .clear
        
        //Assigning custom image;
        sender.setBackgroundImage(UIImage(named: "GrayCheckMark"), for: UIControl.State.normal)
        buttonHasBeenPressed = true
    }
    
    //Agree Button;
    @IBAction func agreeButton(_ sender: Any)
    {
        //If the user hasn't agree to the agreement, show an alert
        if (buttonHasBeenPressed != true)
         {
            //..Show an Alertt Message
            Alert.showAlertBox(on: self, with: "You haven't check the white circle yet 😅", message: "Please click on the white circle in order to acknowledge this disclaimer agreement ✅")
         }
         else {
             
             //UserDefaults.resetStandardUserDefaults()
             userDefaults.set(true, forKey: "AgreementAccepted")
             //Performing Segue to the Third View Controller
             performSegue(withIdentifier: "ThirdView", sender: self)
         }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Custom Checkmark Button
        checkMarkReference.frame = CGRect(x: 160, y:100, width: 50, height: 50)
        checkMarkReference.layer.cornerRadius = 0.4 * checkMarkReference.bounds.size.width
        checkMarkReference.clipsToBounds = true
       
        //We don't know whether we have an Ad to show to the customer, so we would hide it.
        banner.isHidden = true
        banner.delegate = self
        banner.adUnitID = "ca-app-pub-3187572158588519/7051416203"
        banner.adSize = kGADAdSizeSmartBannerPortrait
        banner.rootViewController = self
        banner.load(GADRequest())
   
        //..Disclaimer Title;
        self.disclaimerTitle.textColor = UIColor.black
        self.disclaimerTitle.text = "Disclaimer"
        
        //..Disclaimer Image: Logo Reference;
        self.disclaimerImage.image = UIImage(named: "LogoReference")
        
        //..TextView is not Editable
        self.disclaimerTextView.isEditable = false
        
        //..TexView is scrollable
        self.disclaimerTextView.isScrollEnabled = true
        
        //Indicanting to the user that there's a scroll indicator on the textView;
        self.disclaimerTextView.flashScrollIndicators()
        
        //Showing the Vertical Scroll Indicator
        self.disclaimerTextView.showsVerticalScrollIndicator = true
        
        //Text Color of the UITextView: Black
        self.disclaimerTextView.textColor = UIColor.black
        
        //..Removing TextView Background color;
        self.disclaimerTextView.backgroundColor = UIColor(named:"White")
        

        //,,Paragraph Styling Attributes
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 6
        style.lineSpacing = 7
        style.headIndent = 2
        
        let attributes = [NSMutableAttributedString.Key.paragraphStyle: style]
        
        self.disclaimerTextView.typingAttributes = attributes
        
        //..Adding Custom Text to the TewtView
        self.disclaimerTextView.text = "Before proceeding with any physical activity, including the push-up workout, please be aware that you are voluntarily participating at your own risk. We, the creators and providers of this workout program, cannot be held responsible for any injury or harm that may occur as a result of following this exercise routine.                                                                                                                                          While we strive to offer safe and effective exercises, it is crucial to acknowledge that every individual's physical condition varies, and what may be appropriate for one person may not be suitable for another. We strongly advise consulting with a qualified healthcare professional or fitness expert before beginning any new exercise program, especially if you have any pre-existing medical conditions, physical limitations, or concerns about your health.                                                                                                                       By choosing to participate in this push-up workout, you assume all risks associated with the activities involved. You agree to release and hold us harmless from any and all liability for any injuries, damages, or losses that may result from your participation.                                                                                                                                                                            Always listen to your body and exercise within your limits. Stop any exercise immediately if you experience pain, discomfort, or dizziness. Remember that proper form and technique are essential to reduce the risk of injury, so pay attention to the provided instructions.                                                                                                                                                                  By proceeding with this workout, you indicate that you have read, understood, and agreed to this disclaimer. If you do not agree or are unsure about any aspect of this program's suitability for you, refrain from engaging in the activities and seek professional advice instead. Your health and safety are of utmost importance, and we encourage you to prioritize them above all else.                                          Stay safe, stay mindful, and make informed decisions as you work towards your fitness goals.                                                                                                                                                                                                                                                                          (PLEASE CLICK ON THE CIRCLE BELOW TO ACKNOWLEDGE THIS DISCLAIMER AGREEMENT 👇🏽✅"
        }
    

    
    //Tells the delegate an ad request loaded an Ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        banner.isHidden = false
        
    }
    
    //Tells the delegate an ad request failed
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        banner.isHidden = true
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
