//
//  UIStackView+.swift
//  PrayerTimes
//
//  Created by Emir Alkal on 13.04.2023.
//

import UIKit

extension UIStackView {
    
    convenience init(
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat? = nil,
        distribution: Distribution? = nil,
        arrangedSubviews: [UIView] = []
    ) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        if let spacing {
            self.spacing = spacing
        }
        if let distribution {
            self.distribution = distribution
        }
    }
    
    func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach {
            addArrangedSubview($0)
        }
    }
}
