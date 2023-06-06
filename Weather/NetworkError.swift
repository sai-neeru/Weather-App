//
//  NetworkError.swift
//  Weather
//
//  Created by Sai Pavan Neerukonda on 6/5/23.
//  Copyright © 2023 Sai Pavan Neerukonda. All rights reserved.
//

import Foundation
import Alamofire

enum WeatherError: Error {
    case invalidParameters
    case invalidSearch
    case backendError
}
