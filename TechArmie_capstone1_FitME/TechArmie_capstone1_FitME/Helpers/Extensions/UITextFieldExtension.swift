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
}
