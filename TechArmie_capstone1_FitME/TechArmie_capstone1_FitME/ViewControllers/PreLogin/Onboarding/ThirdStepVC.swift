//
//  ThirdStepVC.swift
//  TechArmie_capstone1_FitME
//
//  Created by Vir Davinder Singh on 2022-07-22.
//

import Foundation
import UIKit

class ThirdStepVC : BaseVC{
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSedentery: UIButton!
    @IBOutlet weak var btnLightActive: UIButton!
    @IBOutlet weak var btnModeratlyActive: UIButton!
    @IBOutlet weak var btnVeryActive: UIButton!
    
    var profileModel = ProfileModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        debugPrint(profileModel.heightDict ?? "Height NULL")
//        debugPrint(profileModel.weightDict ?? "Weight Null")
//        debugPrint(profileModel.weightGoalDict ?? "Weight Goal Null")
//        debugPrint(profileModel.age)
        
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func goToNext(_ sender: Any) {
        let vc = FourthStepVC.instantiate(fromAppStoryboard: .Main)
        vc.profileModel = profileModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func activityLevelsPressed(_ sender: UIButton)
    {
        btnSedentery.backgroundColor = CustomColors.secondaryColor
        btnSedentery.tintColor = CustomColors.black
        
        btnLightActive.backgroundColor = CustomColors.secondaryColor
        btnLightActive.tintColor = CustomColors.black
        
        btnModeratlyActive.backgroundColor = CustomColors.secondaryColor
        btnModeratlyActive.tintColor = CustomColors.black
        
        btnVeryActive.backgroundColor = CustomColors.secondaryColor
        btnVeryActive.tintColor = CustomColors.black
        
        sender.backgroundColor = CustomColors.primaryColor
        sender.tintColor = CustomColors.white
        
        switch(sender){
        case btnSedentery:
            profileModel.level = .beginner
            break
        case btnLightActive:
            profileModel.level = .novice
            break
        case btnModeratlyActive:
            profileModel.level = .intermediate
            break
        case btnVeryActive:
            profileModel.level = .advance
            break
        default:
            break
        }
    }
    
}
