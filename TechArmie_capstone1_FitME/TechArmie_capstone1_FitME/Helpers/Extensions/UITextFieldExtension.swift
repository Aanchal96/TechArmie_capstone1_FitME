//
//  UITextFieldExtension.swift
//  TechArmie_capstone1_FitME
//
//  Created by Bhautik Pethani on 2022-07-22.
//

import Foundation
import UIKit

extension UITextField {
    
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width-39, height: 1)
        bottomLine.backgroundColor = CustomColors.secondaryColor.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    open override func draw(_ rect: CGRect) {
        self.autocorrectionType = .no
    }
    
    ///Sets and gets if the textfield has secure text entry
    var isSecureText:Bool{
        get{
            return self.isSecureTextEntry
        }
        set{
            let font = self.font
            self.isSecureTextEntry = newValue
            if let text = self.text{
                self.text = ""
                self.text = text
            }
            self.font = nil
            self.font = font
            self.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        }
    }
}
