//
//  PrayerTimesModel.swift
//  NetworkManager
//
//  Created by Emir Alkal on 19.05.2023.
//

import Foundation

public struct PrayerTimesModel: Decodable {
    let country: String
    let countryCode: String
    let city: String
    let region: String
    
    let fajr: String
    let sunrise: String
    let dhuhr: String
    let asr: String
    let sunset: String
    let isha: String
}
