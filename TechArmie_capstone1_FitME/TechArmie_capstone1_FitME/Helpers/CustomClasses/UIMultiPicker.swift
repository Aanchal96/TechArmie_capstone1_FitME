//
//  UIMultiPicker.swift
//  TechArmie_capstone1_FitME
//
//  Created by Bhautik Pethani on 2022-08-01.
//

import UIKit

class MultiPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    internal typealias PickerDone = (_ firstValue: String, _ secondValue: String , _ thirdValue: String, _ index : Int ) -> Void
    fileprivate var doneBlock : PickerDone!
    
    fileprivate var firstValueArray : [String]?
    fileprivate var secondValueArray = [String]()
    fileprivate var thirdValueArray = [String]()
    
    static var noOfComponent = 2
    static private var monthsArray: [String] {
    return ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    }
    static private var yearsArray: [String] {
      
        let yearString = Date().year ; let year = Int(yearString)
      
      var arr: [String] = []
      for i in year ..< (year + 10) {
        arr.append("\(i)")
      }
      return arr
    }
    
    class func openMultiPickerIn(_ textField: UITextField? ,
                                 firstComponentArray: [String],
                                 secondComponentArray: [String],
                                 firstComponent: String?,
                                 secondComponent: String?,
                                 titles: [String]?, doneBlock: @escaping PickerDone) {
        
        let picker = MultiPicker()
        picker.doneBlock = doneBlock
        
        picker.openPickerInTextField(textField,
                                     firstComponentArray: firstComponentArray,
                                     secondComponentArray: secondComponentArray,
                                     firstComponent: firstComponent,
                                     secondComponent: secondComponent)
        
        if titles != nil {
            
            let label = UILabel(frame: CGRect(x: 0,
                                              y: 0,
                                              width: UIScreen.main.bounds.size.width/2,
                                              height: 30))
            
            label.text = titles![0].uppercased()
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textAlignment = .center
            
            picker.addSubview(label)
            
            if MultiPicker.noOfComponent > 1 {
                
                let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width/2 ,
                                                  y: 0,
                                                  width: UIScreen.main.bounds.size.width/2,
                                                  height: 30))
                
                label.text = titles![1].uppercased()
                label.font = UIFont.boldSystemFont(ofSize: 18)
                label.textAlignment = .center
                
                picker.addSubview(label)
            } else {
                
                label.frame = CGRect(x: 0,
                                     y: 0,
                                     width: UIScreen.main.bounds.size.width,
                                     height: 30)
                
                label.textAlignment = NSTextAlignment.center
            }
        }
    }
    
    fileprivate func openPickerInTextField(_ textField: UITextField?,
                                       firstComponentArray: [String],
                                       secondComponentArray: [String],
                                       firstComponent: String?, secondComponent: String?) {
        
        firstValueArray  = firstComponentArray
        secondValueArray = secondComponentArray
        
        self.delegate = self
        self.dataSource = self
        
        
        let cancelButton = UIBarButtonItem(title: LocalizedString.cancel.localized,
                                           style: .plain,
                                           target: self,
                                           action: #selector(pickerCancelButtonTapped))
        
        cancelButton.tintColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                         target: self,
                                         action: #selector(pickerDoneButtonTapped))
        
        doneButton.tintColor = UIColor.black
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                          target: nil,
                                          action:nil)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let array = [cancelButton, spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        toolbar.backgroundColor = UIColor.lightText
        
        textField?.inputView = self
        textField?.inputAccessoryView = toolbar
        
        let index = self.firstValueArray?.index(where: {$0 == firstComponent })
        self.selectRow(index ?? 0, inComponent: 0, animated: true)
        
        if MultiPicker.noOfComponent > 1 {
            let index1 = self.secondValueArray.index(where: {$0 == secondComponent })
            self.selectRow(index1 ?? 0, inComponent: 1, animated: true)
        }
    }
    
    class func openMultiPickerIn(_ textField: UITextField? ,
                                 firstComponentArray: [String],
                                 secondComponentArray: [String],
                                 thirdComponentArray: [String],
                                 firstComponent: String?,
                                 secondComponent: String?,
                                 thirdComponent: String?,
                                 titles: [String]?, doneBlock: @escaping PickerDone) {
        
        let picker = MultiPicker()
        picker.doneBlock = doneBlock
        picker.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        picker.openPickerInTextField(textField,
                                     firstComponentArray: firstComponentArray,
                                     secondComponentArray: secondComponentArray,
                                     thirdComponentArray: thirdComponentArray,
                                     firstComponent: firstComponent,
                                     secondComponent: secondComponent,
                                     thirdComponent: thirdComponent)
        
        if titles != nil {
            
            let label = UILabel(frame: CGRect(x: 0,
                                              y: 0,
                                              width: UIScreen.main.bounds.size.width/2,
                                              height: 30))
            
            label.text = titles![0].uppercased()
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textAlignment = .center
            
            picker.addSubview(label)
            
            if MultiPicker.noOfComponent > 1 {
                
                let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width/2 ,
                                                  y: 0,
                                                  width: UIScreen.main.bounds.size.width/2,
                                                  height: 30))
                
                label.text = titles![1].uppercased()
                label.font = UIFont.boldSystemFont(ofSize: 18)
                label.textAlignment = .center
                
                picker.addSubview(label)
            } else if MultiPicker.noOfComponent > 2 {
                
                let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width/2 ,
                y: 0,
                width: UIScreen.main.bounds.size.width/2,
                height: 30))
                label.font = UIFont.boldSystemFont(ofSize: 18)
                label.textAlignment = .center
                picker.addSubview(label)
                
            } else {
                
                label.frame = CGRect(x: 0,
                                     y: 0,
                                     width: UIScreen.main.bounds.size.width,
                                     height: 30)
                
                label.textAlignment = NSTextAlignment.center
            }
        }
    }
      
    fileprivate func openPickerInTextField(_ textField: UITextField?,
                                       firstComponentArray: [String],
                                       secondComponentArray: [String],
                                       thirdComponentArray: [String],
                                       firstComponent: String?, secondComponent: String?, thirdComponent: String?) {
        
        firstValueArray  = firstComponentArray
        secondValueArray = secondComponentArray
        thirdValueArray = thirdComponentArray
        
        self.delegate = self
        self.dataSource = self
        
        let cancelButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icDeleteBlack"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(pickerCancelButtonTapped))
        
        cancelButton.tintColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                         target: self,
                                         action: #selector(pickerDoneButtonTapped))
        
        doneButton.tintColor = UIColor.black
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                          target: nil,
                                          action:nil)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.height = 56
        let array = [cancelButton, spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        toolbar.backgroundColor = #colorLiteral(red: 0.5294117647, green: 0.5294117647, blue: 0.5294117647, alpha: 1)
        toolbar.clipsToBounds = true
//        toolbar.setUnderline(border: .top, weight: 2.0, color: .white)
        toolbar.setUnderline(border: .bottom, weight: 1.0, color: #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1))

        textField?.inputView = self
        textField?.inputAccessoryView = toolbar
        
        let index = self.firstValueArray?.index(where: {$0 == firstComponent })
        self.selectRow(index ?? 0, inComponent: 0, animated: true)
        
        if MultiPicker.noOfComponent > 1 {
            let index = self.secondValueArray.index(where: {$0 == secondComponent })
            self.selectRow(index ?? 1, inComponent: 1, animated: true)
        }
        
        if MultiPicker.noOfComponent > 2 {
            let index = self.thirdValueArray.index(where: {$0 == thirdComponent })
            self.selectRow(index ?? 0, inComponent: 2, animated: true)
        }
    }
    
    class  func openMonthAndYearPicker(_ textField: UITextField? ,
                                        firstComponentArray: [String] = MultiPicker.monthsArray,
                                        secondComponentArray: [String] = MultiPicker.yearsArray,
                                        firstComponent: String? = Date().month.description,
                                        secondComponent: String?,
                                        titles: [String]?, doneBlock: @escaping PickerDone) {
        
        let picker = MultiPicker()
        picker.doneBlock = doneBlock
        
        picker.openPickerInTextField(textField,
                                     firstComponentArray: firstComponentArray,
                                     secondComponentArray: secondComponentArray,
                                     firstComponent: firstComponent,
                                     secondComponent: secondComponent)
        
        if titles != nil {
          
          let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width/4 - 10,
                                            y: 0,
                                            width: 100,
                                            height: 30))
          
          label.text = titles![0].uppercased()
          label.font = UIFont.boldSystemFont(ofSize: 18)
          
          picker.addSubview(label)
          
          if MultiPicker.noOfComponent > 1 {
            
            let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width * 3/4 - 50,
                                              y: 0,
                                              width: 100,
                                              height: 30))
            
            label.text = titles![1].uppercased()
            label.font = UIFont.boldSystemFont(ofSize: 18)
            
            picker.addSubview(label)
          } else {
            
            label.frame = CGRect(x: 0,
                                 y: 0,
                                 width: UIScreen.main.bounds.size.width,
                                 height: 30)
            
            label.textAlignment = NSTextAlignment.center
          }
        }
      }
    
    @IBAction fileprivate func pickerCancelButtonTapped(){
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    @IBAction fileprivate func pickerDoneButtonTapped(){
        
        UIApplication.shared.keyWindow?.endEditing(true)
        
        let index1 : Int?
        let firstValue : String?
        index1 = self.selectedRow(inComponent: 0)
        
        if firstValueArray?.count == 0{return}
        else{firstValue = firstValueArray?[index1!]}
        
        var index2 :Int!
        var secondValue: String!
        
        var index3 :Int!
        var thirdValue: String!
        
        if MultiPicker.noOfComponent > 1 {
            index2 = self.selectedRow(inComponent: 1)
            secondValue = secondValueArray[index2]
        }
        
        if MultiPicker.noOfComponent > 2 {
            index3 = self.selectedRow(inComponent: 2)
            thirdValue = thirdValueArray[index3]
        }
        if  MultiPicker.noOfComponent == 1{
            self.doneBlock(firstValue!, secondValue ?? "" , thirdValue ?? "" , index1 ?? 0)

        }else{
            self.doneBlock(firstValue!, secondValue ?? "" , thirdValue ?? "" , index3 ?? 0)

        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return firstValueArray!.count
        } else if component == 1 {
            return secondValueArray.count
        }
        return thirdValueArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return MultiPicker.noOfComponent
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
            
        case 0:
            return firstValueArray?[row]
        case 1:
            return secondValueArray[row]
        case 2:
            return thirdValueArray[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {

        switch component {

        case 0:
            return MultiPicker.noOfComponent == 1 ? UIDevice.width :65
        case 1:
            return 65
        case 2:
            return 235
        default:
            return 0.0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if MultiPicker.noOfComponent == 3 {
            if pickerView.selectedRow(inComponent: 0) == 0 && pickerView.selectedRow(inComponent: 1) == 0{
                
                if component == 0 {
                    pickerView.selectRow(1, inComponent: 0, animated: false)
                } else if component == 1 {
                    pickerView.selectRow(1, inComponent: 1, animated: false)
                }
            }
        }
    }
}

class DatePicker: UIDatePicker {
    
    internal typealias PickerDone = (_ selection: String,_ date:Date) -> Void
    fileprivate var doneBlock: PickerDone!
    fileprivate var datePickerFormat: String = ""
    
    fileprivate var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.datePickerFormat
        return dateFormatter
    }
    
    
    class func openDatePickerIn(_ textField: UITextField?,
                                outPutFormate: String,
                                mode: UIDatePicker.Mode,
                                minimumDate: Date? = nil,
                                maximumDate: Date? = nil,
                                minuteInterval: Int = 1,
                                selectedDate: Date?, doneBlock: @escaping PickerDone) {
        
        let picker = DatePicker()
        picker.doneBlock = doneBlock
        picker.datePickerFormat = outPutFormate
        picker.datePickerMode = mode
        picker.dateFormatter.dateFormat = outPutFormate
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        
        if let sDate = selectedDate {
            picker.setDate(sDate, animated: false)
        }
        picker.minuteInterval = minuteInterval
        
        if mode == .time {
            
            if let sDate = selectedDate, let minDate = minimumDate {
                
                let calendar = Calendar.current
                let startOfSelectedDate = calendar.startOfDay(for: sDate)
                let startOfCurrentDate = calendar.startOfDay(for: minDate)
                
                if startOfSelectedDate == startOfCurrentDate {
                    picker.minimumDate = minDate
                    
                    if let maxDate = maximumDate {
                        picker.maximumDate = maxDate
                    }
                }
            }
        } else {
            picker.minimumDate = minimumDate
            picker.maximumDate = maximumDate
        }
        
        picker.openDatePickerInTextField(textField)
    }
    
    fileprivate func openDatePickerInTextField(_ textField: UITextField?) {
        
        if let text = textField?.text, !text.isEmpty, let selDate = self.dateFormatter.date(from: text) {
            self.setDate(selDate, animated: false)
        }
        
        self.addTarget(self, action: #selector(DatePicker.datePickerChanged(_:)), for: UIControl.Event.valueChanged)
        
        let cancelButton = UIBarButtonItem(title: LocalizedString.cancel.localized,
                                           style: .plain,
                                           target: self,
                                           action: #selector(pickerCancelButtonTapped))
        
        cancelButton.tintColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                         target: self,
                                         action: #selector(pickerDoneButtonTapped))
        
        doneButton.tintColor = UIColor.black
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                          target: nil,
                                          action:nil)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let array = [cancelButton, spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        toolbar.backgroundColor = UIColor.lightText
        
        textField?.inputView = self
        textField?.inputAccessoryView = toolbar
    }
   
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
   
    }
    
    @IBAction fileprivate func pickerCancelButtonTapped(){
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    @IBAction fileprivate func pickerDoneButtonTapped(){
        UIApplication.shared.keyWindow?.endEditing(true)
        let selected = self.dateFormatter.string(from: self.date)
        self.doneBlock(selected,self.date)
    }

}

