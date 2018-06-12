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
        weather = Weather()
    }

    func testGivenWeWantToGetTheForecastWhenTheQueryEndWithSuccessThenWeGetIt() {
        //Given
        //in the setUp

        // When
        weather.queryForForecast(inTown: "Paris, fr") { statusCode in
            // Then
            if let forecast = self.weather.forecast {
                XCTAssertGreaterThan(statusCode, 199)
                XCTAssertLessThan(statusCode, 300)
                XCTAssertNotNil(forecast)
            }
        }
    }
}
