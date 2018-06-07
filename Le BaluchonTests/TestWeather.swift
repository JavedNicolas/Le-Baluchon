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

    func testGivenWeWantToGetTheWeatherWhenTheQueryEndWithSuccessThenWe() {
        //Given
        //in the setUp

        // When
        weather.queryForCurrentWeather(inTown: "Paris, fr") {
            // Then
            if let curWeather = self.weather.currentWeather {
                XCTAssertNotEqual(curWeather.date, "")
                XCTAssertNotEqual(curWeather.text, "")
                XCTAssertNotEqual(curWeather.temp, 0)
            }
        }
    }
}
