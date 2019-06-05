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
        let path = [
            "lat": String(lat),
            "lon": String(long),
            "APPID": "297d9dee175272ae68b2c1006f35d7a1",
            "units": "imperial"
        ]

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = path.compactMap({ URLQueryItem(name: $0, value: $1 )})
        
        guard let url = components.url else {
            DispatchQueue.main.async {
                completion(.failure(WeatherServiceError.badURL))
            }
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
                    DispatchQueue.main.async {
                        completion(.success(weather))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        session.resume()
        
    }
}
