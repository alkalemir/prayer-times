//
//  PlaceModel.swift
//  NetworkManager
//
//  Created by Emir Alkal on 19.05.2023.
//

import Foundation

struct PlaceModel: Decodable {
    let countryCode: String
    let country: String
    let region: String
    let city: String
    let latitude: Double
    let longitude: Double
}
