//
//  ViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Vir Davinder Singh on 2022-08-04.
//

import Foundation
import UIKit
class ViewController : BaseVC {
    
    
    //MARK::- OUTLETS
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewCancelSubscription: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblAccountType: UILabel!
    @IBOutlet weak var lblNextRenew: UILabel!
    @IBOutlet weak var lblCancelSubscription: UILabel!
    @IBOutlet weak var lblPro: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var subscriptionInfoLbl: UILabel!
    @IBOutlet weak var byContinueLbl: UILabel!
    
    
    //MARK::- PROPERTIES
    
    //MARK::- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // onViewDidLoad()
    }
    //MARK::- BUTTON ACTIONS
    @IBAction func btnActionBack(_ sender: Any) {
        self.dismissVC(completion: nil)
    }
    
    
    
    
}
