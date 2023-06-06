//
//  HomeViewModel.swift
//  Weather
//
//  Created by Sai Pavan Neerukonda on 6/4/23.
//  Copyright © 2023 Sai Pavan Neerukonda. All rights reserved.
//

import Foundation
import Alamofire

// all hardcode strings can be moved to Constants file which already exsist as of now added URLS

class HomeViewModel {
    var searchLocation: Location?
    var searchResults: Locations = []
    var weather: WeatherResponse?
    var weatherImage: String? {
        guard let icon = weather?.weather.first?.icon else { return nil }
        return Constants.API.imageBasePath+icon+"@2x.png"
    }
    var weatherDescription: String? {
        guard let description = weather?.weather.first?.description else { return nil }
        return description
    }
    var name: String? {
        guard weather != nil else { return nil }
        guard let result = searchLocation else { return "Current Location"}
        return "\(result.name), \(result.state)"
    }
    var temperature: String? {
        guard let temperature = weather?.main.temp else { return nil }
        return String(temperature)
    }
    private let weatherService: WeatherServiceProtocol
    private let geoCodingService: GeocodingServiceProtocol
    private let lettersAndSpacesCharacterSet = CharacterSet.letters.union(.whitespaces).inverted
    
    init(weatherService: WeatherServiceProtocol = WeatherService.shared, geoCodingService: GeocodingServiceProtocol = GeocodingService.shared) {
        self.weatherService = weatherService
        self.geoCodingService = geoCodingService
    }
    
    func getWeather(lat: Double, lon: Double, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        weatherService.downloadWeatherData(lattitude: lat, longitude: lon) { [weak self] result in
            switch result {
            case .success(let value):
                self?.weather = value
                if let searchedLocation = self?.searchLocation {
                    self?.saveLocation(location: searchedLocation)
                }
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
                // Api failure error handling can be done showing alret or banner
            }
        }
    }
    
    
    //All the validations can be in sepereare class and pass to methods as parameters
    func getCoordinates(searchStr: String, completionHandler:@escaping (Result<Void, WeatherError>) -> Void) {
        var city = ""
        var zipCode = ""
        if(searchStr.rangeOfCharacter(from: lettersAndSpacesCharacterSet) == nil && searchStr.count >= 3) {
            city = searchStr
            if !searchStr.uppercased().contains(" US") {
                city.append(", US")
            }
            
        } else if(searchStr.contains("[0-9]+") && searchStr.count == 5) { // Zip Code
            zipCode = searchStr
        } else {
            // if validation fails can show error message on UI that validation failed
            completionHandler(.failure(WeatherError.invalidParameters))
        }
        geoCodingService.getCoordinates(city: city, zipCode: zipCode) { [weak self] result in
            switch result {
            case .success(let value):
                self?.searchResults = value
                completionHandler(.success(()))
            case .failure(let error):
                self?.searchResults = []
                completionHandler(.failure(error))
                // Api failure error handling can be done showing alret or banner
            }
        }
    }
    
    
    //for now saving to userdefaults can be saved to filesystem as object
    func saveLocation(location: Location) {
        PreferenceHandler.saveValue(location.lat, forKey: "lattitude")
        PreferenceHandler.saveValue(location.lon, forKey: "longittude")
        PreferenceHandler.saveValue(location.name, forKey: "name")
        
    }
    
    
}
