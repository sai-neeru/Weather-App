//
//  GeocodingService.swift
//  Weather
//
//  Created by Sai Pavan Neerukonda on 6/5/23.
//  Copyright © 2023 Sai Pavan Neerukonda. All rights reserved.
//

import Foundation
import Alamofire

protocol GeocodingServiceProtocol {
    func getCoordinates(city: String?, zipCode: String?, completionHandler: @escaping (Result<Locations, WeatherError>) -> Void)
}

final class GeocodingService {
    static let shared: GeocodingService = GeocodingService()
    private init() { }
}

extension GeocodingService: GeocodingServiceProtocol {
    func getCoordinates(city: String?, zipCode: String?, completionHandler: @escaping (Result<Locations, WeatherError>) -> Void) {
        var api: GeocodingAPI?
        if let city = city, !city.isEmpty {
            api = GeocodingAPI.city(city )
        } else if let zipCode = zipCode, !zipCode.isEmpty {
            api = GeocodingAPI.city(zipCode)
        }
        guard let api = api else {
            completionHandler(.failure(.invalidParameters))
            return
        }
         NetworkServices.default.execute(api, model: Locations.self) { result in
            switch result {
            case .success(let value):
                completionHandler(.success(value))
            case .failure:
                completionHandler(.failure(.backendError))
            }
        }
    }
}
