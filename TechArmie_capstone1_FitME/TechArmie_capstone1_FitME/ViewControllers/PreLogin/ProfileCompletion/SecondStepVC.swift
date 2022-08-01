//
//  SecondStepVC.swift
//  TechArmie_capstone1_FitME
//
//  Created by Vir Davinder Singh on 2022-07-22.
//


import Foundation
import UIKit

class SecondStepVC : BaseVC
{
    @IBOutlet weak var txtWeightGoal: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgFemale: UIImageView!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var imgMale: UIImageView!
    @IBOutlet weak var segmentHeight: UISegmentedControl!
    @IBOutlet weak var segmentWeight: UISegmentedControl!
    
    var profileModel = ProfileModel()
    var ageOriginal = "0"
    var heightUnit = "cm"
    var weightUnit = "kg"
    
    var heightUnitArr = ["cm","ft"]
    var weightUnitArr = ["kg","lbs"]
    var heightUnitArrKeys = [LocalizedString.cm, LocalizedString.ft]
    var weightUnitArrKeys = [LocalizedString.kg, LocalizedString.lbs]
    
    var selectedHeightInFeet = ""
    var selectedHeightInCm = ""
    var selectedHeightInCmOriginal = ""
    //    var selectedWeight = ""
    var selectedWeightOriginal = ""
    var selectedWeightGoalOriginal = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        printDebug(profileModel.goal)
        
