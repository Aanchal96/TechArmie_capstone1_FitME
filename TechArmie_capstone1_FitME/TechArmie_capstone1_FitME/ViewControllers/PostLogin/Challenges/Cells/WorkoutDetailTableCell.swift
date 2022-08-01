

import UIKit

import SDWebImage

class WorkoutDetailTableCell: UITableViewCell {

    //MARK::- OUTLETS
    @IBOutlet weak var imgExercise: UIImageView!
    @IBOutlet weak var lblExerciseName: UILabel!
    @IBOutlet weak var lblRepCount: UILabel!
    @IBOutlet weak var lblRestTime: UILabel!
    @IBOutlet weak var imgShuffle: UIImageView!
    
    //MARK::- CELL CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK::- FUNCTION
    func configureCell(data : ExerciseModel?){
        lblExerciseName.text  = data?.exerciseName ?? ""
        lblRepCount.text = (data?.exeDuration.description ?? "") + (data?.exerciseType == 1 ? " Reps" : (" " + "Seconds") )
        lblRestTime.text = "Rest" + " " + (data?.restDuration.description ?? "")  + " " + "Seconds"
        imgExercise.sd_setImage(with: URL.init(string: data?.medias.first?.mediaUrlThumb1 ?? "") )
        if (data?.restDuration.description ?? "") == "1"{
            lblRestTime.text = "Rest" + " " + (data?.restDuration.description ?? "")  + " " + "Seconds"

        }

    }
}


