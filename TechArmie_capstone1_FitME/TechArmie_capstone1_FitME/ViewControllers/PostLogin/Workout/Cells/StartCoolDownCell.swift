//
//  WorkoutHomeVC.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal
//

import UIKit

class StartCoolDownCell: UITableViewCell {

    //MARK:- OUTLETS
    @IBOutlet weak var btnSkipCoolDown: UIButton!
    @IBOutlet weak var btnFinishWarmUp: UIButton!
    @IBOutlet weak var lblReadyForCoolDown: UILabel!
    @IBOutlet weak var topConstantBtnFinish: NSLayoutConstraint!
    @IBOutlet weak var btnWarmupComplete: UIButton!
    @IBOutlet weak var imgTickFinished: UIImageView!
    @IBOutlet weak var imgArrowUp: UIImageView!
    @IBOutlet weak var swipBtn: UIButton!
    
    
    ///MARK::- CELL CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        imgArrowUp.stopAnimating()
        setText()
        btnWarmupComplete.titleLabel?.textAlignment = NSTextAlignment.center
    }

    //MARK::- FINISHED
    func cellDisplayed(index : Int){
        setText()
        imgArrowUp.springAnnimate()
    }
    
    private func setText(){
        
        btnWarmupComplete.setTitle("Workout Complete", for: .normal)
        btnFinishWarmUp.setTitle("Finish Workout", for: .normal)
        swipBtn.setTitle("SWIPE UP TO START", for: .normal)
        lblReadyForCoolDown.text = "Let’s get your muscles Cool down!"
    }
}
