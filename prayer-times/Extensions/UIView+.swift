//
//  UIView+.swift
//  Dinimiz İslam
//
//  Created by Emir Alkal on 26.04.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach {
            addSubview($0)
        }
    }
}
