//
//  TabBarVC.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-31.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setImages()
    }
    
    //TODO: Fix images
    private func setImages(){
        let vcs = self.viewControllers
        vcs?[0].tabBarItem.image = UIImage(named: "clock")
        vcs?[0].tabBarItem.selectedImage = UIImage(named: "clockSelected")
        
        vcs?[1].tabBarItem.image = UIImage(named: "icChallenge")
        vcs?[1].tabBarItem.selectedImage = UIImage(named: "icChallengeSelected")
        
        vcs?[2].tabBarItem.image = UIImage(named: "icLibrary")
        vcs?[2].tabBarItem.selectedImage = UIImage(named: "icLibrarySelected")
        
        vcs?[3].tabBarItem.image = UIImage(named: "icProfile")
        vcs?[3].tabBarItem.selectedImage = UIImage(named: "icProfileSelected")
    }

}
