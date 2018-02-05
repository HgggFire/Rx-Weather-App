//
//  Weather.swift
//  Rx_Weather
//
//  Created by LinChico on 2/1/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import RxSwift



class WeatherViewModel {
    var weather = Weather(weather: "", temperature: 273, humidity: 0, pressure: 0, wind: 0, description: "", city: "", country: "", condition:  Weather.Condition.Clear)
    
    init() {
        
    }
    
    init(weather: Weather) {
        self.weather = weather
    }
}



