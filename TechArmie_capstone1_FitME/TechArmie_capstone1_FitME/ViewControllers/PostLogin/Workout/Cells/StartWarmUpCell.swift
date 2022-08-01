

import UIKit

class StartWarmUpCell: UITableViewCell {
    
    //MARK::- OUTLTS
    @IBOutlet weak var btnSkipWarmUp: UIButton!
    @IBOutlet weak var imgArrowUp: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var swipeBtn: UIButton!
    
    //MARK::- FUNCTIONS
    override func awakeFromNib() {
        super.awakeFromNib()
        imgArrowUp.stopAnimating()
        titleLbl.text = "Let’s get your muscles warmed up!"
        swipeBtn.setTitle("SWIPE UP TO START", for: .normal)
    }
    
    func cellDisplayed(){
        titleLbl.text = "Let’s get your muscles warmed up!"
        swipeBtn.setTitle("SWIPE UP TO START", for: .normal)
        imgArrowUp.springAnnimate()
    }
}
