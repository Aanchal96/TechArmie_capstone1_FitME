//
//  ExerciseLibraryCells.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 31/07/22.
//

import UIKit
import IBAnimatable

class ExerciseLibraryCell: UITableViewCell {
    
    //MARK::- OUTLETS
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgExercise: AnimatableImageView!
    @IBOutlet weak var lblExerciseType: UILabel!
    
    //MARK:: CELL CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class ExerciseCategoryCollectionCell : UICollectionViewCell{
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var btnTitle: AnimatableButton?
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var imgIcon: UIImageView?
    
    var isSelect : Bool?{
        didSet{
            lblTitle?.textColor = (isSelect ?? true) ? UIColor.red  : UIColor.black
        }
    }
    
    override func awakeFromNib() {
    
    }
    
}
