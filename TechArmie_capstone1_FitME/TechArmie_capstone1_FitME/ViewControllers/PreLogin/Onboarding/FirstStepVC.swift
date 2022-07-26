//
//  FirstStepVC.swift
//  TechArmie_capstone1_FitME
//
//  Created by Bhautik Pethani on 2022-07-22.
//

import UIKit

class FirstStepVC: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnLoseWeight: UIButton!
    @IBOutlet weak var btnGainWeight: UIButton!
    @IBOutlet weak var btnBeActive: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goToNext(_ sender: Any) {
        let vc = SecondStepVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goalOptionChanged(_ sender: UIButton) {
        
        btnLoseWeight.backgroundColor = CustomColors.secondaryColor
        btnGainWeight.backgroundColor = CustomColors.secondaryColor
        btnBeActive.backgroundColor = CustomColors.secondaryColor
    
        btnLoseWeight.tintColor = CustomColors.black
        btnGainWeight.tintColor = CustomColors.black
        btnBeActive.tintColor = CustomColors.black
    
        sender.backgroundColor = CustomColors.primaryColor
        sender.tintColor = CustomColors.white
        switch(sender){
        case btnLoseWeight:
            break
        case btnGainWeight:
            break
        case btnBeActive:
            break
        default:
            break
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
