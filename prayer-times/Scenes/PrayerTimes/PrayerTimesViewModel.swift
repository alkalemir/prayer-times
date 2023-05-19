//
//  PrayerTimesViewModel.swift
//  prayer-times
//
//  Created by Emir Alkal on 19.05.2023.
//

import Foundation
import NetworkManager
import CoreLocation

final class PrayerTimesViewModel: NSObject {
    private let networkManager = NetworkManager.shared
    private let locationManager = CLLocationManager()
    private var firstTimeCalled = false
    private var secondTimeCalled = false
    
    weak var delegate: PrayerTimesDelegate? {
        didSet {
            guard delegate != nil else { return }
            locationManager.delegate = self
            checkLocationStatus()
        }
    }
    
    private func checkLocationStatus() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self else { return }
            
            if CLLocationManager.locationServicesEnabled() {
                switch self.locationManager.authorizationStatus {
                    case .notDetermined:
                        DispatchQueue.main.async {
                            self.delegate?.requestLocation()
                        }
                    case .restricted, .denied:
                        DispatchQueue.main.async {
                            self.delegate?.showUserHowToChangeLocationAuth()
                        }
                    case .authorizedAlways, .authorizedWhenInUse:
                        locationManager.startUpdatingLocation()
                    @unknown default:
                        break
                }
            } else {
                print("Location services are not enabled")
            }
        }
    }
    
    public func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension PrayerTimesViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !firstTimeCalled else { return }
        firstTimeCalled = true
        guard let lastLocation = locations.last else { return }
        
        print(locations.last!.coordinate.latitude, locations.last!.coordinate.longitude)
        networkManager.fetchTimes(lat: lastLocation.coordinate.latitude, lon: lastLocation.coordinate.longitude) { result in
            switch result {
            case .success(let prayerTimes):
                print(prayerTimes)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if secondTimeCalled {
            switch manager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                delegate?.locationRequestDeclined()
            case .authorizedAlways, .authorizedWhenInUse:
                delegate?.locationRequestAccepted()
                locationManager.startUpdatingLocation()
            @unknown default:
                print("unknown")
            }
        }
        secondTimeCalled = true
    }
}

protocol PrayerTimesDelegate: AnyObject {
    func requestLocation()
    func showUserHowToChangeLocationAuth()
    func showPrayerTimes(prayerTimes: PrayerTimesModel)
    func locationRequestAccepted()
    func locationRequestDeclined()
}
