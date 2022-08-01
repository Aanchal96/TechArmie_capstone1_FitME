//
//  WorkoutVC.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal
//

import UIKit

enum ExerciseType : Int{
    case warmUp
    case normal
    case coolDown
}

class WorkoutVC: UIViewController {
    
    //MARK::- OUTLET
    @IBOutlet weak var lblHeaderTime: UILabel!
    @IBOutlet weak var progressDone: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var btnMute: UIButton!
    
    //MARK::- PROPERTIES
    var challengeData : Challenge?
    var isFromChallenge = false
    
    var lastContentOffset: CGFloat = 0 // Add offset as cell is scrolled down
    var cellIndexAtTop = 0 // Cell currently visible on screen
    
    var workoutData : WorkoutModel?
    var programData : ProgramModel?
    var workoutArray : [ExerciseModel]? = []
    
    var timer : Timer?
    var totalTimeForWorkoutInSeconds = 0
    var initialTimeInSec = 0
    
    var warmUpExercideCount = 0
    var exerciseCount = 0
    var coolDownExerciseCount = 0
    
    var currentAvailableIndex = 0 //Next Cell in line - to prepare
    var currentDoneIndex = 0 // Previous cell that is just scrolled - to deinit
    
    var currentExerciseType = ExerciseType.warmUp
    var isWorkoutCompleted = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK::- LIFECYCLE
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Progress bars on Top to show exerc
        progressDone.transform = progressDone.transform.scaledBy(x: 1, y: 0.5)
        setLocalizedString()
        onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        AudioController.shared.unMuteAudio()
        AudioController.shared.deInitializeAudioPlayer()
    }
    
    //MARK::- BUTTON ACTIONS
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnActionMute(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            AudioController.shared.muteAudio()
        }else{
            AudioController.shared.unMuteAudio()
        }
    }
    
}
//MARK::- FUNCTIONS
extension WorkoutVC{
    
    private func setLocalizedString(){
        lblHeaderTitle.text = "COOL-DOWN"
        
    }
    
    func onViewDidLoad(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.addSwipeGesture(direction: .up) { [weak self] (gesture) in
            self?.topSwipe()
        }
        self.lblHeaderTime.text = formattedTime(val : initialTimeInSec)
        self.lblHeaderTitle.text = "WARM-UP"
        //self.lblHeaderTitle.isHidden = true//false
        self.lblHeaderTitle.isHidden = false
        
        self.progressDone.setProgress( 0 , animated: false)
        
        //Background notifications
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForegroundNotification),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appWillEnterForegroundNotification() {
        guard let cellCentre = self.tableView.cellForRow(at: IndexPath.init(row: (self.cellIndexAtTop  ), section: 0)) as? WorkoutCell  else {return}
        cellCentre.videoView?.play()
    }
    
}

//MARK: Timer Functions
extension WorkoutVC{
    
    func formattedTime(val : Int) -> String{
        let min = (val / 60).description
        let sec = (val % 60).description.count == 1 ? "0\((val % 60))" : (val % 60).description
        return min + ":" + sec
    }
    func restartTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
            self?.initialTimeInSec = (self?.initialTimeInSec ?? 0) + 1
            self?.lblHeaderTime.text = self?.formattedTime(val : self?.initialTimeInSec ?? 0)
        })
    }
    func resetHeaderTime(isZero:Bool = false){
        self.progressDone.setProgress(isZero ? 0 : 1, animated: false)
        self.currentAvailableIndex = 0
        self.currentDoneIndex = 0
    }
}

