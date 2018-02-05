//
//  FutureWeatherViewController.swift
//  Rx_Weather
//
//  Created by LinChico on 2/1/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class FutureWeatherViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherTable: UITableView!
    var viewModel = ForecastWeatherViewModel()
    let dispose = DisposeBag()
    
    let schedular = SerialDispatchQueueScheduler(qos: .default)
    var interval: Disposable?
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weatherTable.tableFooterView = UIView()
        bindTableToViewModel()
        
        formatter.dateFormat = "HH:mm:ss, MMM dd"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backgroundImageView.image = UIImage(named: Constants.backgroundImageName)
        getForecastWeather()
        navigationController?.navigationBar.isHidden = true
        interval = Observable<Int>.interval(600, scheduler: schedular)
            .subscribe { _ in
                self.getForecastWeather()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        interval?.dispose()
        navigationController?.navigationBar.isHidden = false
        super.viewWillDisappear(animated)
    }
    
    func bindTableToViewModel() {
        viewModel.forecastWeatherList.asObservable().bind(to: weatherTable.rx.items(cellIdentifier: "weatherCell", cellType: WeatherCell.self)){ (row, data, cell) in
            cell.weatherModel = data
            }.disposed(by: dispose)
        
        viewModel.city.asObservable().subscribe(onNext: { (city) in
            self.cityLabel.text = city
        }).disposed(by: dispose)
    }

    func getForecastWeather() {
        ApiHandler.shared.getForecastWeather(lat: Constants.lat, lon: Constants.lon) { (result, err) in
            if err != nil {
                print(err!.localizedDescription)
            } else {
                let (weatherList, city, country) = result!
                self.viewModel.forecastWeatherList.value = weatherList
                self.viewModel.city.value = "\(city), \(country)"
                self.updateTimeLabel.text = "Last updated at " + self.formatter.string(from: Date())
            }
        }
    }
}
