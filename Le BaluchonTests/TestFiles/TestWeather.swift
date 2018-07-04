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
    var weather : Weather!

    override func setUp() {
        super.setUp()
    }

    func testGivenWeAskForWeatherThenWeGetCorrectDataAndParseIt() {
        //Given
        let fakeUrlSession = FakeUrlSession(data: FakeWeatherData.correctData, response: FakeWeatherData.responseOK, error: nil)
        let weather = Weather(session: fakeUrlSession)
        let expectation = XCTestExpectation(description: "Wait for queue change")

        // When
        weather.queryForForecast(inTown: "Paris, fr") {
            // Then
            if let parsedData = self.weather.parsedQuery {
                XCTAssertNotNil(parsedData)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenWeGotASuccessfullRequestThenWeWantTOExtractUsefullInfoOfParsedParsedData(){
        // Given & then
        let fakeUrlSession = FakeUrlSession(data: FakeWeatherData.correctData, response: FakeWeatherData.responseOK, error: nil)
        let weather = Weather(session: fakeUrlSession )
        let expectation = XCTestExpectation(description: "Wait for queue change")

        weather.queryForForecast(inTown: "Paris, fr") {
            // Then
            self.weather.extractUsefullInfosFromParsedQuery()
            XCTAssertNotNil(self.weather.forecast)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
