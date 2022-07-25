

import UIKit
import AVFoundation
import SwiftyJSON
import IQKeyboardManagerSwift

enum AudioName{
    static var rest : String{
        return "Rest"
    }
    static var exerciseComplete : String{
        return "ExerciseCompleted"
    }
    static var warmupComplete : String{
        return "WarmUpCompleted"
    }
    static var workoutComplete : String{
        return "WorkoutCompleted"
    }
    static var go : String{
        return "321Go"
    }
    
}

class AudioController : NSObject ,AVAudioPlayerDelegate  {
    
    static let shared = AudioController()
    var audioPlayer : AVAudioPlayer?
    var isMuted = false
    var nextAudioName : String? = nil
    
    func stopAudio(){
        if (self.audioPlayer?.isPlaying ?? false){
            self.audioPlayer?.stop()
        }
    }
    
    func muteAudio(){
        
        self.isMuted = true
        self.audioPlayer?.setVolume(0.0, fadeDuration: 0.0)
    }
    func unMuteAudio(){
        
        self.isMuted = false
        self.audioPlayer?.setVolume(1.0, fadeDuration: 0.0)
    }
    
    func deInitializeAudioPlayer(){
        
        self.audioPlayer?.stop()
        self.audioPlayer = nil
    }
    
    func playAudioFromPath(name : String , isMuted : Bool = false , nextAudioName : String? = nil ){
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: AVAudioSession.CategoryOptions.mixWithOthers)
        }
        catch let error as NSError {
            printDebug("Error: Could not set audio category: \(error), \(error.userInfo)")
        }
        
        guard let url = Bundle.main.url(forResource: name, withExtension: ".mp3")  else {return}
        do{
            self.audioPlayer =  try  AVAudioPlayer.init(contentsOf: url)
        }catch let error as NSError {
            printDebug("Error: Could not find file: \(error), \(error.userInfo)")
        }
        if (self.audioPlayer?.isPlaying ?? false){
            self.audioPlayer?.stop()
        }
        self.nextAudioName = nextAudioName
        self.audioPlayer?.setVolume(self.isMuted ? 0 : 1.0, fadeDuration: 0)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.delegate = self
        self.audioPlayer?.play()
    }
    
    func playAudioFromLocal(url : URL  , nextAudioName : String? = nil ){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: AVAudioSession.CategoryOptions.mixWithOthers)
        }
        catch let error as NSError {
            printDebug("Error: Could not set audio category: \(error), \(error.userInfo)")
        }
        do{
            self.audioPlayer =  try  AVAudioPlayer.init(contentsOf: url)
        }catch let error as NSError {
            printDebug("Error: Could not find file: \(error), \(error.userInfo)")
        }
        if (self.audioPlayer?.isPlaying ?? false){
            self.audioPlayer?.stop()
        }
        self.nextAudioName = nextAudioName
        self.audioPlayer?.delegate = self
        self.audioPlayer?.setVolume(self.isMuted ? 0 : 1.0, fadeDuration: 0)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag{
            if let name = self.nextAudioName{
                playAudioFromPath(name: name)
            }
        }
    }
}


class CommonFunctions {

    /// Show Toast With Message
    static func showToastWithMessage(_ msg: String, isNative : Bool = false, completion: (() -> Swift.Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.topMostVC?.view.endEditing(true)
            if msg == "PleaseCheckInternetConnection" && !isNative{
                self.showToast(msg)
                return
            }
            let alertViewController = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.destructive) { (action : UIAlertAction) -> Void in
                alertViewController.dismiss(animated: true, completion: nil)
                completion?()
            }
            
            alertViewController.addAction(okAction)
            UIApplication.topMostVC?.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    static func showToast(_ msg : String){
        DispatchQueue.main.async {
            UIApplication.topMostVC?.view.endEditing(true)
            if let vc = AppDelegate.shared.windows.first.rootViewController{
                if let controller = vc.presentedViewController{
                    controller.view.makeToast(msg)

                }else{
                    vc.view.makeToast(msg)

                }
            }
        }
    }
    
    /// Delay Functions
    class func delay(delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when) {
            closure()
        }
    }
    
    /// Show Action Sheet With Actions Array
    class func showActionSheetWithActionArray(_ title: String?, message: String?,
                                              viewController: UIViewController,
                                              alertActionArray : [UIAlertAction],
                                              preferredStyle: UIAlertController.Style)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alertActionArray.forEach{ alert.addAction($0) }
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Show Activity Loader
    class func showActivityLoader() {
        DispatchQueue.main.async {
            if let vc = AppDelegate.shared.windows.first.rootViewController {
                vc.startNYLoader()
            }
        }
    }
    
    /// Hide Activity Loader
    class func hideActivityLoader() {
        DispatchQueue.main.async {
            if let vc = AppDelegate.shared.windows.first.rootViewController {
                vc.stopAnimating()
            }
        }
    }
    
}

//MARK::- EXTENSION LOCALZATION FUNCTIONS
extension CommonFunctions{
    
    class func alertForErrorWithTitle(title: String, doneTitle: String , msg : String, selfVC : UIViewController, completion: (()->())? = nil) {
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: doneTitle , style: UIAlertAction.Style.cancel) { (_) in
            completion?()
        }
        
        alertController.addAction(action)
        selfVC.present(alertController, animated: true, completion: nil)
        UILabel.appearance(whenContainedInInstancesOf:
            [UIAlertController.self]).numberOfLines = 0
        
        UILabel.appearance(whenContainedInInstancesOf:
            [UIAlertController.self]).lineBreakMode = .byWordWrapping
    }
    
    //MARK:- AppVersioning and force update
    //==============================================

    //Enable IQKeyboard
    class func enableIQKeybaord() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    class func disableIQKeyboard() {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
}
