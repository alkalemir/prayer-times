//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by Emir Alkal on 19.05.2023.
//

import Foundation

public class NetworkManager {
    public static let shared = NetworkManager()
    private init() {}
    
    private func makeUrl(lat: String, lon: String, date: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "namaz-vakti.vercel.app"
        urlComponents.path = "/api/timesFromCoordinates"
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "lng", value: lon),
            URLQueryItem(name: "date", value: date),
            URLQueryItem(name: "timezoneOffset", value: "180"),
            URLQueryItem(name: "days", value: "1")
        ]
        
        return urlComponents.url
    }
    
    private func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
    
    private func decodeFromJSON(data: Data) throws -> PrayerTimesModel {
        let decodedObj = try JSONDecoder().decode(ResponseModel.self, from: data)
        let jsonObj = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let timesArr = (jsonObj["times"]! as! [String: Any])[formattedDate()] as! [String]
        
        let prayerTimes = PrayerTimesModel(
            country: decodedObj.place.country,
            countryCode: decodedObj.place.countryCode,
            city: decodedObj.place.city,
            region: decodedObj.place.region,
            fajr: timesArr[0],
            sunrise: timesArr[1],
            dhuhr: timesArr[2],
            asr: timesArr[3],
            sunset: timesArr[4],
            isha: timesArr[5]
        )
        
        return prayerTimes
    }
    
    public func fetchTimes(lat: Double, lon: Double, completion: @escaping (Result<PrayerTimesModel, Error>) -> Void) {
        guard let url = makeUrl(lat: "\(lat)", lon: "\(lon)", date: formattedDate()) else {
            // todo
            return
        }
        
        let req = URLRequest(url: url)
        URLSession.shared.dataTask(with: req) { [weak self] data, response, error in
            guard let self else { return }
            guard error == nil else {
                // todo
                return
            }
            guard let data else {
                // todo
                return
            }
            
            do {
                try completion(.success(decodeFromJSON(data: data)))
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
}
