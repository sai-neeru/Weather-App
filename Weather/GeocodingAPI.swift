//
//  GeocodingAPI.swift
//  Weather
//
//  Created by Sai Pavan Neerukonda on 6/5/23.
//  Copyright © 2023 Sai Pavan Neerukonda. All rights reserved.
//

import Foundation
import Alamofire

enum GeocodingAPI {
    case city(String)
    case postalCode(String)
}

extension GeocodingAPI: URLRequestBuilder {
    var jsonObject: Any? {
        nil
    }
    
    var baseURL: URL {
        let url = Constants.API.geocodingBasePath
        guard let url = URL(string: url) else {
            fatalError("Base URL failed")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .city:
            return "direct"
        case .postalCode:
            return "zip"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .city(name):
            return ["q": name,
                    "limit": 5,
                    "appid": Constants.API.key
            ]
        case let .postalCode(value):
            return ["zip": value,
                    "appid": Constants.API.key
            ]
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
}
