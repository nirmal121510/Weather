//
//  APIHandler.swift
//  Weather
//
//  Created by Nirmal's Macbook Pro on 29/04/22.
//

import Foundation
import UIKit

enum City: String {
    
    case chennai
    
    case bangalore
    
    case kolkata
    
    case unknown
    
}



struct APIHandler {
    
    static let imageCache = NSCache<NSString, AnyObject>()
    
    static let APIKey = "522db6a157a748e2996212343221502"

    static func localWeatherData(_ city: City) -> Data? {
        if let data = UserDefaults.standard.value(forKey: city.rawValue) as? Data {
            return data
        }
        return nil
    }
    
    static func fetchWeatherDetails(_ city: City, _ completion: @escaping ((Weather?, Error?) -> Void)) {
        if let data = localWeatherData(city) {
            do {
                let decoder = JSONDecoder()
                let weather = try decoder.decode(Weather.self, from: data)
                completion(weather, nil)
            } catch {
                completion(nil, Error(.parseError))
            }
            return
        }
        
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(APIKey)&q=\(city.rawValue)&days=7&aqi=no&alerts=no"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(nil, Error(.serverError))
            } else {
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        var weather = try decoder.decode(Weather.self, from: data)
                        var count = 0
                        for (index, forcast) in weather.forecast.forecastday.enumerated() {
                            loadImageUsingCache(withUrl: forcast.day.condition.icon, { (data, error) in
                                count += 1
                                if let data = data {
                                    var forcast = forcast
                                    forcast.day.condition.image = data
                                    weather.forecast.forecastday[index] = forcast
                                }
                                if count == weather.forecast.forecastday.count {
                                    let encoder = JSONEncoder()
                                    let encodedData = try? encoder.encode(weather)
                                    UserDefaults.standard.setValue(encodedData, forKey: city.rawValue)
                                    completion(weather, nil)
                                }
                            })
                        }
                    } else {
                        completion(nil, Error(.noData))
                    }
                } catch {
                    completion(nil, Error(.parseError))
                }
            }
        }.resume()
    }
    
    static func loadImageUsingCache(withUrl urlString : String, _ completion: @escaping ((Data?, Error?) -> Void)) {
        guard let url = URL(string: "https:" + urlString) else { return }
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            completion(cachedImage.pngData(), nil)
            return
        }
        
        // if not, download image from url
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    completion(nil, Error(.serverError))
                } else {
                    if let data = data, data.count > 0 {
                        if let image = UIImage(data: data) {
                            imageCache.setObject(image, forKey: urlString as NSString)
                        }
                        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
                            completion(cachedImage.pngData(), nil)
                        }
                    } else {
                        completion(nil, Error(.noData))
                    }
                }
            }
        }.resume()
    }

}
