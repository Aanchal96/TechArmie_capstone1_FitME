//
//  AccountSettingViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Bhautik Pethani on 2022-08-03.
//

import UIKit

class AccountSettingViewController: UIViewController {

    @IBOutlet weak var backButton: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        addTapsOnView()
    }
    
    @objc func backButtonTap(tapGestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension AccountSettingViewController{
    func addTapsOnView(){
        let backButtonTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonTap(tapGestureRecognizer:)))
        
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(backButtonTapGestureRecognizer)
    }
}

