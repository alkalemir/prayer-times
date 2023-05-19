//
//  PrayerTimesModel.swift
//  NetworkManager
//
//  Created by Emir Alkal on 19.05.2023.
//

import Foundation

public struct PrayerTimesModel: Decodable {
    public let country: String
    public let countryCode: String
    public let city: String
    public let region: String
    public let fajr: String
    public let sunrise: String
    public let dhuhr: String
    public let asr: String
    public let sunset: String
    public let isha: String
}
