//
//  AudioController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-08-01.
//

import Foundation
import AVKit

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

class AudioController : NSObject,AVAudioPlayerDelegate  {
    
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