        txtWeightGoal.addBottomBorder()
        txtWeight.addBottomBorder()
        txtHeight.addBottomBorder()
        txtAge.addBottomBorder()

        
        let maleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(maleImageTapped(tapGestureRecognizer:)))
        
        let femaleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(femaleImageTapped(tapGestureRecognizer:)))
        
        imgFemale.isUserInteractionEnabled = true
        imgFemale.addGestureRecognizer(femaleTapGestureRecognizer)
        
        imgMale.isUserInteractionEnabled = true
        imgMale.addGestureRecognizer(maleTapGestureRecognizer)
    }
    
    @objc func maleImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        profileModel.gender = .male
        imgMale.backgroundColor = CustomColors.primaryColor
        imgFemale.backgroundColor = CustomColors.secondaryColor
    }
    
    @objc func femaleImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        profileModel.gender = .female
        imgMale.backgroundColor = CustomColors.secondaryColor
        imgFemale.backgroundColor = CustomColors.primaryColor
    }
    
    @IBAction func txtActionDOB(_ sender: UITextField) {
        if profileModel.age == 0{
            self.txtAge.text =  ""
        }else{
            self.txtAge.text =  ageOriginal.description
            
        }
//    }
//
//    @objc func txtActionHeightUnit(_ sender: UISegmentedControl) {
//        self.view.endEditing(true)
//        self.heightUnitKey = heightUnitArrKeys[sender.selectedSegmentIndex]
//        self.heightUnit = self.heightUnitArr[sender.selectedSegmentIndex]
//        //conversions between units
//        if (self.txtHeight.text?.trimmed() ?? "") != ""{
//            if self.heightUnit == HeightUnit.cm.rawValue {
//                let ftPart = self.selectedHeightInFeet.split(".").first?.toInt() ?? 0
//                let inch = self.selectedHeightInFeet.split(".").last?.toInt() ?? 0
//                let totalInches = ((ftPart * 12) + inch)
//                let totalCm = Int((totalInches.toDouble * 2.54).rounded()).description
//                self.selectedHeightInCm = Int((totalInches.toDouble * 2.54).rounded()).description
//                self.selectedHeightInCmOriginal = Int((totalInches.toDouble * 2.54).rounded()).description
//
//                self.txtHeight.text = totalCm + " " + self.heightUnitKey
//            }else{
//                if ((self.selectedHeightInCm.toInt() ?? 0) < 122 || (self.selectedHeightInCm.toInt() ?? 0) > 302){
//                    self.txtHeight.text = ""
//                    self.selectedHeightInFeet = ""
//                    self.imgHeight.isHidden = true
//                    self.view.endEditing(true)
//                    return
//                }
//                let totalInches = ((self.selectedHeightInCm.toDouble() ?? 0) * 0.393701).rounded().toInt
//                let feetPart = totalInches / 12
//                let inchPart = totalInches % 12
//                self.selectedHeightInFeet = feetPart.description + "." + inchPart.description
//                self.txtHeight.text = feetPart.description + "\'" + inchPart.description + "\"" + " " + self.heightUnitKey
//            }
//        }else{
//            self.selectedHeightInCm = ""
//            self.selectedHeightInFeet = ""
//            self.selectedHeightInCmOriginal = ""
//
//        }
//
//    }
//
//    @objc func txtActionWeightUnit(_ sender: UISegmentedControl) {
//        self.view.endEditing(true)
//
//        self.weightUnitKey = self.weightUnitArrKeys[sender.selectedSegmentIndex]
//        self.weightUnit = self.weightUnitArr[sender.selectedSegmentIndex]
//
//        //conversion between units
//        if (self.txtWeight.text?.trimmed() ?? "") != ""{
//            if self.weightUnit == WeightUnit.kg.rawValue {
//                self.profileModel.weight = Int(((self.profileModel.weight.toDouble() ?? 0.0) * 0.453592).rounded()).description
//                self.selectedWeightOriginal = self.profileModel.weight
//
//                self.txtWeight.text = self.profileModel.weight + " " + self.weightUnitKey
//            }else{
//                self.profileModel.weight = Int(((self.profileModel.weight.toDouble() ?? 0.0) * 2.20462).rounded()).description
//                self.selectedWeightOriginal = self.profileModel.weight
//
//                self.txtWeight.text = self.profileModel.weight + " " + self.weightUnitKey
//            }
//        }
//
//        //conversion between units
//        if (self.txtActivity.text?.trimmed() ?? "") != ""{
//            if self.weightUnit == WeightUnit.kg.rawValue {
//                self.profileModel.weightGoal = Int(((self.profileModel.weightGoal.toDouble() ?? 0.0) * 0.453592).rounded()).description
//                self.selectedWeightGoalOriginal = self.profileModel.weightGoal
//
//                self.txtActivity.text = self.profileModel.weightGoal + " " + self.weightUnitKey
//            }else{
//                self.profileModel.weightGoal = Int(((self.profileModel.weightGoal.toDouble() ?? 0.0) * 2.20462).rounded()).description
//                self.selectedWeightGoalOriginal = self.profileModel.weightGoal
//
//                self.txtActivity.text = self.profileModel.weightGoal + " " + self.weightUnitKey
//            }
//        }
//    }
//
//    @IBAction func txtActionPickHeight(_ sender: UITextField) {
//        self.imgHeight.isHidden = true
//        if self.heightUnit == HeightUnit.cm.rawValue {
//            sender.text = self.selectedHeightInCmOriginal
//            sender.inputView = nil
//            sender.inputAccessoryView = nil
//            return
//        }
//        MultiPicker.noOfComponent = 2
//        let ft = self.selectedHeightInFeet.split(".").first ?? ""
//        let inch = JSON(Int(self.selectedHeightInFeet.split(".").last ?? "0") ?? "").stringValue
//
//        MultiPicker.openMultiPickerIn(sender, firstComponentArray: ["4","5","6","7","8","9"], secondComponentArray: ["0","1","2","3","4","5","6","7","8","9","10","11"], firstComponent: ft, secondComponent: inch, titles: [LocalizedString.ft.localized,LocalizedString.inch.localized]) { [weak self](first, second, third, index) in
//            guard let self = self else {return}
//            sender.text = first + "\'" + second + "\""
//            self.selectedHeightInFeet = first + "." + (second.count < 2 ? "0\(second)" : second)
//            self.txtHeight.text =  (self.txtHeight.text ?? "") + " " + self.heightUnitKey
//            self.unhideHeightIcon()
//        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToNext(_ sender: Any) {
        if validateInput(){
            profileModel.heightDict = [ApiKey.height :  heightUnit == HeightUnit.cm.rawValue ? (self.selectedHeightInCm) : self.selectedHeightInFeet , ApiKey.unitSetting : self.heightUnit]
            profileModel.weightDict = [ApiKey.weight : profileModel.weight , ApiKey.unitSetting : self.weightUnit]
            profileModel.weightGoalDict = [ApiKey.weight : profileModel.weightGoal , ApiKey.unitSetting : self.weightUnit]
            
            let vc = ThirdStepVC.instantiate(fromAppStoryboard: .Main)
            vc.profileModel = profileModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension SecondStepVC{
    func validateInput() -> Bool{
//        if txtAge.text?.trimTrailingWhitespace() == ""{
//            CommonFunctions.showToastWithMessage(LocalizedString.enterAgeEmpty.rawValue)
//            return false
//        }
        
//        if profileModel.age == 0{
//            CommonFunctions.showToastWithMessage(LocalizedString.enterAge.rawValue)
//            return false
//        }
        
        return true
        
    }
}
