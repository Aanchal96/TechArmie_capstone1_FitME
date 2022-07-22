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
extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width-35, height: 0.5)
        bottomLine.backgroundColor = UIColor.black.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
