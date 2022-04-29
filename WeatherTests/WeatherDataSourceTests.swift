//
//  WeatherDataSourceTests.swift
//  WeatherTests
//
//  Created by Nirmal's Macbook Pro on 29/04/22.
//

import XCTest
@testable import Weather

class WeatherDataSourceTests: XCTestCase {

    var dataSource : WeatherDataSource?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let viewModel = WeatherViewModel(viewController: UIViewController())
        dataSource = WeatherDataSource(viewModel: viewModel, tableView: UITableView())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchWeatherSuccess() {
        let expectation = self.expectation(description: "FetchWeather")
        dataSource?.fetchWeather(.chennai, { [weak self] in
            guard let weakSelf = self else { return }
            XCTAssertEqual(weakSelf.dataSource?.viewModel.numberOfRows(1), 3)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchWeatherError() {
        let expectation = self.expectation(description: "FetchWeather")
        dataSource?.fetchWeather(.unknown, { [weak self] in
            guard let weakSelf = self else { return }
            XCTAssertEqual(weakSelf.dataSource?.viewModel.numberOfRows(1), 0)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }

}
