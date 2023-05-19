//
//  UILabel+.swift
//  Dinimiz İslam
//
//  Created by Emir Alkal on 26.04.2023.
//

import UIKit

extension UILabel {
    convenience init(text: String? = nil, textColor: UIColor? = nil, font: UIFont? = nil) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
    }
    
    convenience init(font: UIFont, textColor: UIColor) {
        self.init()
        self.font = font
        self.textColor = textColor
    }
}
