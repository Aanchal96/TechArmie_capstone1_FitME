//
//  ChallengeWorkoutDetail.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 31/07/22.
//

import UIKit



extension UITableView {
    func registerCell(with identifier: UITableViewCell.Type)  {
        self.register(UINib(nibName: "\(identifier.self)",bundle:nil),
                      forCellReuseIdentifier: "\(identifier.self)")
    }
    
    ///Register Header Footer View Nib
    func registerHeaderFooter(with identifier: UITableViewHeaderFooterView.Type)  {
        self.register(UINib(nibName: "\(identifier.self)",bundle:nil), forHeaderFooterViewReuseIdentifier: "\(identifier.self)")
    }
    func dequeueCell <T: UITableViewCell> (with identifier: T.Type, indexPath: IndexPath? = nil) -> T {
        if let index = indexPath {
            return self.dequeueReusableCell(withIdentifier: "\(identifier.self)", for: index) as! T
        } else {
            return self.dequeueReusableCell(withIdentifier: "\(identifier.self)") as! T
        }
    }
    
}

class ChallengeWorkoutDetailVC: BaseVC {
    
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
    var isDownloadingAudios = false
    var isFromChallenge = true
    var exerciseResult : ExerciseResult?
    var shouldAddFooter = false
    var workoutData : WorkoutModel?
    var challengeData : Challenge?
    var arrSets : [[ExerciseModel]]?
    var arrWarmup : [ExerciseModel] = []
    var arrCoolDown : [ExerciseModel] = []
    var arrExercises : [ExerciseModel] = []//to find count
    var isWarmupExercisesFetched = false
    var headerImage: UIImage?
    
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
        AudioController.shared.deInitializeAudioPlayer()
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
extension ChallengeWorkoutDetailVC{
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
        self.getDataFromAPI()
    }
    func updateHeader(){
        self.lblPlan.text = workoutData?.name
        self.lblPlanHeader.text = workoutData?.name
        self.lblDesc.text = workoutData?.description
        lblTime.text = "\(workoutData?.duration ?? 0) " + "min"
        lblCalory.text = "\(workoutData?.calories ?? 0) " + "kcal"
        lblHeading.text = workoutData?.workoutSubtitle ?? ""
    }
    
    func gotoNext(newArr : [ExerciseModel]){
        
        tryDownload(workoutArray : newArr)
    }
}


//MARK::- DELEGATE DOWNLOAD VIDEOS
extension ChallengeWorkoutDetailVC {
    func successDownload(workoutArray: [ExerciseModel]) {
                let vc = WorkoutVC.instantiate(fromAppStoryboard: .Challenges)
                vc.workoutData = self.workoutData
                vc.workoutArray = workoutArray
                vc.coolDownExerciseCount = self.arrCoolDown.count
                vc.warmUpExercideCount = self.arrWarmup.count
                vc.exerciseCount = self.arrExercises.count
                vc.challengeData = self.challengeData
                vc.isFromChallenge = isFromChallenge
                self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK::- TABLE VIEW DELEGATE AND DATASOURCE
extension ChallengeWorkoutDetailVC : UITableViewDelegate , UITableViewDataSource{
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: WorkoutDetailTableCell.self)
        cell.imgShuffle.isHidden = true//option should always be there to swap
        cell.configureCell(data : self.arrSets?[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: WorkoutDetailHeader.className) as? WorkoutDetailHeader else {return UIView()}
        
        headerView.lblRounds.text = (self.arrSets?[section].first?.noOfRounds.description ?? "" ) + " " + " rounds"
        if (self.arrSets?[section].first?.noOfRounds.description ?? "" ) == "1"{
            headerView.lblRounds.text = (self.arrSets?[section].first?.noOfRounds.description ?? "" ) + " " + " round"
        }
        return headerView
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: WorkoutDetailFooter.className) as? WorkoutDetailFooter else {return UIView()}
        return footerView
    }
    
}

//MARK::- API FUNCTIONS
extension ChallengeWorkoutDetailVC{
    
    //get only exercise set
    func getDataFromAPI(){
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
   
        self.shouldAddFooter = true
        self.btnsBackgroundView.isHidden = false
        self.updateHeader()
    }
    
