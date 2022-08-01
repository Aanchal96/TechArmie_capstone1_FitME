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
        vcs?[0].tabBarItem.image = UIImage(named: "clock")
        vcs?[0].tabBarItem.selectedImage = UIImage(named: "clock")
        
        vcs?[1].tabBarItem.image = UIImage(named: "clock")
        vcs?[1].tabBarItem.selectedImage = UIImage(named: "clock")
        
        vcs?[2].tabBarItem.image = UIImage(named: "clock")
        vcs?[2].tabBarItem.selectedImage = UIImage(named: "clock")
        
        vcs?[3].tabBarItem.image = UIImage(named: "clock")
        vcs?[3].tabBarItem.selectedImage = UIImage(named: "clock")
    }

}
