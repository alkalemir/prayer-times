//
//  UIViewController+.swift
//  prayer-times
//
//  Created by Emir Alkal on 19.05.2023.
//

import UIKit

extension UIViewController {
    func addChild(vc: UIViewController) {
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
    }
    
    func removeChild(vc: UIViewController) {
        vc.removeFromParent()
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
    }
}