//MARK::- TABLE VIEW DELEGATE AND DATASOURCE
extension WorkoutVC : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workoutArray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.size.height - 128
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.size.height - 128
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        printDebug(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printDebug(indexPath.row)
        if self.workoutArray?[indexPath.row].flag == 5{
            guard let cellToHide = self.tableView.cellForRow(at: IndexPath.init(row: (indexPath.row - 1), section: 0)) else {return}
            (cellToHide as? WorkoutCell)?.videoView?.stop()
            (cellToHide as? WorkoutCell)?.videoView?.invalidate()
            (cellToHide as? WorkoutCell)?.mainImageView.isHidden = false
            (cellToHide as? WorkoutCell)?.videoView = nil
            
            gotoFinishScreen()
            return
        }else if self.workoutArray?[indexPath.row].flag == 3 || self.workoutArray?[indexPath.row].flag == 4{
            DispatchQueue.main.async { [weak self] in
                self?.topSwipe()
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //flag = 0 exercise , 1 rest , 2 warmup start, 3 warmupEnd , 4 cool down start , 5 cool down finish
        
        switch self.workoutArray?[indexPath.row].flag{
        case 2:
            guard let cellStartWarmUp = tableView.dequeueReusableCell(withIdentifier: StartWarmUpCell.className , for: indexPath) as? StartWarmUpCell else {return UITableViewCell()}
            cellStartWarmUp.cellDisplayed()
            return cellStartWarmUp
        case 0:
            guard let cellWorkout = tableView.dequeueReusableCell(withIdentifier: WorkoutCell.className , for: indexPath) as? WorkoutCell else {return UITableViewCell()}
            cellWorkout.delegate = self
            cellWorkout.configureCell(data : self.workoutArray?[indexPath.row])
            return cellWorkout
        case 1:
            guard let cellRest = tableView.dequeueReusableCell(withIdentifier: RestCell.className , for: indexPath) as? RestCell else {return UITableViewCell()}
            cellRest.delegate = self
            cellRest.configure(data : self.workoutArray?[indexPath.row])
            cellRest.lblTimer.alpha = 0
            return cellRest
        case 3:
            guard let cellFinishWarmUp = tableView.dequeueReusableCell(withIdentifier: FinishWarmUpCell.className , for: indexPath) as? FinishWarmUpCell else {return UITableViewCell()}
            return cellFinishWarmUp
        case 4:
            guard let cellStartCoolDown = tableView.dequeueReusableCell(withIdentifier: StartCoolDownCell.className , for: indexPath) as? StartCoolDownCell else {return UITableViewCell()}
            return cellStartCoolDown
        case 5:
            guard let FinishCoolDownCell = tableView.dequeueReusableCell(withIdentifier: FinishCoolDownCell.className , for: indexPath) as? FinishCoolDownCell else {return UITableViewCell()}
            return FinishCoolDownCell
        default:
            return UITableViewCell()
        }
    }
}

//MARK::- CELL DELEGATE
extension WorkoutVC : WorkoutComplete , RestDelegate {
    
    func topSwipe(){
        //if scrolled to last screen goto finish workout
        if self.cellIndexAtTop >= (self.workoutArray?.count ?? 0) - 2{
            guard let cellToHide = self.tableView.cellForRow(at: IndexPath.init(row: (self.cellIndexAtTop  ), section: 0)) else {return}
            (cellToHide as? WorkoutCell)?.videoView?.stop()
            (cellToHide as? WorkoutCell)?.videoView?.invalidate()
            (cellToHide as? WorkoutCell)?.mainImageView.isHidden = false
            (cellToHide as? WorkoutCell)?.videoView = nil
            (cellToHide as? WorkoutCell)?.timer?.invalidate()
            (cellToHide as? WorkoutCell)?.countDownTimer?.invalidate()
            (cellToHide as? WorkoutCell)?.timer = nil
            (cellToHide as? WorkoutCell)?.countDownTimer = nil
            (cellToHide as? WorkoutCell)?.isCurrentScreen = false
            gotoFinishScreen()
            return
        }
        self.cellIndexAtTop += 1
        self.lastContentOffset = self.lastContentOffset + (self.tableView.frame.size.height - 128)
        //top cell
        guard let cellToHide = self.tableView.cellForRow(at: IndexPath.init(row: (self.cellIndexAtTop - 1 ), section: 0)) else {return}
        //bottom cell
        guard let cellToShow = self.tableView.cellForRow(at: IndexPath.init(row: (self.cellIndexAtTop ), section: 0)) else {return}
        
        (cellToHide as? WorkoutCell)?.videoView?.pause()
        (cellToHide as? WorkoutCell)?.timer?.invalidate()
        (cellToHide as? WorkoutCell)?.countDownTimer?.invalidate()
        (cellToHide as? RestCell)?.timer?.invalidate()
        (cellToHide as? WorkoutCell)?.timer = nil
        (cellToHide as? WorkoutCell)?.countDownTimer = nil
        (cellToHide as? RestCell)?.timer = nil
        (cellToShow as? FinishWarmUpCell)?.imgTickFinished.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        (cellToShow as? StartCoolDownCell)?.imgTickFinished.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        (cellToShow as? RestCell)?.lblTimer.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self = self else {return}
            self.tableView.setContentOffset( CGPoint.init(x: 0, y: self.lastContentOffset ) , animated: false)
            (cellToHide as? WorkoutCell)?.greenView.alpha = 0.8
            (cellToShow as? FinishWarmUpCell)?.lblReadyForWorkout.alpha = 1
            (cellToShow as? FinishWarmUpCell)?.btnFinishWarmUp.alpha = 0
            (cellToShow as? FinishWarmUpCell)?.btnWarmupComplete.alpha = 1
            (cellToShow as? FinishWarmUpCell)?.imgTickFinished.alpha = 1
            (cellToShow as? FinishWarmUpCell)?.imgTickFinished.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            
            (cellToShow as? StartCoolDownCell)?.lblReadyForCoolDown.alpha = 1
            (cellToShow as? StartCoolDownCell)?.btnFinishWarmUp.alpha = 0
            (cellToShow as? StartCoolDownCell)?.btnWarmupComplete.alpha = 1
            (cellToShow as? StartCoolDownCell)?.imgTickFinished.alpha = 1
            (cellToShow as? StartCoolDownCell)?.imgTickFinished.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
            (cellToShow as? RestCell)?.viewTitleAndTime.alpha = 0
            (cellToShow as? RestCell)?.lblTimer.alpha = 1
            (cellToShow as? RestCell)?.lblTimer.transform = CGAffineTransform(scaleX: 1, y: 1)
            (cellToShow as? WorkoutCell)?.viewOverlay.alpha = 0
            self.view.layoutIfNeeded()
            
            
        }, completion: { [weak self] (val) in
            guard let self = self else {return}
            if val{
                (cellToHide as? WorkoutCell)?.videoView.stop()
                (cellToHide as? WorkoutCell)?.videoView.invalidate()
                (cellToShow as? WorkoutCell)?.cellDisplayed(index : self.cellIndexAtTop)
                //(cellToShow as? ExerciseWorkoutCell)?.cellDisplayed(index : self.cellIndexAtTop)
                (cellToShow as? RestCell)?.cellDisplayed(index : self.cellIndexAtTop)
                (cellToShow as? FinishWarmUpCell)?.cellDisplayed(index : self.cellIndexAtTop)
                (cellToShow as? StartCoolDownCell)?.cellDisplayed(index : self.cellIndexAtTop)
                
                //flag = 0 exercise , 1 rest , 2 warmup start, 3 warmupEnd , 4 cool down start , 5 cool down finish
                //managing top header according to current type of cell
                switch self.workoutArray?[self.cellIndexAtTop].flag{
                case 2:
                    self.resetHeaderTime(isZero : true)
                    self.lblHeaderTitle.text = "WARM-UP"
                    // self.lblHeaderTitle.isHidden = true//false
                    self.lblHeaderTitle.isHidden = false
                    
                    self.currentExerciseType = .warmUp
                case 3:
                    self.resetHeaderTime()
                    self.lblHeaderTitle.text = "WORKOUT"
                    //self.lblHeaderTitle.isHidden = true
                    self.lblHeaderTitle.isHidden = false
                    
                    self.currentExerciseType = .normal
                    
                case 4:
                    self.resetHeaderTime()
                    self.lblHeaderTitle.text = "COOL-DOWN"
                    // self.lblHeaderTitle.isHidden = true//false
                    self.lblHeaderTitle.isHidden = false
                    
                    self.currentExerciseType = .coolDown
                    
                default:
                    if self.initialTimeInSec == 0{
                        self.timer?.invalidate()
                        self.timer = nil
                        self.restartTimer()
                    }
                    printDebug(self.cellIndexAtTop)
                    if self.cellIndexAtTop >= (self.warmUpExercideCount + 2 ) && self.currentExerciseType == .normal{
                        if cellToShow is WorkoutCell{
                            self.currentAvailableIndex += 1
                        }else{
                            self.currentDoneIndex += 1
                        }
                        
                    }else{
                        self.currentAvailableIndex += 1
                        if self.currentAvailableIndex != 1 {
                            self.currentDoneIndex += 1}
                    }
                    
                    switch self.currentExerciseType{
                    case .warmUp:
                        self.progressDone.setProgress(Float(self.currentDoneIndex) / Float(self.warmUpExercideCount), animated: false)
                        
                    case .normal:
                        self.progressDone.setProgress(Float(self.currentDoneIndex) / Float((self.exerciseCount) ), animated: false)
                    case .coolDown:
                        self.progressDone.setProgress(Float(self.currentDoneIndex) / Float(self.coolDownExerciseCount), animated: false)
                    }
                    break
                }
            }
        })
    }
    func gotoNext(index: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.topSwipe()
            
        }
    }
    func gotoFinishScreen(){
        self.timer?.invalidate()
        self.timer = nil
        let vc = WorkoutSubmitVC.instantiate(fromAppStoryboard: .Challenges)
        vc.workoutData = self.workoutData
        vc.programModel = self.programData
        vc.isFromChallenge = self.isFromChallenge
        vc.challengeData = self.challengeData
        vc.isWorkoutCompleted = isWorkoutCompleted
        vc.totalTimeForWorkoutInMin  = self.lblHeaderTime.text ?? ""
        vc.totalTimeInSec = self.initialTimeInSec
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
