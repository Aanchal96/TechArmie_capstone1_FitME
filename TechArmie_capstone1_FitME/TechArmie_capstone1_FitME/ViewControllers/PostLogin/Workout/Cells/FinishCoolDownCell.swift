//
//  WorkoutHomeVC.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal
//

import UIKit

class FinishCoolDownCell: UITableViewCell {

    @IBOutlet weak var btnFinishCoolDown: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalizedString()
    }

    private func setLocalizedString(){
        btnFinishCoolDown.setTitle("FINISH COOL DOWN", for: .normal)
    }
}
