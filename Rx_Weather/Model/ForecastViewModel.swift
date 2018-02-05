//
//  ForecastViewModel.swift
//  Rx_Weather
//
//  Created by LinChico on 2/2/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import Foundation
import RxSwift

class ForecastWeatherViewModel {
    var forecastWeatherList: Variable<[ForecastWeather]> = Variable([])
    var city: Variable<String> = Variable("")
}
