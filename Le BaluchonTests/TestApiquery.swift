//
//  TestApiquery.swift
//  Le BaluchonTests
//
//  Created by Nicolas on 28/05/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import XCTest
@testable import Le_Baluchon

class TestApiquery: XCTestCase {
    var apiQuery : ApiQuery!
    
    override func setUp() {
        super.setUp()
        apiQuery = ApiQuery("https://query.yahooapis.com/v1/public/yql?q=",
                            "dj0yJmk9dHJTZnRmU202N3M3JmQ9WVdrOWJqRllZWE5STjJzbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD1jMA--",
                            "b12a7017c524946e5628abf0e83218d0f478b45a")
    }

    func testGivenWeWantToInitializeAQueryWhenWeDoItThenWeGetAnURLComponentWithQueryAndUserAndPassword() {
        //Given
        // in the setUp

        // When
        apiQuery.initQuery("select wind from weather.forecast where woeid in (select woeid from geo.places(1) where text='Paris, fr')&format=json&callback=callbackFunction")

        // Then
        guard let urlComponent = apiQuery.urlComponent, let query = urlComponent.query, let user = urlComponent.user,
            let password = urlComponent.password else {return}
        XCTAssertNotNil(query)
        XCTAssertNotNil(user)
        XCTAssertNotNil(password)
    }

    func testGivenToDoAQueryWhenTheQueryEndWithSuccesThenWeGetTheResult() {
        // Given
        apiQuery.initQuery("select wind from weather.forecast where woeid in (select woeid from geo.places(1) where text='Paris, fr')&format=json&callback=callbackFunction")

        // When and then
        apiQuery.launchQuery(success: { (data, statusCode) in
            XCTAssertNotNil(data)
        }, failure: { statusCode, error in })
    }

    func testGivenToDoAQueryWhenTheQueryEndWithAnErrorThenWeGetAnError() {
        // Given
        apiQuery.initQuery("select wind from weather.forecast where woeid in (select woeid from geo.places(1) where text='Paris")

        // When and then
        apiQuery.launchQuery(success: { (data, statusCode) in}) { (statusCode, error) in
            XCTAssertGreaterThan(statusCode, 299)
            XCTAssertNotNil(error)
        }
    }

    func testGivenWeMadeASuccessfullQueryWhenWeGetTheDataThenWeParseItAsJSON() {
        // Given
        apiQuery.initQuery("select wind from weather.forecast where woeid in (select woeid from geo.places(1) where text='Paris, fr')&format=json&callback=callbackFunction")

        apiQuery.launchQuery(success: { (data, statusCode) in
            let JSONOfData = self.apiQuery.parseDataAsJSON(data)
            XCTAssertNotNil(JSONOfData)
        },
        failure: { (statusCode, error) in})
    }
}
