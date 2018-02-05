//
//  ApiHandler.swift
//  Rx_Weather
//
//  Created by LinChico on 1/31/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire

enum ApiHandleError: Error {
    case dataIsNil
    case jsonParsingError
}

class ApiHandler {
    static let shared = ApiHandler()
    private init() {}
    
    func getForecastWeather(lat: Double, lon: Double, completion: @escaping (([ForecastWeather], String, String)?, Error?)->()) {
        let stringURL = "https://api.openweathermap.org/data/2.5/forecast?lat=\(Constants.lat)&lon=\(Constants.lon)&appid=\(Constants.appId)&units=metric"
        _ = json(.get, stringURL)
            .observeOn(MainScheduler.instance)
            .subscribe { event in
                if let dataDict = event.element as? [String: Any],
                    let cityDict = dataDict["city"] as? [String: Any],
                    let city = cityDict["name"] as? String,
                    let country = cityDict["country"] as? String,
                let list = dataDict["list"] as? [[String: Any]]
                {
                    var weatherObjects : [ForecastWeather] = []
                    
                    // use rx mappable
                    for dict in list {
                        if let weatherList = dict["weather"] as? [[String: Any]],
                            let weatherItem = weatherList[0] as? [String:Any],
                            let weatherName = weatherItem["main"] as? String,
                            var weatherDescription = weatherItem["description"] as? String,
                            let detailDict = dict["main"] as? [String: Any],
                            let temp = detailDict["temp"] as? Double,
                            let pressure = detailDict["pressure"] as? Double,
                            let humidity = detailDict["humidity"] as? Double,
                            let windDict = dict["wind"] as? [String: Any],
                            let windSpeed = windDict["speed"] as? Double,
                            let date = dict["dt_txt"] as? String
                        {
                            weatherDescription = weatherDescription.capitalizingFirstLetter()
                            let weather = ForecastWeather(weather: weatherName, temperature: temp, humidity: humidity, pressure: pressure, wind: windSpeed, description: weatherDescription, date: date, condition: ForecastWeather.Condition(rawValue: weatherDescription)!)
                            weatherObjects.append(weather)
                        }
                        completion((weatherObjects, city, country), nil)
                    }
                } else {
                    completion(nil, ApiHandleError.jsonParsingError)
                }
        }
        
    }
    
    
    func getCurrentWeather(lat: Double, lon: Double, completion: @escaping (Weather?, Error?)->()) {
        let stringURL = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(Constants.appId)"
        _ = json(.get, stringURL)
            .observeOn(MainScheduler.instance)
            .subscribe { event in
                if let dict = event.element as? [String: Any],
                    let weatherList = dict["weather"] as? [[String: Any]],
                    let weatherItem = weatherList[0] as? [String:Any],
                    let weatherName = weatherItem["main"] as? String,
                    var weatherDescription = weatherItem["description"] as? String,
                    let detailDict = dict["main"] as? [String: Any],
                    let temp = detailDict["temp"] as? Double,
                    let pressure = detailDict["pressure"] as? Double,
                    let humidity = detailDict["humidity"] as? Double,
                    let windDict = dict["wind"] as? [String: Any],
                    let windSpeed = windDict["speed"] as? Double,
                    let city = dict["name"] as? String,
                    let sys = dict["sys"] as? [String: Any],
                    let country = sys["country"] as? String{
                    
                    weatherDescription = weatherDescription.capitalizingFirstLetter()
                    let weather = Weather(weather: weatherName, temperature: temp, humidity: humidity, pressure: pressure, wind: windSpeed, description: weatherDescription, city: city, country: country, condition: Weather.Condition(rawValue: weatherDescription)!)
                    completion(weather, nil)
                } else {
                    completion(nil, ApiHandleError.jsonParsingError)
                }
        }
    }
        
}

