//
//  QiblaFinderController.swift
//  PrayerTimes
//
//  Created by Emir Alkal on 13.04.2023.
//

import UIKit
import CoreLocation

final class QiblaFinderController: UIViewController {

    private let compassView = UIImageView(imageName: "compass", contenMode: .scaleAspectFit)
    private let mosqueView = UIImageView(imageName: "mosque 1", contenMode: .scaleAspectFit)
    private let layerImageView = UIImageView(imageName: "layer", contenMode: .scaleAspectFit)
    var compassManager: CompassDirectionManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(named: "background")
        view.addSubviews(compassView, mosqueView, layerImageView)
        
        compassView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(70)
        }
        
        mosqueView.snp.makeConstraints { make in
            make.bottom.equalTo(compassView.snp.top).offset(-64)
            make.centerX.equalToSuperview()
        }
        
        layerImageView.snp.makeConstraints { make in
            make.center.equalTo(mosqueView.snp.center)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch CLLocationManager().authorizationStatus {
        case .restricted, .denied, .notDetermined:
            print("test")
        case .authorizedAlways, .authorizedWhenInUse:
            compassManager =  CompassDirectionManager(dialerImageView: compassView, pointerImageView: compassView)
            compassManager.delegate = self
            compassManager.initManager()
        @unknown default:
            fatalError()
        }
    }
}

extension QiblaFinderController: CompassDirectionManagerDelegate {
    func didGetAccuracy(accuracy: Double) {
        let x = abs(accuracy)
        if x < 0.3 {
            layerImageView.isHidden = false
        } else {
            layerImageView.isHidden = true
        }
    }
}
