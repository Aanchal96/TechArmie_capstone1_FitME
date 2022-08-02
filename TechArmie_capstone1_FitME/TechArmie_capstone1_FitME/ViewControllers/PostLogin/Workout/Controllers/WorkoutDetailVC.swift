//
//  ChallengeWorkoutDetail.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 31/07/22.
//

import UIKit

class WorkoutDetailVC: BaseVC {
    
    //MARK::- OUTLETS
    @IBOutlet weak var lblPlan: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCalory: UILabel!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lblPlanHeader: UILabel!
    @IBOutlet weak var viewOverlay: UIImageView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var btnDownLoading: UIButton!
    @IBOutlet weak var btnStartWorkout: UIButton!
    @IBOutlet weak var btnsBackgroundView: UIView!
    
    //MARK::- PROPERTIES
    var isFromChallenge = true
    var isWarmupExercisesFetched = false
    
    var exerciseResult : ExerciseResult?
    var workoutData : WorkoutModel? //If coming from workout
    var challengeData : Challenge? //If coming from challenge
    
    var arrSets : [[ExerciseModel]]? //Initial from JSON
    var arrWarmup : [ExerciseModel] = [] //Initial From JSON - different object
    var arrExercises : [ExerciseModel] = []//Created (arrSets * count)
    var arrCoolDown : [ExerciseModel] = [] //Initial From JSON - different object
    
    //MARK::- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        btnDownLoading.isHidden = true
        self.tableView.tableFooterView?.height = 80
        onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        isStatusBarWhite = true
    }
    
    //MARK::- BUTTON ACTION
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnActionStartWorkout(_ sender: UIButton) {
        isWarmupExercisesFetched ? self.createCompleteWorkoutArray() : getWorkoutExercises()
    }
    
}

//MARK::- FUNCTION
extension WorkoutDetailVC{
    func onViewDidLoad(){
        self.btnStartWorkout.isHidden =  true
        self.imgHeader.image = nil
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerHeaderFooter(with: WorkoutDetailHeader.self)
        tableView.registerHeaderFooter(with: WorkoutDetailFooter.self)
        tableView.tableHeaderView = viewHeader
        tableView.tableHeaderView?.height = 280
        self.imgHeader.contentMode = .scaleAspectFill
        self.updateHeader()
        self.getDataFromJSON()
    }
    func updateHeader(){
        self.lblPlan.text = workoutData?.name
        self.lblPlanHeader.text = workoutData?.name
        self.lblDesc.text = workoutData?.description
        lblTime.text = "\(workoutData?.duration ?? 0) " + "min"
        lblCalory.text = "\(workoutData?.calories ?? 0) " + "kcal"
        lblHeading.text = workoutData?.workoutSubtitle ?? ""
    }
    
}

//MARK::- TABLE VIEW DELEGATE AND DATASOURCE
extension WorkoutDetailVC : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrSets?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.arrSets?[section].count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 48
    }
    
    // MAIN CELL WITH EXERCISE NAME
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: WorkoutDetailTableCell.self)
        cell.configureCell(data : self.arrSets?[indexPath.section][indexPath.row])
        return cell
    }
    
    // HEADER WITH NUMBER OF ROUNDS
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: WorkoutDetailHeader.className) as? WorkoutDetailHeader else {return UIView()}
        
        headerView.lblRounds.text = (self.arrSets?[section].first?.noOfRounds.description ?? "" ) + " " + " rounds"
        if (self.arrSets?[section].first?.noOfRounds.description ?? "" ) == "1"{
            headerView.lblRounds.text = (self.arrSets?[section].first?.noOfRounds.description ?? "" ) + " " + " round"
        }
        return headerView
        
    }
    
    // FOOTER WITH BOX BOTTOM
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: WorkoutDetailFooter.className) as? WorkoutDetailFooter else {return UIView()}
        return footerView
    }
    
}

//MARK::- API FUNCTIONS
extension WorkoutDetailVC{
    
    //get only exercise set - Fills Data in Header and Exercise Cells
    func getDataFromJSON(){
        guard let model = challengeData?.result else {return}
        arrSets = model.exerciseModel
        exerciseResult = model
        tableView.isHidden = false
        tableView.reloadData()
        btnStartWorkout.isHidden = false
        lblNoData.isHidden = !(self.arrSets?.isEmpty ?? true)
        if self.workoutData?.medias.first?.mediaUrl != ""{
            self.imgHeader.sd_setImage(with: URL.init(string: (self.workoutData?.medias.first?.mediaUrl ?? "")))
        }
        
        self.btnsBackgroundView.isHidden = false
        self.updateHeader()
    }
    
    //get warmup and cooldown
    func getWorkoutExercises(){
        
        self.arrWarmup = self.challengeData?.result.warmUpModel ?? []
        self.arrCoolDown = self.challengeData?.result.coolDownModel ?? []
        self.isWarmupExercisesFetched = true
        self.createCompleteWorkoutArray()
    }
    
