//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Nirmal's Macbook Pro on 29/04/22.
//

import Foundation
import UIKit

enum Identifier: String {
    
    case city = "City"
    
    case foreCast = "Forecast"
    
}

class WeatherViewModel {
    
    var viewController: UIViewController?
    
    var weather: Weather?
    
    var error: Error?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func fetchWeatherDetails(_ city: City, _ completion: @escaping ((Weather?, Error?) -> Void)) {
        APIHandler.fetchWeatherDetails(city) { [weak self] (weather, error) in
            guard let weakSelf = self else { return }
            if let weather = weather {
                weakSelf.weather = weather
            } else if let error = error {
                weakSelf.error = error
            }
            completion(weather, error)
        }
    }
    
    func titleForHeader(_ section: Int) -> Identifier {
        section == 0 ? .city : .foreCast
    }
    
    func heightForRow(_ section: Int) -> CGFloat {
        section == 0 ? 80 : 100
    }
    
    func numberOfSections() -> Int {
        weather == nil ? 0 : 2
    }
    
    func numberOfRows(_ section: Int) -> Int {
        section == 0 ? 1 : (weather?.forecast.forecastday ?? []).count
    }
    
    func cellIdentifierForRow(_ section: Int) -> Identifier {
        section == 0 ? .city : .foreCast
    }
    
    func configureCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifierForRow(indexPath.section).rawValue)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            if let name = weather?.location.name, let country = weather?.location.country {
                cell.textLabel?.text = [name, country].joined(separator: ", ")
            }
            cell.detailTextLabel?.text = weather?.location.localtime
        case 1:
            if let forcast = weather?.forecast.forecastday[indexPath.row], let image = forcast.day.condition.image {
                cell.imageView?.image = UIImage(data: image)
                cell.textLabel?.text = forcast.date
                cell.detailTextLabel?.numberOfLines = 0
                cell.detailTextLabel?.text = "Min Temp: \(forcast.day.mintemp_c)" + "\n" + "Max Temp: \(forcast.day.maxtemp_c)"
            }
        default:
            break
        }
        return cell
    }
    
    func presentErrorAlert(_ error: Error) {
        let alert = UIAlertController.init(title: "Error", message: error.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
