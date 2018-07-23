//
//  TestWeather.swift
//  Le Baluchon
//
//  Created by Nicolas on 06/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import XCTest
@testable import Le_Baluchon

class TestWeather: XCTestCase {

    func testGivenWeAskForWeatherThenWeGetCorrectData() {
        //Given
        let fakeUrlSession = FakeUrlSession(data: FakeWeatherData.correctData, response: FakeWeatherData.responseOK, error: nil)
        let weather = Weather(session: fakeUrlSession)
        let expectation = XCTestExpectation(description: "Wait for queue change")

        // When
        weather.queryForForecast(inTown: "Paris, fr") { success, weather in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(weather)
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGivenWeGotForcastThenWeNeedToConvertFahrenheitToCelcius() {
        let celcius = Weather.shared.fahrenheitToCelcius(50)
        XCTAssertEqual(celcius, 10)
    }


    func testGivenWeAskForWeatherThenWeGetInCorrectData() {
        //Given
        let fakeUrlSession = FakeUrlSession(data: FakeWeatherData.wrongData, response: FakeWeatherData.responseOK, error: nil)
        let weather = Weather(session: fakeUrlSession)
        let expectation = XCTestExpectation(description: "Wait for queue change")

        // When
        weather.queryForForecast(inTown: "Paris, fr") { success, weather in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testGivenWeAskForWeatherThenWeGetABadHTTPCode() {
        //Given
        let fakeUrlSession = FakeUrlSession(data: nil, response: FakeWeatherData.responseKO, error: nil)
        let weather = Weather(session: fakeUrlSession)
        let expectation = XCTestExpectation(description: "Wait for queue change")

        // When
        weather.queryForForecast(inTown: "Paris, fr") { success, weather in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testGivenWeAskForWeatherThenWeGetAnError() {
        //Given
        let fakeUrlSession = FakeUrlSession(data: FakeWeatherData.correctData, response: FakeWeatherData.responseOK,
                                            error: FakeWeatherData.error)
        let weather = Weather(session: fakeUrlSession)
        let expectation = XCTestExpectation(description: "Wait for queue change")

        // When
        weather.queryForForecast(inTown: "Paris, fr") { success, weather in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 0.1)
    }
}
