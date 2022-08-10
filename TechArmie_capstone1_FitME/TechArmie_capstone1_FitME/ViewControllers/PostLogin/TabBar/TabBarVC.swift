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
    
    private func setImages(){
        let vcs = self.viewControllers
        vcs?[0].tabBarItem.image = #imageLiteral(resourceName: "clock")
        vcs?[0].tabBarItem.selectedImage = #imageLiteral(resourceName: "clockSelected")
        
        vcs?[1].tabBarItem.image = #imageLiteral(resourceName: "icChallenge")
        vcs?[1].tabBarItem.selectedImage = #imageLiteral(resourceName: "icChallengeSelected")
        
        vcs?[2].tabBarItem.image = #imageLiteral(resourceName: "icLibrary")
        vcs?[2].tabBarItem.selectedImage = #imageLiteral(resourceName: "icLibrarySelected")
        
        vcs?[3].tabBarItem.image = #imageLiteral(resourceName: "icProfile")
        vcs?[3].tabBarItem.selectedImage = #imageLiteral(resourceName: "icProfileSelected")
        
        vcs?[0].tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        vcs?[1].tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        vcs?[2].tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        vcs?[3].tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }

}
