//
//  FourthStepVC.swift
//  TechArmie_capstone1_FitME
//
//  Created by Vir Davinder Singh on 2022-07-22.
//

import Foundation
import UIKit
class FourthStepVC : UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func goToNext(_ sender: Any) {
        performSegue(withIdentifier: "Step4TO5", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "Step4TO5"{
                    if let destination = segue.destination as? FifthStepVC{
                    _ = destination
                    }
                }
            }
}

