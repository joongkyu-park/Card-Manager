//
//  UITextField.swift
//  CardManager
//
//  Created by Apple on 2023/02/20.
//

import UIKit

extension UITextField {
    
    func addPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
    
}
