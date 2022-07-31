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
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgFemale: UIImageView!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var imgMale: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtWeightGoal.addBottomBorder()
        txtWeight.addBottomBorder()
        txtHeight.addBottomBorder()
        txtAge.addBottomBorder()

        
        let maleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(maleImageTapped(tapGestureRecognizer:)))
        
        let femaleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(femaleImageTapped(tapGestureRecognizer:)))
        
        imgFemale.isUserInteractionEnabled = true
        imgFemale.addGestureRecognizer(femaleTapGestureRecognizer)
        
        imgMale.isUserInteractionEnabled = true
        imgMale.addGestureRecognizer(maleTapGestureRecognizer)
    }
    
    @objc func maleImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        imgMale.backgroundColor = CustomColors.primaryColor
        imgFemale.backgroundColor = CustomColors.secondaryColor
    }
    
    @objc func femaleImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        imgMale.backgroundColor = CustomColors.secondaryColor
        imgFemale.backgroundColor = CustomColors.primaryColor
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToNext(_ sender: Any) {
        let vc = ThirdStepVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
