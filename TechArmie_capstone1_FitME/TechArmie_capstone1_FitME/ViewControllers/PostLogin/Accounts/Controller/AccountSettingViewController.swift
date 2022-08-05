//
//  AccountSettingViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Bhautik Pethani on 2022-08-03.
//

import UIKit

class AccountSettingViewController: UIViewController {

    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var profilePictureView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var currentWeightView: UIView!
    @IBOutlet weak var deleteAccountView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        addTapsOnView()
    }
    
    @objc func backButtonTap(tapGestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func profilePictureTap(tapGestureRecognizer: UITapGestureRecognizer) {
        debugPrint("Profile Image")
    }
    
    @objc func nameTap(tapGestureRecognizer: UITapGestureRecognizer) {
        debugPrint("Name")
    }
    
    @objc func ageTap(tapGestureRecognizer: UITapGestureRecognizer) {
        debugPrint("Age")
    }
    
    @objc func currentWeightTap(tapGestureRecognizer: UITapGestureRecognizer) {
        debugPrint("Current Weight")
    }
    
    @objc func deleteAccountTap(tapGestureRecognizer: UITapGestureRecognizer) {
        debugPrint("Delete ACcount")
    }

}
extension AccountSettingViewController{
    func addTapsOnView(){
        let backButtonTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonTap(tapGestureRecognizer:)))
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(backButtonTapGestureRecognizer)
        
        let profilePictureTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profilePictureTap(tapGestureRecognizer:)))
        profilePictureView.isUserInteractionEnabled = true
        profilePictureView.addGestureRecognizer(profilePictureTapGestureRecognizer)
        
        let nameTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nameTap(tapGestureRecognizer:)))
        nameView.isUserInteractionEnabled = true
        nameView.addGestureRecognizer(nameTapGestureRecognizer)
        
        let ageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ageTap(tapGestureRecognizer:)))
        ageView.isUserInteractionEnabled = true
        ageView.addGestureRecognizer(ageTapGestureRecognizer)
        
        let currentWeightTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(currentWeightTap(tapGestureRecognizer:)))
        currentWeightView.isUserInteractionEnabled = true
        currentWeightView.addGestureRecognizer(currentWeightTapGestureRecognizer)
        
        let deleteAccountTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteAccountTap(tapGestureRecognizer:)))
        deleteAccountView.isUserInteractionEnabled = true
        deleteAccountView.addGestureRecognizer(deleteAccountTapGestureRecognizer)
    }
}

