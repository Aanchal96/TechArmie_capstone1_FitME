//
//  AppSettingViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-08-01.
//

import UIKit
import StoreKit
import MessageUI

class AppSettingViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var accountSettingView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var rateUsView: UIView!
    @IBOutlet weak var termsAndConditionsView: UIView!
    @IBOutlet weak var privacyPolicyView: UIView!
    @IBOutlet weak var subscriptionView: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userStartWeightTextLabel: UILabel!
    @IBOutlet weak var userCurrentWeightTextLabel: UILabel!
    @IBOutlet weak var userWeightChangeTextLabel: UILabel!
    @IBOutlet weak var feedbackAndSupportView: UIView!
    var user: AuthUser!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.user = AuthUser(AppUserDefaults.value(forKey: .fullUserProfile));
        userStartWeightTextLabel.text = "\(user.initialUserWeight.weight) \(user.userWeight.unitSetting)";
        userCurrentWeightTextLabel.text = "\(user.userWeight.weight) \(user.userWeight.unitSetting)";
        
        userWeightChangeTextLabel.text = "\(abs(user.userWeight.weight - user.initialUserWeight.weight)) \(user.userWeight.unitSetting)"
        addTapsOnView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.user = AuthUser(AppUserDefaults.value(forKey: .fullUserProfile));
        self.loadValues()
    }
    
    func loadValues() {
        userStartWeightTextLabel.text = "\(user.initialUserWeight.weight) \(user.userWeight.unitSetting)";
        userCurrentWeightTextLabel.text = "\(user.userWeight.weight) \(user.userWeight.unitSetting)";
        
        userWeightChangeTextLabel.text = "\(abs(user.userWeight.weight - user.initialUserWeight.weight)) \(user.userWeight.unitSetting)"
    }
    
    
    @IBAction func logout(_ sender: Any) {
        GoogleLoginController.shared.logout()
        AppUserDefaults.removeAllValues()
        let vc = OnboardingViewController.instantiate(fromAppStoryboard: .Main)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.isNavigationBarHidden = true
        nvc.navigationBar.isHidden = true
        nvc.setNavigationBarHidden(true, animated: true)
        AppDelegate.shared.window?.rootViewController = nvc
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    @objc func accountSettingTap(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = AccountSettingViewController.instantiate(fromAppStoryboard: .Account)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func subscriptionViewTap(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = SubscriptionViewController.instantiate(fromAppStoryboard: .Account)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        self.navigationController?.presentVC(vc)
    }

    @objc func share(tapGestureRecognizer: UITapGestureRecognizer) {
        let firstActivityItem = "Share FitMe with loved ones 🚴🏻‍♀️🏊🏻‍♀️🏋🏻‍♀️🧘🏻‍♀️🤸🏻🎉 \n\n\n https://fitme.test-project.link/share.html"
        let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem], applicationActivities: nil)
            
        activityViewController.popoverPresentationController?.sourceView = shareView
            
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message,
            UIActivity.ActivityType.mail,
        ] as? UIActivityItemsConfigurationReading
            
            // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.message,
            UIActivity.ActivityType.mail,
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook,
        ]
            
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func rateUs(tapGestureRecognizer: UITapGestureRecognizer) {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    @objc func termsAndConditionTap(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = TermsAndConditionsViewController.instantiate(fromAppStoryboard: .Account)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func privacyPolicyTap(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = PrivacyPolicyViewController.instantiate(fromAppStoryboard: .Account)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func feedbackAndSupportTap(tapGestureRecognizer: UITapGestureRecognizer) {
        debugPrint("feedbackAndSupportTap")
        // Modify following variables with your text / recipient
                    let recipientEmail = "support@fitme.com"
                    let subject = "Feedback || iOS"
                    let body = ""
         
                    // Show default mail composer
                    if MFMailComposeViewController.canSendMail() {
                        let mail = MFMailComposeViewController()
                        mail.mailComposeDelegate = self
                        mail.setToRecipients([recipientEmail])
                        mail.setSubject(subject)
                        mail.setMessageBody(body, isHTML: false)
         
                        present(mail, animated: true)
         
                    // Show third party email composer if default Mail app is not present
                    } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
                        UIApplication.shared.open(emailUrl)
                    }
    }
    
    internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            switch result {
            case .cancelled:
                print("Mail cancelled")
            case .saved:
                print("Mail saved")
            case .sent:
                print("Mail sent")
            case .failed:
                print("Mail sent failure")
            default:
                break
            }
            self.dismiss(animated: true, completion: nil)
    }

    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }

        return defaultUrl
    }
}

extension AppSettingViewController{
    func addTapsOnView(){
        let accountSettingTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(accountSettingTap(tapGestureRecognizer:)))

        let subscriptionViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(subscriptionViewTap(tapGestureRecognizer:)))
        
        accountSettingView.isUserInteractionEnabled = true
        accountSettingView.addGestureRecognizer(accountSettingTapGestureRecognizer)
        
        subscriptionView.isUserInteractionEnabled = true
        subscriptionView.addGestureRecognizer(subscriptionViewTapGestureRecognizer)
        accountSettingView.isUserInteractionEnabled = true
        accountSettingView.addGestureRecognizer(accountSettingTapGestureRecognizer)
        
        let shareTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(share(tapGestureRecognizer:)))
        shareView.isUserInteractionEnabled = true;
        shareView.addGestureRecognizer(shareTapGestureRecognizer)
        
        let rateUsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rateUs(tapGestureRecognizer:)))
        rateUsView.isUserInteractionEnabled = true;
        rateUsView.addGestureRecognizer(rateUsTapGestureRecognizer)
        
        let termsAndConditionTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(termsAndConditionTap(tapGestureRecognizer:)))
        termsAndConditionsView.isUserInteractionEnabled = true
        termsAndConditionsView.addGestureRecognizer(termsAndConditionTapGestureRecognizer)
        
        let privacyPolicyTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(privacyPolicyTap(tapGestureRecognizer:)))
        privacyPolicyView.isUserInteractionEnabled = true
        privacyPolicyView.addGestureRecognizer(privacyPolicyTapGestureRecognizer)
        
        let feedbackAndSupportTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(feedbackAndSupportTap(tapGestureRecognizer:)))
                feedbackAndSupportView.isUserInteractionEnabled = true
                feedbackAndSupportView.addGestureRecognizer(feedbackAndSupportTapGestureRecognizer)

    }
}
