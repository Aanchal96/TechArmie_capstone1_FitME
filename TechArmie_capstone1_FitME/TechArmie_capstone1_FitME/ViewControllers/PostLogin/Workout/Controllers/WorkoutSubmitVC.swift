//
//  WorkoutSubmitVC.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal
//

import UIKit
import SwiftyJSON

class WorkoutSubmitVC: BaseVC {
    
    //MARK::- OUTLETS
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblGreatJob: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCalories: UILabel!
    @IBOutlet weak var lblExercises: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var caloriesLbl: UILabel!
    @IBOutlet weak var exerciseLbl: UILabel!
    
    //MARK::- PROPERTIES
    var workoutData : WorkoutModel?
    var programModel : ProgramModel?
    
    var totalTimeForWorkoutInMin = "0"
    var isFromChallenge = false
    var challengeData : Challenge?
    
    var isWorkoutCompleted = 0
    var totalTimeInSec = 0
    var burntCalories = 0
    
    //MARK::- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStrings()
        
        lblCalories.text = (workoutData?.calories ?? 0).description
        lblExercises.text = (workoutData?.noOfExecises ?? 0).description
        lblTime.text = totalTimeForWorkoutInMin
        
        onViewDidLoad()
    }

    //MARK::- BUTTON ACTION
    @IBAction func btnActionSubmit(_ sender: Any) {
        saveData()
    }

    @IBAction func btnActionBack(_ sender: UIButton) {
        goBack()
    }
}

//MARK::- FUNCTIONS
extension WorkoutSubmitVC{
    
    private func setStrings(){
        timeLbl.text = "Time"
        caloriesLbl.text = "Calories"
        exerciseLbl.text = "Exercises"
        continueButton.setTitle("Save and Continue", for: .normal)
    }
    
    func onViewDidLoad(){
        // Deinitialise previous audios from Workout player
        AudioController.shared.deInitializeAudioPlayer()
    }

}

//MARK::- API
extension WorkoutSubmitVC{
    
    func saveData(){
        if isFromChallenge{
            
            // To save challenge id and cuurent day
            var oldVal = AppUserDefaults.value(forKey: .currentChallengeDay).int ?? 1
            let oldJoinedChallenge = AppUserDefaults.value(forKey: .currentChallengeID).stringValue
            if oldJoinedChallenge != challengeData?.id ?? "" {
                oldVal = 1
            }
            let newVal = oldVal + 1
            AppUserDefaults.save(value: newVal, forKey: .currentChallengeDay)
            AppUserDefaults.save(value: challengeData?.id ?? "", forKey: .currentChallengeID)
            
        }else{
            
            // Increment current day by 1
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
