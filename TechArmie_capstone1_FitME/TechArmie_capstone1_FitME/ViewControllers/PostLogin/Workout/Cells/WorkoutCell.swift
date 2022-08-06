
import UIKit
import AVFoundation

protocol WorkoutComplete: AnyObject {
    func gotoNext(index : Int)
}

class WorkoutCell: UITableViewCell {
    
    //MARK::- OUTLETS
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var lblCircleCountDown: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblExercise: UILabel!
    @IBOutlet weak var viewOverlay: UIView!
    @IBOutlet weak var greenView: UIView!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    //MARK::- PROPERTIES
    var isCurrentScreen : Bool = true
    weak var delegate : WorkoutComplete?
    var timerCountdown = 10
    var timerVal = 40
    var initalExerciseTime = 0
    var timer : Timer? // exercise time
    var countDownTimer : Timer? //countdown time
    var isFirst = true
    var topCellIndex = 0
    
    var isRepBasedExercise = false
    var data : ExerciseModel?
    
    //MARK::- CELL CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.countDownTimer?.invalidate()
        self.timer?.invalidate()
        timerCountdown = 10
       // self.timer = nil
        //self.countDownTimer = nil
        progressView.trackTintColor = AppColors.themePrimaryColor
        progressView.progressTintColor = UIColor.white
        progressView.isHidden = false
        self.mainImageView.isHidden = false
        self.videoView?.isHidden = true
        greenView.alpha = 0
        progressView.setProgress(0, animated: false)

    }
    
    //MARK::- FUNCTIONS
    func configureCell(data : ExerciseModel?){
        self.mainImageView.isHidden = false
        progressView.isHidden = false
        progressView.setProgress(0, animated: false)
        progressView.trackTintColor = AppColors.themePrimaryColor
        progressView.progressTintColor = UIColor.white
        timerCountdown = 10
        self.videoView?.isHidden = true
        self.countDownTimer?.invalidate()
        self.timer?.invalidate()
        greenView.alpha = 0
        self.data = data
        guard let urlToPlay = DownloadController.shared.checkIfFileExists(AppDelegate.shared.videoURLChallenge, isVideo: true).1 else {return}
        videoView?.configure(url: urlToPlay , isLocal : true)
        self.timerVal = data?.exeDuration ?? 0
        self.initalExerciseTime = data?.exeDuration ?? 0
        self.lblExercise.text = data?.exerciseName ?? ""
        self.updateLabel()
        self.isRepBasedExercise = data?.exerciseType == 1
        if self.isRepBasedExercise{
            self.lblTime.text = self.timerVal.description
            //+ (self.isRepBasedExercise  ? LocalizedString.repetitions.localized : LocalizedString.seconds.localized)
        }
        self.mainImageView.image = createThumbnailOfVideoFromFileURL(videoURL: urlToPlay.absoluteString)
    }
    
    func createThumbnailOfVideoFromFileURL(videoURL: String) -> UIImage? {
        let asset = AVAsset(url: URL.init(fileURLWithPath: videoURL))
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(Float64(0), preferredTimescale: 100)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            return UIImage()
        }
    }
    
    //WHEN CELL IS SCROLLED TO TOP
    func cellDisplayed(index : Int){
        self.topCellIndex = index
        progressView.isHidden = false // set it to false //comment
        progressView.setProgress(0, animated: false)
       // self.progressView.trackTintColor = AppColors.themeGreenColor
        
        
   
        
        //        if isFirst{
        videoView?.play()
        //        }
        //        isFirst = false
        self.mainImageView.isHidden = true
        self.videoView?.isHidden = false
        self.animateTimer()
        self.countDownTimer = Timer.scheduledTimer(withTimeInterval: 1.0
            , repeats: true, block: { [weak self] (_) in
                guard let wSelf = self else{return}
                wSelf.animateTimer()
                
        })
    }
    
    private func animateTimer(){
        if !(UIApplication.topViewController() is WorkoutVC){
            self.timer?.invalidate()
            self.countDownTimer?.invalidate()
            return
        }
        if self.timerCountdown == -1{
            self.countDownTimer?.invalidate()
            self.countDownTimerFinished()
            return
        }
        self.viewOverlay.isHidden = true
        
        self.lblCircleCountDown.transform = CGAffineTransform(scaleX: 2, y: 2)
        self.lblCircleCountDown.text = self.timerCountdown == 0 ? "Go" : self.timerCountdown.description
   
        self.lblCircleCountDown.isHidden = false
        
        self.timerCountdown = (self.timerCountdown) - 1
        UIView.animate(withDuration: 0.9, animations: { [weak self] in
            self?.lblCircleCountDown.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: { [weak self] (val) in
                self?.lblCircleCountDown.isHidden = true
                if self?.timerCountdown == 3{
               
                }else{
                    //play exercise time audios here when value is 7 or 8 //TODO
                }
        })
    }
    
    //GO TO NEXT IF COUNTER IS 0 OR DECREMENT VALUE BY 1
    func countDownTimerFinished(){
        if self.isRepBasedExercise{
            self.timer?.invalidate()
            return
        }
        self.updateLabel()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (_) in
            if !(self?.isCurrentScreen ?? true){
                self?.timer?.invalidate()
                self?.countDownTimer?.invalidate()
                return
            }
            self?.timerVal = (self?.timerVal ?? 1) - 1
            self?.updateLabel()
        
        })
        
    }
    func gotoNext(){
        self.videoView?.stop()
        self.timer?.invalidate()
        delegate?.gotoNext(index: self.topCellIndex)
    }
    func updateLabel(){
        
        UIView.animate(withDuration:  1.5) {
            self.progressView.setProgress(Float(self.initalExerciseTime-self.timerVal)/Float(self.initalExerciseTime) , animated : true)
        }

        printDebug(Float(timerVal)/Float(initalExerciseTime))
        if self.timerVal <= 10{
            self.progressView.trackTintColor = UIColor.orange
        }else{
            self.progressView.trackTintColor = AppColors.themePrimaryColor
        }
        let time = self.timerVal
        let min = time / 60
        let sec = time % 60
        if self.timerVal == 0{
            self.lblTime.text = "0"
            self.progressView.setProgress(1.0, animated: false)
            self.gotoNext()
            self.timer?.invalidate()
        }else{
            self.lblTime.text = ( sec.description.count == 1 ? min.description + ":0" + sec.description   : (min.description + ":" + sec.description))
            self.lblTime.text = time.description
            //+ (LocalizedString.seconds.localized)
        }
    }
}
