//
//  FifthStepVC.swift
//  TechArmie_capstone1_FitME
//
//  Created by Vir Davinder Singh on 2022-07-22.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore

class FifthStepVC : BaseVC{
    
    var profileModel = ProfileModel()
    var authUser = AuthUser()
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToSignUp(_ sender: UIButton) {
        self.saveToDefaults();

        let vc = SignUpController.instantiate(fromAppStoryboard: .Authentication)
        vc.profileModel = profileModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func saveToDefaults() {
        authUser.goalToJoin = profileModel.goal.rawValue
        authUser.gender = profileModel.gender
        authUser.age = profileModel.age
        authUser.userWeight = UserWeight([ApiKey.unitSetting: profileModel.weightDict![ApiKey.unitSetting] ?? "", ApiKey.weight: profileModel.weightDict![ApiKey.weight] ?? ""])
        authUser.userHeight = UserHeight([ApiKey.unitSetting: profileModel.heightDict![ApiKey.unitSetting] ?? "", ApiKey.weight: profileModel.heightDict![ApiKey.height] ?? ""])
        authUser.usergoal = UserWeight([ApiKey.unitSetting: profileModel.weightGoalDict![ApiKey.unitSetting] ?? "", ApiKey.weight: profileModel.weightGoalDict![ApiKey.weight] ?? ""])
        
        authUser.initialUserWeight = UserWeight([ApiKey.unitSetting: profileModel.weightDict![ApiKey.unitSetting] ?? "", ApiKey.weight: profileModel.weightDict![ApiKey.weight] ?? ""])
        
        authUser.priorityLevel = profileModel.level.rawValue
        authUser.isPremium = false
        
        authUser.saveToUserDefaults()
    }
    
    @IBAction func googleSignInButton(_ sender: Any) {
        
        GoogleLoginController.shared.loginWithGoogle(fromViewController: self) { googleUser in
            self.authUser.name = googleUser.name;
            self.authUser.email = googleUser.email;
            if let image = googleUser.image {
                self.authUser.profileImage = image.absoluteString;
            }
            
            self.saveToDefaults();
            guard let user = Auth.auth().currentUser else {  return }
            let db = Firestore.firestore().collection(ApiKey.users);
            db.document(user.uid)
                .setData(AppUserDefaults.value(forKey: .fullUserProfile).rawValue as! [String : Any]);
            db.document(user.uid).getDocument(completion: { data, error in
                if error != nil {
                    return;
                }
                if data == nil {
                    return;
                }
                if let data = data {
                    do {
                        try AuthUser(data.toObject()).saveToUserDefaults();
                        let vc = TabBarVC.instantiate(fromAppStoryboard: .TabBar)
                        vc.navigationController?.isNavigationBarHidden = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    } catch {
                        print(error)
                    }
                }
            })
            
            
        } failure: { error in
            CommonFunctions.showToast(error.localizedDescription)
        }
        
    }
}
