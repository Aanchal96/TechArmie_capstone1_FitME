//
//  WorkoutHomeVC.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 01/08/22.
//

import UIKit
import SwiftyJSON

enum ProgramLevelType: Int {
    case beginner = 0
    case novice = 1
    case intermediate = 2
    case advanced = 3
    
    func getImageName() -> String {
        switch self {
        case .beginner:
           return "Beginner"
        case .novice:
           return "Novice"
        case .intermediate:
           return "Intermediate"
        case .advanced:
           return "Advanced"
        }
    }
}

class WorkoutHomeVC: BaseVC {
    
    //MARK: - PROPERTIES
    var selectedWeek : Int = 0
    var arrWorkout: [WorkoutModel] = []
    var currentWorkoutDay = 1 // max 5*4 = 20
    var currentAssignedLevel: ProgramLevelType = .beginner //TODO: set this value from UserModel or Login
    var assignedProgram: ProgramModel?
    
    //MARK: - OUTLETS
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var weeksBackView: UIView!
    @IBOutlet weak var weeksStackView: UIStackView!
    @IBOutlet weak var weekOneBtn: UIButton!
    @IBOutlet weak var weekTwoBtn: UIButton!
    @IBOutlet weak var weekThreeBtn: UIButton!
    @IBOutlet weak var weekFourBtn: UIButton!
    @IBOutlet weak var workoutTableView: UITableView!
    @IBOutlet weak var weeksSlidingView: UIView!
    @IBOutlet weak var constraintSlider: NSLayoutConstraint!
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialSetup()
    }

    //MARK: - BUTTON ACTION
    @IBAction func weekOneBtnTapped(_ sender: UIButton) {
        selectedWeek = 0
        constraintSlider.constant = 0
        weekBtnTapped(sender)
    }
    
    @IBAction func weekTwoButtonTapped(_ sender: UIButton) {
        selectedWeek = 1
        constraintSlider.constant = sender.width
        weekBtnTapped(sender)
    }
    
    @IBAction func weekThreeBtnTapped(_ sender: UIButton) {
        selectedWeek = 2
        constraintSlider.constant = (2*sender.width)
        weekBtnTapped(sender)
    }
    
    @IBAction func weekFourBtnTapped(_ sender: UIButton) {
        selectedWeek = 3
        constraintSlider.constant = (3*sender.width)
        weekBtnTapped(sender)
    }
    
    func weekBtnTapped(_ sender: UIButton, isInitial: Bool = false){
        weekOneBtn.isSelected = false
        weekTwoBtn.isSelected = false
        weekThreeBtn.isSelected = false
        weekFourBtn.isSelected = false
        workoutTableView.reloadData()
        sender.isSelected = true
        updateHeader()
    }
    
}

// MARK:- TABLE VIEW DELEGATE & DATASOURCE
extension WorkoutHomeVC : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrWorkout.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueCell(with: WorkoutExerciseTableCell.self)
        let row = indexPath.row
        let currentWorkoutNumber = row + (selectedWeek * arrWorkout.count)
        if currentWorkoutNumber == currentWorkoutDay - 1 {
            cell.prepareCell(row, arrWorkout[row], type: .pending)
        } else if currentWorkoutNumber < currentWorkoutDay - 1 {
            cell.prepareCell(row, arrWorkout[row], type: .completed)
        } else {
            cell.prepareCell(row, arrWorkout[row], type: .locked)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let currentWorkoutNumber = row + (selectedWeek * arrWorkout.count)
        if currentWorkoutNumber == currentWorkoutDay - 1 {
            let vc = WorkoutDetailVC.instantiate(fromAppStoryboard: .Challenges)
            vc.isFromChallenge = false
            vc.challengeData = Challenge(self.arrWorkout[indexPath.row].json)
            vc.workoutData = self.arrWorkout[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            return
        }
    }
}

// MARK: - Functions
extension WorkoutHomeVC {
    private func initialSetup() {
        self.currentWorkoutDay = AppUserDefaults.value(forKey: .currentWorkoutDay).int ?? 1
        if self.currentWorkoutDay > 20 {
            self.currentWorkoutDay = 1
            AppUserDefaults.removeValue(forKey: .currentWorkoutDay)
        }
        self.workoutTableView.isHidden = true
        self.headerView.isHidden = true
        workoutTableView.delegate = self
        workoutTableView.dataSource = self
        fetchDataFromJSON()
    }

    private func fetchDataFromJSON() {
        var json = JSON()
        if let path = Bundle.main.path(forResource: "Workout", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObject =  try JSONSerialization.jsonObject(with: data , options: JSONSerialization.ReadingOptions.mutableContainers)
                if let jsonDict = jsonObject as? [String: AnyObject] {
                    json = JSON(jsonDict)
                    let arrProgramLevels = json[ApiKey.result][ApiKey.data].arrayValue.map({ProgramModel($0)})
                    self.assignedProgram = arrProgramLevels[currentAssignedLevel.rawValue]
                    self.arrWorkout = self.assignedProgram?.pendingWorkouts ?? []
                    let pendingWorkoutArray = json[ApiKey.result][ApiKey.pendingWorkout].arrayValue
                    let pendingWorkouts = pendingWorkoutArray.map({WorkoutModel($0)})
                    self.assignedProgram?.pendingWorkouts = pendingWorkouts
                    self.arrWorkout = pendingWorkouts
                    self.workoutTableView.reloadData()
                    self.updateHeader()
                }
            } catch {
                printDebug("error")
            }
        }
    }
    
    private  func updateHeader(){
        let progressDonePercentage = ((currentWorkoutDay - 1) * 100)/20
        self.levelLabel.text = self.assignedProgram?.levelName ?? ""
        self.percentageLabel.text = "\(progressDonePercentage)" + " percent Completed"
        self.progressView.progress = Float(progressDonePercentage) / 100.0
        self.workoutTableView.isHidden = false
        self.headerView.isHidden = false
        let headerImage = self.currentAssignedLevel.getImageName() + (selectedWeek == 0 ? "" : selectedWeek.description) + ".jpg"
        self.headerImageView.image = UIImage.init(named: headerImage)

    }
}
