//
//  WorkoutCells.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 01/08/22.


import UIKit
import SDWebImage

enum TypesOfWorkoutCell {
    case completed
    case pending
    case locked
}

class WorkoutExerciseTableCell: UITableViewCell {

    //MARK: IBOUTLETS
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var workoutImageView: UIImageView!
    @IBOutlet weak var topRightImageView: UIImageView!
    @IBOutlet weak var labelsStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var caloriesImageView: UIStackView!
    @IBOutlet weak var calorieImageView: UIImageView!
    @IBOutlet weak var calorieLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func prepareCell(_ row: Int, _ model: WorkoutModel, type: TypesOfWorkoutCell) {
        
        if model.medias.first?.mediaUrl != "" {
            workoutImageView.sd_setImage(with: URL.init(string: (model.medias.first?.mediaUrl) ?? ""))
        }
        titleLabel.text = model.name
        detailLabel.text = model.workoutSubtitle
        timeLabel.text = "\(model.duration) " + " min"
        calorieLabel.text = "\(model.calories) " + " kcal"
        
        switch type {
        case .pending:
            topRightImageView.isHidden = true
            
        case .completed:
            topRightImageView.isHidden = false
            topRightImageView.image = UIImage(named: "icChallengeTick")
            
        case .locked:
            topRightImageView.isHidden = false
            topRightImageView.image = UIImage(named: "lock")
        }
    }
}
