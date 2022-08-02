//
//  SecondStepVC.swift
//  TechArmie_capstone1_FitME
//
//  Created by Vir Davinder Singh on 2022-07-22.
//


import Foundation
import UIKit
import SwiftyJSON

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
    var heightUnitKey = LocalizedString.cm
    var weightUnitKey = LocalizedString.kg
    
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
        onViewDidLoad()
        navigationController?.navigationBar.isHidden = true

        //debugPrint(profileModel.goal)
        
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
    }

    @objc func txtActionHeightUnit(_ sender: UISegmentedControl) {
        self.view.endEditing(true)
        self.heightUnitKey = heightUnitArrKeys[sender.selectedSegmentIndex]
        self.heightUnit = self.heightUnitArr[sender.selectedSegmentIndex]
        
        //conversions between units
        if (self.txtHeight.text?.trimmed() ?? "") != ""{
            if self.heightUnit == HeightUnit.cm.rawValue {
                let ftPart = self.selectedHeightInFeet.split(".").first?.toInt() ?? 0
                let inch = self.selectedHeightInFeet.split(".").last?.toInt() ?? 0
                let totalInches = ((ftPart * 12) + inch)
                let totalCm = Int((totalInches.toDouble * 2.54).rounded()).description
                self.selectedHeightInCm = Int((totalInches.toDouble * 2.54).rounded()).description
                self.selectedHeightInCmOriginal = Int((totalInches.toDouble * 2.54).rounded()).description

                self.txtHeight.text = totalCm + " " + self.heightUnitKey.localized
            }else{
                if ((self.selectedHeightInCm.toInt() ?? 0) < 122 || (self.selectedHeightInCm.toInt() ?? 0) > 302){
                    self.txtHeight.text = ""
                    self.selectedHeightInFeet = ""
                    self.view.endEditing(true)
                    return
                }
                let totalInches = ((self.selectedHeightInCm.toDouble() ?? 0) * 0.393701).rounded().toIntValue()
                let feetPart = (totalInches ?? 0) / 12
                let inchPart = (totalInches ?? 0) % 12
                self.selectedHeightInFeet = feetPart.description + "." + inchPart.description
                self.txtHeight.text = feetPart.description + "\'" + inchPart.description + "\"" + " " + self.heightUnitKey.localized
            }
        }else{
            self.selectedHeightInCm = ""
            self.selectedHeightInFeet = ""
            self.selectedHeightInCmOriginal = ""

        }

    }

    @objc func txtActionWeightUnit(_ sender: UISegmentedControl) {
        self.view.endEditing(true)
        self.weightUnitKey = self.weightUnitArrKeys[sender.selectedSegmentIndex]
        self.weightUnit = self.weightUnitArr[sender.selectedSegmentIndex]

        //conversion between units
        if (self.txtWeight.text?.trimmed() ?? "") != ""{
            //printDebug(txtWeight.text)
            if self.weightUnit == WeightUnit.kg.rawValue {
                self.profileModel.weight = Int(((self.profileModel.weight.toDouble() ?? 0.0) * 0.453592).rounded()).description
                self.selectedWeightOriginal = self.profileModel.weight

                self.txtWeight.text = self.profileModel.weight + " " + self.weightUnitKey.localized
            }else{
                self.profileModel.weight = Int(((self.profileModel.weight.toDouble() ?? 0.0) * 2.20462).rounded()).description
                self.selectedWeightOriginal = self.profileModel.weight

                self.txtWeight.text = self.profileModel.weight + " " + self.weightUnitKey.localized
            }
        }

        //conversion between units
        if (self.txtWeightGoal.text?.trimmed() ?? "") != ""{
            if self.weightUnit == WeightUnit.kg.rawValue {
                self.profileModel.weightGoal = Int(((self.profileModel.weightGoal.toDouble() ?? 0.0) * 0.453592).rounded()).description
                self.selectedWeightGoalOriginal = self.profileModel.weightGoal

                self.txtWeightGoal.text = self.profileModel.weightGoal + " " + self.weightUnitKey.localized
            }else{
                self.profileModel.weightGoal = Int(((self.profileModel.weightGoal.toDouble() ?? 0.0) * 2.20462).rounded()).description
                self.selectedWeightGoalOriginal = self.profileModel.weightGoal

                self.txtWeightGoal.text = self.profileModel.weightGoal + " " + self.weightUnitKey.localized
            }
        }
    }

    @IBAction func txtActionPickHeight(_ sender: UITextField) {
        if self.heightUnit == HeightUnit.cm.rawValue {
            sender.text = self.selectedHeightInCmOriginal
            sender.inputView = nil
            sender.inputAccessoryView = nil
            return
        }
        MultiPicker.noOfComponent = 2
        let ft = self.selectedHeightInFeet.split(".").first ?? ""
        let inch = JSON(Int(self.selectedHeightInFeet.split(".").last ?? "0") ?? "").stringValue

        MultiPicker.openMultiPickerIn(sender, firstComponentArray: ["4","5","6","7","8","9"], secondComponentArray: ["0","1","2","3","4","5","6","7","8","9","10","11"], firstComponent: ft, secondComponent: inch, titles: [LocalizedString.ft.localized,LocalizedString.inch.localized]) { [weak self](first, second, third, index) in
            guard let self = self else {return}
            sender.text = first + "\'" + second + "\""
            self.selectedHeightInFeet = first + "." + (second.count < 2 ? "0\(second)" : second)
            self.txtHeight.text =  (self.txtHeight.text ?? "") + " " + self.heightUnitKey.localized
        }

        
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
    
    func setupInitialData(){
        if self.weightUnit == WeightUnit.kg.rawValue{
            self.weightUnitKey = self.weightUnitArrKeys[0]
            self.segmentWeight.selectedSegmentIndex = 0
        }else{
            self.weightUnitKey = self.weightUnitArrKeys[1]
            self.segmentWeight.selectedSegmentIndex = 1
        }
        if self.heightUnit == HeightUnit.cm.rawValue{
            self.heightUnitKey = self.heightUnitArrKeys[0]
            self.segmentHeight.selectedSegmentIndex = 0
            
        }else{
            self.heightUnitKey = self.heightUnitArrKeys[1]
            self.segmentHeight.selectedSegmentIndex = 1
        }
        
        self.txtWeightGoal.text = self.selectedWeightGoalOriginal + " " + self.weightUnitKey.localized
    }
    
    func onViewDidLoad(){
        profileModel.gender = .male
        txtAge.delegate = self
        txtHeight.delegate = self
        txtWeight.delegate = self
        txtWeightGoal.delegate = self
        
        segmentHeight.addTarget(self, action: #selector(txtActionHeightUnit(_:)), for: .valueChanged)
        segmentWeight.addTarget(self, action: #selector(txtActionWeightUnit(_:)), for: .valueChanged)
    }
    
    func heightEntered(){
        if  self.txtHeight.text?.trimmed() != ""{
            if self.heightUnit == HeightUnit.cm.rawValue {
                
                let formatter: NumberFormatter = NumberFormatter()
                let final = formatter.number(from: txtHeight.text ?? "0")?.description ?? "0"
                self.selectedHeightInCm = final
                self.selectedHeightInCmOriginal = (self.txtHeight.text ?? "")
                
                self.txtHeight.text =  (self.txtHeight.text ?? "") + " " + self.heightUnitKey.localized
            }
        }else{
            self.selectedHeightInFeet = ""
            self.selectedHeightInCm = ""
            self.selectedHeightInCmOriginal = ""
        }
    }
    func weightEntered(){
        
        if  self.txtWeight.text?.trimmed() != ""{
            let formatter: NumberFormatter = NumberFormatter()
            let final = formatter.number(from: txtWeight.text ?? "0")?.description ?? "0"
            profileModel.weight = final
            self.selectedWeightOriginal = (self.txtWeight.text ?? "")
            self.txtWeight.text = (self.txtWeight.text ?? "") + " " + self.weightUnitKey.localized
        }else{
            profileModel.weight =  ""
            self.selectedWeightOriginal =  ""
        }
    }
    
    func weightGoalEntered(){
        
        if  self.txtWeightGoal.text?.trimmed() != ""{
            let formatter: NumberFormatter = NumberFormatter()
            let final = formatter.number(from: txtWeightGoal.text ?? "0")?.description ?? "0"
            profileModel.weightGoal = final
            self.selectedWeightGoalOriginal = (self.txtWeightGoal.text ?? "")
            self.txtWeightGoal.text = (self.txtWeightGoal.text ?? "") + " " + self.weightUnitKey.localized
        }else{
            profileModel.weightGoal =  ""
            self.selectedWeightGoalOriginal =  ""
        }
    }
    
    func validateInput() -> Bool{
    if txtAge.text?.trimmed() == ""{
        CommonFunctions.showToastWithMessage(LocalizedString.enterAgeEmpty.localized)
        return false
    }
    
    if profileModel.age == 0{
        CommonFunctions.showToastWithMessage(LocalizedString.enterAge.localized)
        return false
    }
    if txtHeight.text?.trimmed() == ""{
        CommonFunctions.showToastWithMessage(LocalizedString.enterHeight.localized)
        return false
    }
    if ((Double(selectedHeightInCm)?.toIntValue() ?? 0) < 122 || (Double(selectedHeightInCm) ?? 0) > 302) && heightUnit == HeightUnit.cm.rawValue {
        CommonFunctions.showToastWithMessage(LocalizedString.enterValidHeight.localized)
        return false
    }
    if profileModel.weight == ""{
        CommonFunctions.showToastWithMessage(LocalizedString.enterWeight.localized)
        return false
    }
    if ((Double(profileModel.weight)?.toIntValue() ?? 0) < 20 || (Double(profileModel.weight) ?? 0) > 300.0) && weightUnit == WeightUnit.kg.rawValue {
        CommonFunctions.showToastWithMessage(LocalizedString.enterValidWeightKg.localized)
        return false
    }
    if ((Double(profileModel.weight)?.toIntValue() ?? 0) < 44 || (Double(profileModel.weight) ?? 0) > 661.0) && weightUnit != WeightUnit.kg.rawValue {
        CommonFunctions.showToastWithMessage(LocalizedString.enterValidWeightLbs.localized)
        return false
    }
    
    if profileModel.goal != .beActive{
        if  profileModel.weightGoal == ""{
            CommonFunctions.showToastWithMessage(LocalizedString.enterWeightGoal.localized)
            return false
            
        }
        if ((Double(profileModel.weightGoal)?.toIntValue() ?? 0) < 20 || (Double(profileModel.weightGoal) ?? 0) > 300.0) && weightUnit == WeightUnit.kg.rawValue {
            CommonFunctions.showToastWithMessage(LocalizedString.enterValidWeightKgGoal.localized)
            return false
        }
        if ((Double(profileModel.weightGoal)?.toIntValue() ?? 0) < 44 || (Double(profileModel.weightGoal) ?? 0) > 661.0) && weightUnit != WeightUnit.kg.rawValue {
            CommonFunctions.showToastWithMessage(LocalizedString.enterValidWeightLbsGoal.localized)
            return false
        }
    }
    
    return true
        
    }
}

extension SecondStepVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        let formatter: NumberFormatter = NumberFormatter()
        let final = formatter.number(from: newText)?.description ?? "0"
        let isNumeric = newText.isEmpty || (Double(final) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
}

extension SecondStepVC {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtHeight{
            self.txtHeight.placeholder = LocalizedString.yourHeight.localized
            heightEntered()
        }else if textField == txtWeight{
            self.txtWeight.placeholder = LocalizedString.yourWeight.localized
            weightEntered()
        }else if textField == txtWeightGoal{
            self.txtWeightGoal.placeholder = LocalizedString.yourWeightGoal.localized
            weightGoalEntered()
        }else if textField == txtWeight{
            self.txtWeight.placeholder = LocalizedString.yourWeight.localized
            weightEntered()
        }else if textField == txtWeightGoal{
            self.txtWeightGoal.placeholder = LocalizedString.yourWeightGoal.localized
            weightGoalEntered()
        }
        else if textField == txtAge{
            if textField.text?.trimmed() == "" {
                self.txtAge.text = ""
                self.txtAge.placeholder = LocalizedString.yourAge.localized
                
            }else{
                let formatter: NumberFormatter = NumberFormatter()
                formatter.locale = Locale(identifier: "EN")
                let final = formatter.number(from: textField.text ?? "0")?.description ?? "0"
                self.ageOriginal = (self.txtAge.text ?? "0")
                profileModel.age = Int(final) ?? 0
                self.txtAge.text = (self.txtAge.text ?? "0") + LocalizedString.yearsOld.localized
            }
        }
        else {
            return
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtWeight{
            textField.text = self.selectedWeightOriginal
        } else if textField === txtWeightGoal{
            textField.text = self.selectedWeightGoalOriginal
        }
        return true

    }
}
