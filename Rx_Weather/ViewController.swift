//
//  ViewController.swift
//  Rx_Weather
//
//  Created by LinChico on 1/31/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CurrentWeatherViewController: UIViewController {
    
    var viewModel: Variable<WeatherViewModel> = Variable(WeatherViewModel())
    
    
    let disposeBag = DisposeBag()

    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    let schedular = SerialDispatchQueueScheduler(qos: .default)
    var interval: Disposable?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupObserve()
        getWeatherViewModelFromApi()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interval = Observable<Int>.interval(3, scheduler: schedular)
            .subscribe { _ in
                self.getWeatherViewModelFromApi()
            }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        interval?.dispose()
        super.viewWillDisappear(animated)
    }
    
    
    
    func setupObserve() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss, MMM dd"
        
        viewModel.asObservable().subscribe(onNext: { (element) in
            
            self.windLabel.text = String(format: "%.0f mps", element.weather.wind)
            self.humidityLabel.text = String(format: "%.0f %%", element.weather.humidity)
            self.pressureLabel.text = String(format: "%.0f hPa", element.weather.pressure)
            self.descriptionLabel.text = element.weather.description
            self.temperatureLabel.text = String(format: "%.0f°", element.weather.temperature - 273)
            self.locationLabel.text = "\(element.weather.city), \(element.weather.country)"
            self.updateTimeLabel.text = "Last updated at\n" + formatter.string(from: Date())
            
        }).disposed(by: disposeBag)
        
    }
    
    func getWeatherViewModelFromApi() {
        ApiHandler.shared.getCurrentWeather(lat: Constants.lat, lon: Constants.lon) { (weather, err) in
            if err != nil {
                print(err!)
            } else {
                self.viewModel.value = WeatherViewModel(weather: weather!)
            }
        }
    }
}

