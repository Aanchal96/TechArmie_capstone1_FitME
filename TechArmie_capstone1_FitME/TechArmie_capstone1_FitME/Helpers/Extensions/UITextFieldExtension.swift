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
}

//TextField Character limit
var __maxLengths = [UITextField: Int]()

extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}


extension String {
    func safelyLimitedTo(length n: Int)->String {
    let c = self
    if (c.count <= n) { return self }
    return String( Array(c).prefix(upTo: n) )
    }
}



extension UITextField{
    
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
    
    // STOP SPECIAL CHARACTERS
    //===========================
    func stopSpecialCharacters() {
        let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.@"
        let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered: String = (text!.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
        
        if text != filtered {
            text?.removeLast()
        }
    }
    // SET IMAGE TO LEFT VIEW
    //=========================
    func setImageToLeftView(img : UIImage, size: CGSize?) {
        
        self.leftViewMode = .always
        let leftImage = UIImageView(image: img)
        self.leftView = leftImage
        
        leftImage.contentMode = UIView.ContentMode.center
        if let imgSize = size {
            self.leftView?.frame.size = imgSize
        } else {
            self.leftView?.frame.size = CGSize(width: 50, height: self.frame.height)
        }
        leftImage.frame = self.leftView!.frame
    }
    
    // SET IMAGE TO RIGHT VIEW
    //=========================
    func setImageToRightView(img : UIImage, size: CGSize?) {
        
        self.rightViewMode = .always
        let rightImage = UIImageView(image: img)
        self.rightView = rightImage
        
        rightImage.contentMode = UIView.ContentMode.center
        if let imgSize = size {
            self.rightView?.frame.size = imgSize
        } else {
            self.rightView?.frame.size = CGSize(width: 20, height: self.frame.height)
        }
        rightImage.frame = self.rightView!.frame
    }
    
    // SET BUTTON TO RIGHT VIEW
    //=========================
    func setButtonToRightView(btn : UIButton, selectedImage : UIImage?, normalImage : UIImage?, size: CGSize?) {
        
        self.rightViewMode = .always
        self.rightView = btn
        
        btn.isSelected = false
        
        if let selectedImg = selectedImage { btn.setImage(selectedImg, for: .selected) }
        if let unselectedImg = normalImage { btn.setImage(unselectedImg, for: .normal) }
        if let btnSize = size {
            self.rightView?.frame.size = btnSize
        } else {
            self.rightView?.frame.size = CGSize(width: btn.intrinsicContentSize.width+10, height: self.frame.height)
        }
    }
    
    // SET VIEW TO RIGHT VIEW
    //=========================
    func setViewToRightView(view : UIView, size: CGSize?) {
        
        self.rightViewMode = .always
        self.rightView = view
        
        if let btnSize = size {
            self.rightView?.frame.size = btnSize
        } else {
            self.rightView?.frame.size = CGSize(width: view.intrinsicContentSize.width+10, height: self.frame.height)
        }
    }

    func setPlaceHolderColor(placeholder: String, color: UIColor){
        
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                        attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}

extension UITextField{
    
    func ReplacingCaracter(in range: NSRange, with replacement: String) -> String {
        return (self.text! as NSString).replacingCharacters(in: range, with: replacement)
    }
}