    func createCompleteWorkoutArray(){
        
        var completeWorkoutArray : [ExerciseModel] = []
        
        //Add warm up initially
        completeWorkoutArray.append(contentsOf: arrWarmup)
        arrExercises = []
        
        // Add main exercises
        self.arrSets?.forEachEnumerated({  [weak self](index, arrExercise) in
            for _ in 0...((arrExercise.first?.noOfRounds ?? 0) - 1){
                completeWorkoutArray.append(contentsOf: arrExercise)
                self?.arrExercises.append(contentsOf: arrExercise)
            }
        })
        
        // Add cool down exercises
        completeWorkoutArray.append(contentsOf: self.arrCoolDown)
        
        // To add rest elements - static cells
        var newArray : [ExerciseModel] = []
        //flag = 0 exercise , 1 rest , 2 warmup start, 3 warmupEnd , 4 cool down start , 5 cool down finish
        completeWorkoutArray.forEachEnumerated { [weak self] (index, model) in
            
            // Copy all completeWorkoutArray to newArr temporarily
            if index < (self?.arrWarmup.count ?? 0) || index >= (completeWorkoutArray.count - (self?.arrCoolDown.count ?? 0) ) {
                newArray.append(model)
            } else {
                
                // To check if index is not for warm up or cool down
                if index == (completeWorkoutArray.count - (self?.arrCoolDown.count ?? 0) - 1) {
                    newArray.append(model)
                } else {
                    
                    // If index is for workout
                    newArray.append(model)
                    var modelRest = model
                    modelRest.flag = 1
                    newArray.append(modelRest)
                }
            }
        }
        
        // To add instruction elements - static cells
        var modelWarmupStart = ExerciseModel.init()
        modelWarmupStart.flag = 2
        newArray.insert(modelWarmupStart, at: 0)
        
        var modelCoolDownFinish = ExerciseModel.init()
        modelCoolDownFinish.flag = 5
        newArray.append(modelCoolDownFinish)
        
        var modelCoolDownStart = ExerciseModel.init()
        modelCoolDownStart.flag = 4
        newArray.insert(modelCoolDownStart, at: newArray.count - 1 - self.arrCoolDown.count)
        
        var modelWarmupEnd = ExerciseModel.init()
        modelWarmupEnd.flag = 3
        newArray.insert(modelWarmupEnd, at: 1 + arrWarmup.count)
        
        self.gotoNext(newArr : newArray)
    }
    
    // To download the final array created -
    func gotoNext(newArr : [ExerciseModel]){
        
        tryDownload(workoutArray : newArr)
    }
}


//DOWNLOAD FUNCTIONS
//MARK::- FUNCTIONS
extension WorkoutDetailVC{
    
    func tryDownload(workoutArray : [ExerciseModel]){
        //download videos
        self.btnDownLoading.isHidden = false
        
        var completeWorkoutArray : [ExerciseModel] = []
        completeWorkoutArray.append(contentsOf: arrWarmup)
        completeWorkoutArray.append(contentsOf: arrExercises)
        completeWorkoutArray.append(contentsOf: arrCoolDown)
        
        let videoArr : [String] = completeWorkoutArray.map({return $0.medias.first?.mediaUrl ?? ""})
        let audioArr : [String] = completeWorkoutArray.map({return   ($0.medias.first?.audioUrlEn ?? "") })
        let ids : [String] = completeWorkoutArray.map({return $0.medias.first?.id ?? ""})

        CommonFunctions.showActivityLoader()
        
        // First we download and save videos
        DownloadController.shared.saveVideo(urls: videoArr, ids: ids, completed: {  (arrUrl) in
        }, progress: { [weak self] (val) in
            
            if val == videoArr.count{
                CommonFunctions.hideActivityLoader()
                self?.gotoStartWorkout(workoutArray : workoutArray)
            }
            
        }, failure: {[weak self] (error) in
            CommonFunctions.hideActivityLoader()
            CommonFunctions.showToastWithMessage(error.localizedDescription)
            self?.btnDownLoading.isHidden = true
        })
    }

    
    func gotoStartWorkout(workoutArray : [ExerciseModel]){
        self.btnDownLoading.isHidden = true
        
//        let vc = WorkoutVC.instantiate(fromAppStoryboard: .Challenges)
//        vc.workoutData = self.workoutData
//        vc.workoutArray = workoutArray
//        vc.coolDownExerciseCount = self.arrCoolDown.count
//        vc.warmUpExercideCount = self.arrWarmup.count
//        vc.exerciseCount = self.arrExercises.count
//        vc.challengeData = self.challengeData
//        vc.isFromChallenge = isFromChallenge
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

