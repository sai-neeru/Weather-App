//
//  WeatherAPI.swift
//  Weather
//
//  Created by Sai Pavan Neerukonda on 6/5/23.
//  Copyright © 2023 Sai Pavan Neerukonda. All rights reserved.
//

import Foundation
import Alamofire

enum WeatherAPI {
    case geoLocation(lat: Double, lon: Double)
}

extension WeatherAPI: URLRequestBuilder {
    var jsonObject: Any? {
        nil
    }
    
    var path: String {
        switch self {
        case .geoLocation:
            return "weather"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .geoLocation(lat, lon):
            return ["lat": lat,
                    "lon": lon,
                    "appid": Constants.API.key,
                    "units": "imperial"]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .geoLocation:
            return .get
        }
    }
}
