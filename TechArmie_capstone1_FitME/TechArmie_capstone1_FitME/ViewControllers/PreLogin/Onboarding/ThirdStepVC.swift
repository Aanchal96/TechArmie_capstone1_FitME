//
//  ThirdStepVC.swift
//  TechArmie_capstone1_FitME
//
//  Created by Vir Davinder Singh on 2022-07-22.
//

import Foundation
import UIKit
class ThirdStepVC : UIViewController
{
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSedentery: UIButton!
    @IBOutlet weak var btnLightActive: UIButton!
    @IBOutlet weak var btnModeratlyActive: UIButton!
    @IBOutlet weak var btnVeryActive: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func goToNext(_ sender: Any) {
        performSegue(withIdentifier: "Step3TO4", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "Step3TO4"{
                    if let destination = segue.destination as? FourthStepVC{
                    _ = destination
                    }
                }
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
        
//        switch(sender){
//        case btnSedentery:
//
//            break
//        case btnLightActive:
//
//            break
//        case btnModeratlyActive:
//            break
//        case btnVeryActive:
//            break
//        default:
//            break
//        }
    }
    
}
