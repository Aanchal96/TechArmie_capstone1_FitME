

import UIKit

import SwiftyJSON

class WorkoutSubmitVC: BaseVC {
    
    //MARK::- OUTLETS
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var btnEasy: UIButton!
    @IBOutlet weak var btnGood: UIButton!
    @IBOutlet weak var btnTooHard: UIButton!
    @IBOutlet weak var lblEasy: UILabel!
    @IBOutlet weak var lblGood: UILabel!
    @IBOutlet weak var lblHard: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblGreatJob: UILabel!
    @IBOutlet weak var lblHowAreYouFeelingText: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCalories: UILabel!
    @IBOutlet weak var lblExercises: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var caloriesLbl: UILabel!
    @IBOutlet weak var exerciseLbl: UILabel!
    
    
    //MARK::- PROPERTIES
    enum WorkoutDifficulty : Int {
        case easy = 1
        case good = 2
        case hard = 3
    }
    var workoutDifficulty : WorkoutDifficulty = .easy
    var workoutData : WorkoutModel?
    var programModel : ProgramModel?
    var isWorkoutCompleted = 0
    var totalTimeForWorkoutInMin = "0"
    var isFromChallenge = false
    var challengeData : Challenge?
    var totalTimeInSec = 0
    var burntCalories = 0
    
    //MARK::- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedString()
        lblCalories.text = (workoutData?.calories ?? 0).description
        lblExercises.text = (workoutData?.noOfExecises ?? 0).description
        lblTime.text = totalTimeForWorkoutInMin
        onViewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    //MARK::- BUTTON ACTION
    @IBAction func btnActionSubmit(_ sender: Any) {
        saveData()
    }
    @IBAction func btnActionEasy(_ sender: Any) {
        workoutDifficulty = .easy
        setupBtnSelection(btn: btnEasy, title: lblEasy)
    }
    @IBAction func btnActionGood(_ sender: Any) {
        workoutDifficulty = .good
        setupBtnSelection(btn: btnGood, title: lblGood)
    }
    @IBAction func btnActionHard(_ sender: Any) {
        workoutDifficulty = .hard
        setupBtnSelection(btn: btnTooHard, title: lblHard)
    }
    @IBAction func btnActionBack(_ sender: UIButton) {
        goBack()
    }
}

//MARK::- FUNCTIONS
extension WorkoutSubmitVC{
    private func setLocalizedString(){
        timeLbl.text = "Time"
        caloriesLbl.text = "Calories"
        exerciseLbl.text = "Exercises"
        lblHowAreYouFeelingText.text = "How are you feeling about the workout?"
        continueButton.setTitle("Save and Continue", for: .normal)
    }
    
    func onViewDidLoad(){
        AudioController.shared.deInitializeAudioPlayer()
        setupBtnSelection(btn: btnEasy, title: lblEasy)
    }

    func setupBtnSelection(btn : UIButton, title: UILabel){
        for item in [btnEasy, btnGood, btnTooHard]{
            if item == btn {
                item?.backgroundColor = AppColors.themePrimaryColor
            }else{
                item?.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
            }
        }
        for item in [lblEasy, lblGood, lblHard] {
            if item == title {
                item?.textColor = UIColor.white
            }else{
                item?.textColor = UIColor.black
            }
        }
    }
}

//MARK::- API
extension WorkoutSubmitVC{
    func saveData(){
        if isFromChallenge{
            var oldVal = AppUserDefaults.value(forKey: .currentChallengeDay).int ?? 1
            let oldJoinedChallenge = AppUserDefaults.value(forKey: .currentChallengeID).stringValue
            if oldJoinedChallenge != challengeData?.id ?? "" {
                oldVal = 1
            }
            let newVal = oldVal + 1
            AppUserDefaults.save(value: newVal, forKey: .currentChallengeDay)
            AppUserDefaults.save(value: challengeData?.id ?? "", forKey: .currentChallengeID)
        }else{
            let oldCurrentWorkoutDay = AppUserDefaults.value(forKey: .currentWorkoutDay).int ?? 1
            let newWorkoutDay = oldCurrentWorkoutDay + 1
            AppUserDefaults.save(value: newWorkoutDay, forKey: .currentWorkoutDay)
        }
        goBack()
    }


    func goBack(){
        if isFromChallenge{
            for vc in self.navigationController?.viewControllers ?? []{
                if vc is ChallengeDetailVC{
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }else{
            self.navigationController?.popToRootViewController(animated: true)
            
        }
    }
}
