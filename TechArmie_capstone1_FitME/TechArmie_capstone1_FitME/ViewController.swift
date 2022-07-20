//
//  ViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-15.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var videoLayer: UIView!
    @IBOutlet weak var welcomeImg: UIImageView!
    @IBOutlet weak var lblAlreadyHaveAccount: UILabel!
    @IBOutlet weak var btnNewAccount: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        playVideo()
    }

    func playVideo(){
        guard let path = Bundle.main.path(forResource: "bg_video", ofType: "mp4") else{
            return
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.videoLayer.layer.addSublayer(playerLayer)
        
        player.play()
        
        videoLayer.bringSubviewToFront(welcomeImg)
        videoLayer.bringSubviewToFront(btnNewAccount)
        videoLayer.bringSubviewToFront(btnLogin)
        videoLayer.bringSubviewToFront(lblAlreadyHaveAccount)
    }

}

