//
//  WeatherService.swift
//  SimpleWeather
//
//  Created by Matt Sanford on 6/5/19.
//  Copyright © 2019 Matt Sanford. All rights reserved.
//

import Foundation

enum WeatherServiceError: Error {
    case badURL
}

struct WeatherService {
    func getCurrentWeather(lat: Double, long: Double, completion: @escaping (Result<Weather, Error>) -> Void) {
//        api.openweathermap.org/data/2.5/weather?lat=35&lon=139
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(long)),
            URLQueryItem(name: "APPID", value: "297d9dee175272ae68b2c1006f35d7a1")
        ]
        guard let url = components.url else {
            completion(.failure(WeatherServiceError.badURL))
            return
        }
        
        let session = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let weather = try JSONDecoder().decode(Weather.self, from: data)
                    completion(.success(weather))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        session.resume()
        
    }
}
