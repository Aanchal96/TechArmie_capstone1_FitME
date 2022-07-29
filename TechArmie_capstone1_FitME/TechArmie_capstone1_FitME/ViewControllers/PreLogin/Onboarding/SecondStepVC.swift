//
//  SecondStepVC.swift
//  TechArmie_capstone1_FitME
//
//  Created by Vir Davinder Singh on 2022-07-22.
//


import Foundation
import UIKit
class SecondStepVC : UIViewController
{
    
    
    @IBOutlet weak var txtWeightGoal: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtAge: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtWeightGoal.addBottomBorder()
        txtWeight.addBottomBorder()
        txtHeight.addBottomBorder()
        txtAge.addBottomBorder()
    }
}
