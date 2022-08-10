//
//  ViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Vir Davinder Singh on 2022-08-04.
//

import Foundation
import UIKit
import StoreKit
import FirebaseAuth
import FirebaseFirestore

enum FromVC{
    case WorkoutVC, ChallengeVC, ExerciseLibraryVC
}

class SubscriptionViewController : BaseVC {
     
    var iapProducts = [SKProduct]()
    var iapProductIdentifiers:Set<String>! = ["com.techArmie.fitME.app.monthlysubscription"]
    let sharedSecret = "0fe25e333d874cffa4e09e8059a7c311"
    
    var fromVC: FromVC = .WorkoutVC
    
    let purchaseCompletionBlock:((_ purchasedPID:Set<String>,_ restoredPID:Set<String>,_ failedPID:Set<String>)->Void) = {
        (purchasedPID,restoredPID,failedPID) in
        printDebug("purchasedPID \(purchasedPID)")
        printDebug("restoredPID \(restoredPID)")
        printDebug("failedPID \(failedPID)")
        
    }
    
    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var btnGoPremium: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        addTapsOnView()
        
        switch fromVC {
        case .WorkoutVC:
            self.btnBack.isHidden = false
        case .ChallengeVC:
            self.btnBack.isHidden = true
        case .ExerciseLibraryVC:
            self.btnBack.isHidden = true
        }
        
        setupIAP()
      }
    
    @objc func btnBackTap(tapGestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    @IBAction func goForPremium(_ sender: Any) {
        if let product = iapProducts.first{
            CommonFunctions.showActivityLoader()
            IAPController.shared.purchaseProduct(product: product) { [weak self] (purchaseId, restoreId, failureId) in
                CommonFunctions.hideActivityLoader()
                guard let strongSelf = self else {return}
                strongSelf.purchaseCompletionBlock(purchaseId, restoreId, failureId)
                if purchaseId.count > 0 {
                    
                    AppUserDefaults.save(value: true, forKey: .isPremium)
                    self?.dismiss(animated: true)
                    
                    strongSelf.getAppReceipt(willSuccessToastVisible: true)
                    
                }else if failureId.count > 0{
                    CommonFunctions.showToastWithMessage(LocalizedString.somethingWentWrong.localized, completion: nil)
                }
            }
        }
    }
    
    func setupIAP(){
        if !iapProducts.isEmpty{
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = iapProducts.first?.priceLocale
            let price1Str = numberFormatter.string(from: iapProducts.first?.price ?? 0)
            DispatchQueue.main.async {
                [weak self] in
                    guard let self = self else {return}
                self.btnGoPremium.setTitle("Pay " + (price1Str ?? "$9.99" + " /m"), for: .normal)
   
            }

            return
        }
        
        IAPController.shared.fetchAvailableProducts(productIdentifiers: iapProductIdentifiers, success: { [weak self] (products) in
            CommonFunctions.hideActivityLoader()
            
            guard let self = self else {return}
            
            self.iapProducts = products

            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = .current//self.iapProducts.first?.priceLocale
            let price1Str = numberFormatter.string(from: self.iapProducts.first?.price ?? 0)
           
            DispatchQueue.main.async {
                [weak self] in
                    guard let self = self else {return}
                self.btnGoPremium.setTitle("Pay " + (price1Str ?? "$9.99" + " /m"), for: .normal)
   
            }
            }, failure: {
                [weak self] (error) in
                CommonFunctions.hideActivityLoader()
                CommonFunctions.showToastWithMessage(error?.localizedDescription ?? "", completion: {
                    self?.setupIAP()
                })
        })
    }
    
    func getAppReceipt(willSuccessToastVisible: Bool, isFromRestorePurchase: Bool = false, rID : String = ""){
        IAPController.shared.fetchIAPReceipt(forceRefresh: false, sharedSecrete: sharedSecret, success: { [weak self] (receipt , receiptToken) in
            
            // Send at backend
            guard let user = Auth.auth().currentUser else {  return }
            let db = Firestore.firestore().collection("users");
            let firebaseUser = db.document(user.uid)
            firebaseUser.setData([ "is_premium": true ], merge: true);
            let authUser = AuthUser(AppUserDefaults.value(forKey: .fullUserProfile));
            authUser.isPremium = true;
            authUser.saveToUserDefaults()
            
//            guard let strongSelf = self else {return}
//            let morningDate =   Calendar.current.startOfDay(for: Date())
//            let reqMilliSecond = Int64(morningDate.timeIntervalSince1970 * 1000)
//            var dictToSend : JSONDictionary = [:]
//            dictToSend = ["receiptToken" : receiptToken , "productId" : "com.techArmie.fitME.app.monthlysubscription" , "currency" : (iapProducts.first?.priceLocale.currencyCode ?? "") ,"subscriptionPrice" : (iapProducts.first?.price ?? 0) , "subscriptionType" : 1 , "action" : "subscription" , "startDate" : reqMilliSecond.description]
            
//            self?.dictToSend = dictToSend
//            strongSelf.updateSubscription(willSuccessToastVisible: willSuccessToastVisible)
        }) {  (error) in
            if let e = error{
                CommonFunctions.showToastWithMessage(e.localizedDescription, completion: nil)
            }
        }
    }
}

extension SubscriptionViewController{
    func addTapsOnView(){
        let btnBackTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btnBackTap(tapGestureRecognizer:)))
        
        btnBack.isUserInteractionEnabled = true
        btnBack.addGestureRecognizer(btnBackTapGestureRecognizer)
    }
}

    
    

