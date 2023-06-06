//
//  Weather.swift
//  Weather
//
//  Created by Sai Pavan Neerukonda on 6/5/23.
//  Copyright © 2023 Sai Pavan Neerukonda. All rights reserved.
//

import Foundation

typealias Locations = [Location]

struct Location: Codable {
    var lat: Double
    var lon: Double
    let country: String
    let state: String
    let name: String

}

struct WeatherResponse: Codable {
    struct TemperatureData: Codable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
        let humidity: Int
    }
    struct WeatherData: Codable {
        let description: String
        let icon: String
    }
    struct Coord: Codable {
        let lon, lat: Double
    }
    let coord: Coord
    let main: TemperatureData
    let weather: [WeatherData]
    let name: String
}