    //get warmup and cooldown
    func getWorkoutExercises(){
        if self.workoutData?.id == "" {
            return
        }
        
        self.arrWarmup = self.challengeData?.result.warmUpModel ?? []
        self.arrCoolDown = self.challengeData?.result.coolDownModel ?? []
        self.isWarmupExercisesFetched = true
        self.createCompleteWorkoutArray()
        
    }
    
    func createCompleteWorkoutArray(){
        var completeWorkoutArray : [ExerciseModel] = []
        completeWorkoutArray.append(contentsOf: arrWarmup)
        arrExercises = []
        self.arrSets?.forEachEnumerated({  [weak self](index, arrExercise) in
            for _ in 0...((arrExercise.first?.noOfRounds ?? 0) - 1){
                completeWorkoutArray.append(contentsOf: arrExercise)
                self?.arrExercises.append(contentsOf: arrExercise)
            }
        })
        
        completeWorkoutArray.append(contentsOf: self.arrCoolDown)
        printDebug(completeWorkoutArray)
        var newArray : [ExerciseModel] = []
        //flag = 0 exercise , 1 rest , 2 warmup start, 3 warmupEnd , 4 cool down start , 5 cool down finish
        completeWorkoutArray.forEachEnumerated { [weak self] (index, model) in
            if index < (self?.arrWarmup.count ?? 0) || index >= (completeWorkoutArray.count - (self?.arrCoolDown.count ?? 0) ) {
                newArray.append(model)
            }else{
                if index == (completeWorkoutArray.count - (self?.arrCoolDown.count ?? 0) - 1) {
                    newArray.append(model)
                }else{
                    newArray.append(model)
                    var modelRest = model
                    modelRest.flag = 1
                    newArray.append(modelRest)
                }
            }
        }
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
}


//DOWNLOAD FUNCTIONS
//MARK::- FUNCTIONS
extension ChallengeWorkoutDetailVC{
    func tryDownload(workoutArray : [ExerciseModel]){
        //download videos
        self.btnDownLoading.isHidden = false
        var arrTemp : [ExerciseModel] = []
        arrTemp.append(contentsOf: arrWarmup)
        arrTemp.append(contentsOf: arrExercises)
        arrTemp.append(contentsOf: arrCoolDown)
        let videoArr : [String] = arrTemp.map({return $0.medias.first?.mediaUrl ?? ""})
        let audioArr : [String] = arrTemp.map({return   ($0.medias.first?.audioUrlEn ?? "") })
        let ids : [String] = arrTemp.map({return $0.medias.first?.id ?? ""})
        if isDownloadingAudios{
            self.downloadAudios(ids : ids , urls : audioArr , workoutArray : workoutArray)
            return
        }
        CommonFunctions.showActivityLoader()
        DownloadController.shared.saveVideo(urls: videoArr, ids: ids, completed: {  (arrUrl) in
        }, progress: { [weak self] (val) in
            
            if val == videoArr.count{
                CommonFunctions.hideActivityLoader()
                self?.downloadAudios(ids : ids , urls : audioArr , workoutArray : workoutArray)
            }
        }, failure: {[weak self] (error) in
            CommonFunctions.hideActivityLoader()
            CommonFunctions.showToastWithMessage(error.localizedDescription)
            self?.btnDownLoading.isHidden = true
        })
    }
    
    func downloadAudios(ids : [String] , urls : [String] , workoutArray : [ExerciseModel]){
        let urls = urls
        isDownloadingAudios = true
        CommonFunctions.showActivityLoader()
        DownloadController.shared.saveAudio(urls: urls, ids: ids, completed: {  (arrUrl) in
        }, progress: { [weak self] (val) in
            
            if val == urls.count{
                CommonFunctions.hideActivityLoader()
                self?.gotoStartWorkout(workoutArray : workoutArray)
            }
        }, failure: {[weak self] (error) in
            DispatchQueue.main.async { [weak self] in
                CommonFunctions.hideActivityLoader()
                CommonFunctions.showToastWithMessage(error.localizedDescription)
                self?.btnDownLoading.isHidden = true
            }
        })
    }
    
    func gotoStartWorkout(workoutArray : [ExerciseModel]){
        self.btnDownLoading.isHidden = true
        self.successDownload(workoutArray: workoutArray)
    }
}

