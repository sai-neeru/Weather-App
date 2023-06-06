//
//  WeatherManager.swift
//  Weather
//
//  Created by Sai Pavan Neerukonda on 6/5/23.
//  Copyright © 2023 Sai Pavan Neerukonda. All rights reserved.
//

import Foundation
import Alamofire

protocol WeatherServiceProtocol {
    func downloadWeatherData(lattitude: Double, longitude: Double, completionHandler: @escaping (Result<WeatherResponse, Error>) -> Void)
}

final class WeatherService {
    static let shared: WeatherService = WeatherService()
    private init() { }
}

extension WeatherService: WeatherServiceProtocol {
    func downloadWeatherData(lattitude: Double, longitude: Double, completionHandler: @escaping (Result<WeatherResponse, Error>) -> Void) {
        NetworkServices.default.execute(WeatherAPI.geoLocation(lat: lattitude, lon: longitude), model: WeatherResponse.self, completionHandler: { result in
            switch result {
            case .success(let value):
                completionHandler(.success(value))
            case .failure(let error):
                completionHandler(.failure(error))
            }
            
        })
    }
                
}
