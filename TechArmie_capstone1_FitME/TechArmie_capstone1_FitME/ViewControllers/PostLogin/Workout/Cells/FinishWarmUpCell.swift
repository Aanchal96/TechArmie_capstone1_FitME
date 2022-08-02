
import UIKit


class FinishWarmUpCell: UITableViewCell {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var btnFinishWarmUp: UIButton!
    @IBOutlet weak var lblReadyForWorkout: UILabel!
    @IBOutlet weak var topConstantBtnFinish: NSLayoutConstraint!
    @IBOutlet weak var btnWarmupComplete: UIButton!
    @IBOutlet weak var imgTickFinished: UIImageView!
    @IBOutlet weak var imgUpArrow: UIImageView!
    @IBOutlet weak var swipeBtn: UIButton!
    

    //MARK::- CELL CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        btnFinishWarmUp.setTitle("Finish Warm-up", for: .normal)
        imgUpArrow.stopAnimating()
        lblReadyForWorkout.text = "Ready for the workout?"
        swipeBtn.setTitle("SWIPE UP TO START", for: .normal)
        btnWarmupComplete.setTitle("Warm-up completed", for: .normal)
    }
    
    //MARK::- FUNCTIONS
    func cellDisplayed(index : Int){
        btnWarmupComplete.setTitle("Warm-up completed", for: .normal)
        btnFinishWarmUp.setTitle("Finish Warm-up", for: .normal)
        swipeBtn.setTitle("SWIPE UP TO START", for: .normal)
        lblReadyForWorkout.text = "Ready for the workout?"
        imgUpArrow.springAnnimate()

    }
}
