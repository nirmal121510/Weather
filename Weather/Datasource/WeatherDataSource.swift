//
//  WeatherDataSource.swift
//  Weather
//
//  Created by Nirmal's Macbook Pro on 29/04/22.
//

import Foundation
import UIKit

class WeatherDataSource: NSObject {
    
    var tableView: UITableView
    
    var viewModel: WeatherViewModel
    
    init(viewModel: WeatherViewModel, tableView: UITableView) {
        self.viewModel = viewModel
        self.tableView = tableView
    }
    
    func fetchWeather(_ city: City, _ completion: @escaping (() -> Void)) {
        viewModel.fetchWeatherDetails(city) { (weather, error) in
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                if let error = error {
                    weakSelf.viewModel.presentErrorAlert(error)
                } else {
                    weakSelf.tableView.reloadData()
                }
                completion()
            }
        }
    }
}

extension WeatherDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.titleForHeader(section).rawValue
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.configureCell(indexPath)
    }
}

extension WeatherDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.heightForRow(indexPath.section)
    }
}
