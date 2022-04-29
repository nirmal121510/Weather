//
//  WeatherViewModelTests.swift
//  WeatherTests
//
//  Created by Nirmal's Macbook Pro on 29/04/22.
//

import XCTest
@testable import Weather

class WeatherViewModelTests: XCTestCase {

    var viewModel : WeatherViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = WeatherViewModel(viewController: UIViewController())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTitleForHeader() {
        XCTAssertEqual(viewModel?.titleForHeader(0), Identifier.city)
        XCTAssertEqual(viewModel?.titleForHeader(1), Identifier.foreCast)
    }
    
    func testHeightForRow() {
        XCTAssertEqual(viewModel?.heightForRow(0), 80)
        XCTAssertEqual(viewModel?.heightForRow(1), 100)
    }
    
    func testNumberOfSections() {
        XCTAssertEqual(viewModel?.numberOfSections(), 0)
        let expectation = self.expectation(description: "FetchWeather")
        viewModel?.fetchWeatherDetails(.chennai, { [weak self] (weather, error) in
            guard let weakSelf = self else { return }
            XCTAssertNotNil(weather)
            XCTAssertNil(error)
            XCTAssertEqual(weakSelf.viewModel?.numberOfSections(), 2)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testNumberOfRows() {
        XCTAssertEqual(viewModel?.numberOfRows(0), 1)
        XCTAssertEqual(viewModel?.numberOfRows(1), 0)
        let expectation = self.expectation(description: "FetchWeather")
        viewModel?.fetchWeatherDetails(.chennai, { [weak self] (weather, error) in
            guard let weakSelf = self else { return }
            XCTAssertNotNil(weather)
            XCTAssertNil(error)
            XCTAssertEqual(weakSelf.viewModel?.numberOfRows(1), 3)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCellIdentifierForRow() {
        XCTAssertEqual(viewModel?.cellIdentifierForRow(0), .city)
        XCTAssertEqual(viewModel?.cellIdentifierForRow(1), .foreCast)
    }
    
    func testFetchWeatherSuccess() {
        let expectation = self.expectation(description: "FetchWeather")
        viewModel?.fetchWeatherDetails(.chennai, { (weather, error) in
            XCTAssertNotNil(weather)
            XCTAssertNil(error)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchWeatherError() {
        let expectation = self.expectation(description: "FetchWeather")
        viewModel?.fetchWeatherDetails(.unknown, { (weather, error) in
            XCTAssertNil(weather)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.message, "Parse Error")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
}
