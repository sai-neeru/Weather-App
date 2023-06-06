//
//  NetworkServiceProtocol.swift
//  Weather
//
//  Created by Sai Pavan Neerukonda on 6/5/23.
//  Copyright © 2023 Sai Pavan Neerukonda. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func execute<T: Codable>(_ urlRequest: URLRequestBuilder, model: T.Type, completionHandler:  @escaping (Result<T, Error>) -> Void)
}

extension NetworkServiceProtocol {
    func execute<T: Decodable>(_ urlRequest: URLRequestBuilder, model: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        AF.request(urlRequest).validate().responseDecodable(of: T.self) { response in
            print(response.debugDescription)
            switch response.result {
            case .success(let value):
                completionHandler(.success(value))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

class NetworkServices: NetworkServiceProtocol {    let retryLimit = 0
    public static let `default`: NetworkServiceProtocol = {
        var service = NetworkServices()
        return service
    }()
}
                                                        
