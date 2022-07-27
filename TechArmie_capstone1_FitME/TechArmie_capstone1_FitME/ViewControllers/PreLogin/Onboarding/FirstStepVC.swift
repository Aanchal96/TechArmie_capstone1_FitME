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
    
    var profileModel = ProfileModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
    }
    
    @IBAction func goToNext(_ sender: Any) {
        let vc = SecondStepVC.instantiate(fromAppStoryboard: .Main)
        vc.profileModel = self.profileModel
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func goalOptionChanged(_ sender: UIButton) {
        setupButtonSelection(btn: sender)
        switch(sender){
        case btnLoseWeight:
            self.profileModel.goal = .loseWeight
            break
        case btnGainWeight:
            self.profileModel.goal = .gainWeight
            break
        case btnBeActive:
            self.profileModel.goal = .beActive
            break
        default:
            break
        }
    }
    
    @IBAction func back(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        
    }
}
extension FirstStepVC{
    
    func onViewDidLoad(){
        self.profileModel.goal = .loseWeight
    }
    
    func setupButtonSelection(btn: UIButton){
        btnLoseWeight.backgroundColor = CustomColors.secondaryColor
        btnGainWeight.backgroundColor = CustomColors.secondaryColor
        btnBeActive.backgroundColor = CustomColors.secondaryColor
    
        btnLoseWeight.tintColor = CustomColors.black
        btnGainWeight.tintColor = CustomColors.black
        btnBeActive.tintColor = CustomColors.black
    
        btn.backgroundColor = CustomColors.primaryColor
        btn.tintColor = CustomColors.white
    }
}
