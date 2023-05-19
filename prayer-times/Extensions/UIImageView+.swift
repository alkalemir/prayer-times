//
//  UIImageView+.swift
//  PrayerTimes
//
//  Created by Emir Alkal on 13.04.2023.
//

import UIKit

extension UIImageView {
    convenience init(
        imageName: String,
        contenMode: UIView.ContentMode) {
            self.init(image: UIImage(named: imageName))
            self.contentMode = contenMode
    }
}
