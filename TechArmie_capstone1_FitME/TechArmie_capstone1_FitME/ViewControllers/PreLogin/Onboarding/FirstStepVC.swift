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
        performSegue(withIdentifier: "Step1TO2", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "Step1TO2"{
                    if let destination = segue.destination as? SecondStepVC{
                    _ = destination
                    }
                }
            }
    
    @IBAction func goalOptionChanged(_ sender: UIButton) {
        switch(sender){
        case btnLoseWeight:
            btnLoseWeight.backgroundColor = CustomColors.primaryColor
            btnGainWeight.backgroundColor = CustomColors.secondaryColor
            btnBeActive.backgroundColor = CustomColors.secondaryColor
            
            btnLoseWeight.tintColor = CustomColors.white
            btnGainWeight.tintColor = CustomColors.black
            btnBeActive.tintColor = CustomColors.black
            break
        case btnGainWeight:
            btnGainWeight.backgroundColor = CustomColors.primaryColor
            btnLoseWeight.backgroundColor = CustomColors.secondaryColor
            btnBeActive.backgroundColor = CustomColors.secondaryColor
            
            btnLoseWeight.tintColor = CustomColors.black
            btnGainWeight.tintColor = CustomColors.white
            btnBeActive.tintColor = CustomColors.black
            break
        case btnBeActive:
            btnBeActive.backgroundColor = CustomColors.primaryColor
            btnGainWeight.backgroundColor = CustomColors.secondaryColor
            btnLoseWeight.backgroundColor = CustomColors.secondaryColor
            
            btnLoseWeight.tintColor = CustomColors.black
            btnGainWeight.tintColor = CustomColors.black
            btnBeActive.tintColor = CustomColors.white
            break
        default:
            break
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
