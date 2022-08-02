

import UIKit

protocol RestDelegate :AnyObject {
    func gotoNext(index : Int)
}

class RestCell: UITableViewCell {
    
    //MARK::- OUTLETS
    @IBOutlet weak var viewTitleAndTime: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var imgUpArrow: UIImageView!
    @IBOutlet weak var restTime: UILabel!
    @IBOutlet weak var skipRest: UIButton!
    
    //MARK::- PROPERTIES
    var timerVal = 0
    var index = 0
    weak var delegate : RestDelegate?
    var timer : Timer?
    
    //MARK::- CELL CYCLE
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalizedString()
        self.imgUpArrow.stopAnimating()
        viewTitleAndTime.alpha = 1
        lblTimer.alpha = 0
        timer?.invalidate()

    }
    
    private func setLocalizedString(){
        restTime.text = "REST TIME"
        skipRest.setTitle("SKIP REST", for: .normal)
    }
    
 
    
    //MARK::- CONFIGURE CELL
    func configure(data : ExerciseModel?){
        viewTitleAndTime.alpha = 1
        lblTimer.alpha = 0
        timer?.invalidate()
        self.timerVal = data?.restDuration ?? 0
        self.updateLabels()
    }
    
    ///MARK::- FUNCTIONS
    
  
    func cellDisplayed(index  : Int){
        self.index = index
        //CommonFunctions.speak(val: "Rest".localized)
        AudioController.shared.playAudioFromPath(name:  AudioName.rest)
        imgUpArrow.springAnnimate()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
            self?.timerVal = (self?.timerVal ?? 0) - 1
            self?.updateLabels()
            if (self?.timerVal ?? 0) == 3{
               // AudioController.shared.playAudioFromPath(name:AudioName.go)
            }
        })
    }
    
    func gotoNext(){
        delegate?.gotoNext(index: self.index)
    }
    func updateLabels(){
        let time = self.timerVal
        let min = time / 60
        let sec = time % 60
        if self.timerVal == 0{
//            self.lblTime.text = "0:00"
//            self.lblTimer.text = "0:00"
            self.lblTime.text = "0"
                     self.lblTimer.text = "0"
            self.gotoNext()
            self.timer?.invalidate()
        }else{
            self.lblTime.text = sec.description.count == 1 ? min.description + ":0" + sec.description   : (min.description + ":" + sec.description)
            self.lblTimer.text = sec.description.count == 1 ? min.description + ":0" + sec.description   : (min.description + ":" + sec.description)
            self.lblTime.text = self.timerVal.description
            self.lblTimer.text = self.timerVal.description

        }
    }
}
