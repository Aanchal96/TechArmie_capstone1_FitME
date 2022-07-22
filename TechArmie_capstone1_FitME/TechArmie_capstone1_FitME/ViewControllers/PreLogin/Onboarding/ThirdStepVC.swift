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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
