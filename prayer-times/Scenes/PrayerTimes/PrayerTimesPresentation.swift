//
//  PrayerTimesPresentation.swift
//  prayer-times
//
//  Created by Emir Alkal on 19.05.2023.
//

import NetworkManager
import Foundation

struct PrayerTimesPresentation {
    let city: String
    let nextTime: String
    let remainingTime: Int
    let date: String
    let currentTime: Int
    let times: [String]
}

extension PrayerTimesModel {
    func toPresentation(date: Date) -> PrayerTimesPresentation {
        let intervals = [
            stringToTimeInterval(prayerTime: fajr),
            stringToTimeInterval(prayerTime: sunrise),
            stringToTimeInterval(prayerTime: dhuhr),
            stringToTimeInterval(prayerTime: asr),
            stringToTimeInterval(prayerTime: sunset),
            stringToTimeInterval(prayerTime: isha),
        ]
        
        let currentHour = Calendar.current.component(.hour, from: date)
        let currentMinute = Calendar.current.component(.minute, from: date)
        let currentSecond = Calendar.current.component(.second, from: date)
        let currentInterval = currentHour * 3600 + currentMinute * 60 + currentSecond
        print(currentHour, currentMinute, currentSecond)
        let nextTime: String
        let currentTime: Int
        let remainingTime: Int
        
        if currentInterval < intervals[0] {
            nextTime = "Fajr"
            currentTime = 5
            remainingTime = intervals[0] - currentInterval
        } else if currentInterval < intervals[1] {
            nextTime = "Sunrise"
            currentTime = 0
            remainingTime = intervals[1] - currentInterval
        } else if currentInterval < intervals[2] {
            nextTime = "Dhuhr"
            currentTime = 1
            remainingTime = intervals[2] - currentInterval
        } else if currentInterval < intervals[3] {
            nextTime = "Asr"
            currentTime = 2
            remainingTime = intervals[3] - currentInterval
        } else if currentInterval < intervals[4] {
            nextTime = "Sunset"
            currentTime = 3
            remainingTime = intervals[4] - currentInterval
        } else if currentInterval < intervals[5] {
            nextTime = "Isha"
            currentTime = 4
            remainingTime = intervals[5] - currentInterval
        } else {
            nextTime = "Fajr"
            currentTime = 5
            remainingTime = intervals[0] + (3600 * 24 - intervals[5])
        }
        
        let times = [fajr, sunrise, dhuhr, asr, sunset, isha]
        
        return .init(
            city: city,
            nextTime: nextTime,
            remainingTime: remainingTime,
            date: formattedDate(date: date),
            currentTime: currentTime,
            times: times
        )
    }
    
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy, E"
        return dateFormatter.string(from: date)
    }
    
    func stringToTimeInterval(prayerTime: String) -> Int {
        let hourMinute = prayerTime.components(separatedBy: ":")
        let hour = Int(hourMinute[0])!
        let minute = Int(hourMinute[1])!
        
        return hour * 3600 + minute * 60
    }
}
