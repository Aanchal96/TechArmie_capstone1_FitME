//
//  AccountSettingViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Bhautik Pethani on 2022-08-03.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AccountSettingViewController: UIViewController {

    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var profilePictureView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var currentWeightView: UIView!
    @IBOutlet weak var deleteAccountView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var ageTextLabel: UILabel!
    @IBOutlet weak var currentWeightTextLabel: UILabel!
    var user: AuthUser!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.user = AuthUser(AppUserDefaults.value(forKey: .fullUserProfile));
        self.loadValues()
        addTapsOnView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.user = AuthUser(AppUserDefaults.value(forKey: .fullUserProfile));
        self.loadValues()
    }
    
    func loadValues() {
        nameTextLabel.text = user.name
        ageTextLabel.text = "\(user.age) Year"
        currentWeightTextLabel.text = "\(user.userWeight.weight) \(user.userWeight.unitSetting)"
        profileImageView.load(url: NSURL(string: user.profileImage)! as URL);
    }
    
    @objc func backButtonTap(tapGestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func profilePictureTap(tapGestureRecognizer: UITapGestureRecognizer) {
        debugPrint("Profile Image")
    }
    
    @objc func nameTap(tapGestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Edit Name", message: "Enter name", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = self.user.name
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if textField?.text == nil {
                return
            }
            guard let user = Auth.auth().currentUser else {  return }
            if (textField?.text == user.displayName) {
                return;
            }
            if let name = textField?.text {
                let changeRequest = user.createProfileChangeRequest();
                changeRequest.displayName = name
                changeRequest.commitChanges { error1 in
                    if let error1 = error1 {
                        self.showMessagePrompt(error1.localizedDescription);
                    } else {
                        let db = Firestore.firestore().collection("users");
                        let firebaseUser = db.document(user.uid)
                        firebaseUser.setData([ "name": name ], merge: true);
                        self.user.name = name;
                        self.user.saveToUserDefaults()
                        self.loadValues();
                    }
                }
            }
            
        }));
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func ageTap(tapGestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Edit Age", message: "Enter age", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = "\(self.user.age)"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if textField?.text == nil {
                return
            }
            guard let user = Auth.auth().currentUser else {  return }
            if (textField?.text?.toInt() == self.user.age) {
                return;
            }
            if let age = textField?.text {
                let db = Firestore.firestore().collection("users");
                let firebaseUser = db.document(user.uid)
                firebaseUser.setData([ "age": age ], merge: true);
                self.user.age = age.toInt() ?? 0;
                self.user.saveToUserDefaults()
                self.loadValues();
            }
        }));
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func currentWeightTap(tapGestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Edit Weight", message: "Enter weight", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = "\(self.user.userWeight.weight)"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if textField?.text == nil {
                return
            }
            guard let user = Auth.auth().currentUser else {  return }
            if (textField?.text?.toDouble() == self.user.userWeight.weight) {
                return;
            }
            if let weight = textField?.text {
                let db = Firestore.firestore().collection("users");
                let firebaseUser = db.document(user.uid)
                firebaseUser.setData([ "userWeight": [
                    "weight": weight,
                    "unitSetting": self.user.userWeight.unitSetting
                ] ], merge: true);
                self.user.userWeight.weight = weight.toDouble() ?? 0.0;
                self.user.saveToUserDefaults()
                self.loadValues();
            }
            
        }));
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func deleteAccountTap(tapGestureRecognizer: UITapGestureRecognizer) {
        
        guard let user = Auth.auth().currentUser else {  return }
        
        debugPrint(user.providerID);
        
        switch user.providerID {
            case "Firebase":
                let alert = UIAlertController(title: "Re-enter password to delete account", message: "Enter password", preferredStyle: .alert)

                alert.addTextField { (textField) in
                    textField.text = ""
                    textField.isSecureText = true
                }

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0]
                    if textField?.text == nil {
                        return
                    }
                    guard let user = Auth.auth().currentUser else {  return }
                    if let password = textField?.text {
                        if (password.isBlank) {
                            return;
                        }
                        user.reauthenticate(with: EmailAuthProvider.credential(withEmail: user.email!, password: password)) { result, error in
                            if let error = error {
                                self.showMessagePrompt("Something went wrong. Try again later \(error.localizedDescription)");
                                return;
                            }
                            user.delete { error in
                              if let error = error {
                                  self.showMessagePrompt("Something went wrong. Try again later \(error.localizedDescription)");
                              } else {
                                  let db = Firestore.firestore().collection("users");
                                  let firebaseUser = db.document(user.uid)
                                  firebaseUser.delete()
                                  GoogleLoginController.shared.logout()
                                  AppUserDefaults.removeAllValues()
                                  let vc = OnboardingViewController.instantiate(fromAppStoryboard: .Main)
                                  let nvc = UINavigationController(rootViewController: vc)
                                  nvc.isNavigationBarHidden = true
                                  nvc.navigationBar.isHidden = true
                                  nvc.setNavigationBarHidden(true, animated: true)
                                  AppDelegate.shared.window?.rootViewController = nvc
                                  AppDelegate.shared.window?.makeKeyAndVisible()
                              }
                            }
                        }
                    }

                }));
                self.present(alert, animated: true, completion: nil)
            break;
            case "Google":
            
            break;
            default: return;
        }
        



       

        
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

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
