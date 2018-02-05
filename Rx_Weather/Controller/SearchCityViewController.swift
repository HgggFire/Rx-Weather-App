//
//  SearchCityViewController.swift
//  Rx_Weather
//
//  Created by LinChico on 2/5/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit
import Moya
import Moya_ModelMapper
import RxCocoa
import RxSwift
import MapKit

class SearchCityViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationTable: UITableView!
    var weatherImageName: String!
    
    var matchedLocations: Variable<[MKMapItem]> = Variable([])
    let dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationTable.tableFooterView = UIView()
        backgroundImageView.image = UIImage(named: weatherImageName)
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        setupRx()
    }
    
    func setupRx() {
        // setup searchBar
        searchBar.rx.text.subscribe(onNext: { element in
            guard let searchBarText = element else { return }
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = searchBarText
            let search = MKLocalSearch(request: request)
            
            search.start { (response, error) in
                if error == nil && response != nil {
                    self.matchedLocations.value = response!.mapItems
                }
            }
        }).disposed(by: dispose)
        
        searchBar.rx.cancelButtonClicked.subscribe { (event) in
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: dispose)
        
        // setup table content according to mapItem list
        matchedLocations.asObservable().bind(to: locationTable.rx.items(cellIdentifier: "locationCell", cellType: UITableViewCell.self)){ (row, data, cell) in
            
                let placemark = data.placemark
                if let state = placemark.administrativeArea, let city = placemark.locality, let country = placemark.country, let name = placemark.name {
                    cell.textLabel?.text = city + ", " + state + ", " + country + ", " + name
                }
            }.disposed(by: dispose)
        
        // setup table selected -> update location coordinate
        locationTable.rx.itemSelected.subscribe({item in
            if self.searchBar.isFirstResponder {
                self.view.endEditing(true)
            }
            let coord = self.matchedLocations.value[item.element!.row].placemark.coordinate
            Constants.lat = coord.latitude
            Constants.lon = coord.longitude
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: dispose)
    }
    
}
