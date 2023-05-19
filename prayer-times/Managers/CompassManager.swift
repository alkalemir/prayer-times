//
//  CompassManager.swift
//  PrayerTimes
//
//  Created by Emir Alkal on 16.04.2023.
//

import UIKit
import CoreLocation

final class CompassDirectionManager: NSObject , CLLocationManagerDelegate{
    
    var dialerImageView : UIImageView!
    var pointerImageView : UIImageView!
    weak var delegate: CompassDirectionManagerDelegate?
    private var latOfOrigin = 21.4225
    private var lngOfOrigin = 39.8262
    
    private var location: CLLocation?
    
    private let locationManager = CLLocationManager()
    
    var bearingOfKabah = Double()
    
    init(dialerImageView : UIImageView , pointerImageView : UIImageView) {
        self.dialerImageView = dialerImageView
        self.pointerImageView = pointerImageView
    }
    
    
    func initManager(){
        locationManager.requestWhenInUseAuthorization()
        let queue = DispatchQueue.global(qos: .userInteractive)
        queue.async {
            if CLLocationManager.locationServicesEnabled() {
                
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
                self.locationManager.startUpdatingHeading()
                
            }
        }
    }
    
    func setOrigin(lat : Double , lng : Double){
        self.latOfOrigin = lat
        self.lngOfOrigin = lng
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        
        
        let north = -1 * heading.magneticHeading * Double.pi/180
        
        let directionOfKabah = bearingOfKabah * Double.pi/180 + north
        
        dialerImageView.transform =     CGAffineTransform(rotationAngle: CGFloat(north));
        
        pointerImageView.transform =       CGAffineTransform(rotationAngle: CGFloat(directionOfKabah));
        
        delegate?.didGetAccuracy(accuracy: directionOfKabah)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations.last!
        
        location = newLocation
        
        bearingOfKabah = getBearingBetweenTwoPoints1(location!, latitudeOfOrigin: self.latOfOrigin, longitudeOfOrigin: self.lngOfOrigin) //calculating the bearing of KABAH
    }
    
    
    private func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
    
    
    private  func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }
    
    private  func getBearingBetweenTwoPoints1(_ point1 : CLLocation, latitudeOfOrigin : Double , longitudeOfOrigin :Double) -> Double {
        
        let lat1 = degreesToRadians(point1.coordinate.latitude)
        let lon1 = degreesToRadians(point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(latitudeOfOrigin);
        let lon2 = degreesToRadians(longitudeOfOrigin);
        
        let dLon = lon2 - lon1;
        
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        var radiansBearing = atan2(y, x);
        if(radiansBearing < 0.0){
            
            radiansBearing += 2 * Double.pi;
            
        }
        
        return radiansToDegrees(radiansBearing)
    }
}

protocol CompassDirectionManagerDelegate: AnyObject {
    func didGetAccuracy(accuracy: Double)
}

