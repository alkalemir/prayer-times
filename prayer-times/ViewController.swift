//
//  ViewController.swift
//  prayer-times
//
//  Created by Emir Alkal on 19.05.2023.
//

import UIKit
import NetworkManager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.fetchTimes(lat: 13, lon: 12) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }


}

