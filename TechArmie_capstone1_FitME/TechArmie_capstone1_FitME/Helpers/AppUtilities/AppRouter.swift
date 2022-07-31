//
//
//import UIKit
//import SwiftyJSON
//import UserNotifications
//
//enum AppRouter {
//
//    //after changing language
//    static func refreshApp(){
//        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: "NavigationViewController") as? NavigationViewController
//        //TODO:
//        ( (initialViewController)?.viewControllers.first as? TabBarViewController)?.index = 0
//        AppDelegate.shared.window?.rootViewController = initialViewController
//        AppDelegate.shared.window?.becomeKey()
//        AppDelegate.shared.window?.makeKeyAndVisible()
//    }
//
//    //Go to purchase subscription
//    static func goToSubscription(){
//
//        if let nav = AppDelegate.shared.window?.rootViewController as? NavigationViewController, let tabbar = nav.childViewControllers.first as? TabBarViewController, tabbar.selectedIndex == 3{
//            if UserModel.main.subscription.subscriptionStatus != 0{
//            }
//            DispatchQueue.delay(0.3) {
//                let vc = NewSubscriptionVC.instantiate(fromAppStoryboard: .Subscription)
//                UIApplication.topMostVC?.pushControllerFrom(destVC: vc)
//            }
//        }else{
//            let vc = NewSubscriptionVC.instantiate(fromAppStoryboard: .Subscription)
//            UIApplication.topMostVC?.pushControllerFrom(destVC: vc)
//        }
//    }
//
//    ///Open update profile if old user
//    static func goToUpdateProfileIfExistingUser(){
//
//        if UserModel.main.isExistingUser{
//            let vc = StepFirstVC.instantiate(fromAppStoryboard: .PreLogin)
//            vc.isExsistingUser = true
//            vc.isChangeGoal = true
//            if let parentNav = AppDelegate.shared.window?.rootViewController as? UINavigationController{
//                parentNav.pushControllerLikePresentAnimation(destVC: vc)
//
//            }else{
//                UIApplication.topMostVC?.pushControllerFrom(destVC: vc)
//            }
//        }
//    }
//
//    /// Go To Login Screen
//    static func goToLogin() {
//        AppDelegate.shared.shouldShowSubscriptionSlider = false
//        DataCache.instance.cleanAll()
//        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
//        AlarmController.shared.removeAlarm(removeAll: true)
//        AlarmController.shared.removeWaterAlarm()
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//        let lang = CommonFunctions.getLang()
//        AppUserDefaults.removeAllValues()
//        AppUserDefaults.removeValue(forKey: .fullUserProfile)
//        UserModel.main = UserModel()
//        CommonFunctions.setLanguage(lang: lang)
//        let nvc = UINavigationController.init()
//        nvc.isNavigationBarHidden = true
//        nvc.viewControllers = [OnboardingVC.instantiate(fromAppStoryboard: .PreLogin)]
//        UIView.transition(with: AppDelegate.shared.window!, duration: 0.33, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
//            AppDelegate.shared.window?.rootViewController = nvc
//        }, completion: nil)
//        GoogleLoginController.shared.logout()
//        FacebookController.shared.facebookLogout()
//        AppDelegate.shared.window?.becomeKey()
//        AppDelegate.shared.window?.makeKeyAndVisible()
//    }
//
//    /// Go To Any View Controller
//    static func goToVC(viewController: UIViewController) {
//        let nvc = UINavigationController.init()
//        nvc.isNavigationBarHidden = true
//        nvc.automaticallyAdjustsScrollViewInsets = false
//        let vcOnboard = OnboardingVC.instantiate(fromAppStoryboard: .PreLogin)
//        nvc.viewControllers = [vcOnboard , viewController]
//        UIView.transition(with: AppDelegate.shared.window!, duration: 0.33, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
//            AppDelegate.shared.window?.rootViewController = nvc
//        }, completion: nil)
//        AppDelegate.shared.window?.becomeKey()
//        AppDelegate.shared.window?.makeKeyAndVisible()
//    }
//}
