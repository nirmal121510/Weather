//
//  WeatherViewController.swift
//  Weather
//
//  Created by Nirmal's Macbook Pro on 29/04/22.
//

import Foundation
import UIKit

class WeatherViewController: UITableViewController {
    
    var dataSource: WeatherDataSource?
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Weather"
        addRefreshControl()
        addDatasource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSpinner()
        fetchWeather()
    }
    
    func addSpinner() {
        self.activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        self.view.bringSubviewToFront(activityIndicator)
        self.activityIndicator.hidesWhenStopped = true
    }
    
    func addDatasource() {
        let viewModel = WeatherViewModel(viewController: self)
        dataSource = WeatherDataSource(viewModel: viewModel, tableView: tableView)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(fetchWeather), for: .valueChanged)
    }
    
    @objc func fetchWeather() {
        changeSpinnerState(true)
        dataSource?.fetchWeather(.bangalore) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.changeSpinnerState(false)
            weakSelf.refreshControl?.endRefreshing()
        }
    }
    
    func changeSpinnerState(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
}
