//
//  TestApiquery.swift
//  Le BaluchonTests
//
//  Created by Nicolas on 28/05/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import XCTest
@testable import Le_Baluchon

class TestTranslation: XCTestCase {

    func testGivenWeAskForATranslationThenWeGetCorrectData() {
        //Given
        let fakeUrlSession = FakeUrlSession(data: FakeTranslateData.CorrectData, response: FakeTranslateData.responseOK, error: nil)
        let translation = Translation(session: fakeUrlSession)
        let expectation = XCTestExpectation(description: "Wait for queue change")

        // When
        translation.queryForTranslation(sentence: "test") { success, translate in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(translate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenWeAskForATranslationThenWeGetInCorrectData() {
        //Given
        let fakeUrlSession = FakeUrlSession(data: FakeTranslateData.wrongData,
                                            response: FakeTranslateData.responseOK, error: nil)
        let translation = Translation(session: fakeUrlSession)
        let expectation = XCTestExpectation(description: "Wait for queue change")

        // When
        translation.queryForTranslation(sentence: "test") { success, translate in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenWeAskForATranslationThenWeGetBadHTTPCode() {
        //Given
        let fakeUrlSession = FakeUrlSession(data: nil, response: FakeTranslateData.responseKO, error: nil)
        let translation = Translation(session: fakeUrlSession)
        let expectation = XCTestExpectation(description: "Wait for queue change")

        // When
        translation.queryForTranslation(sentence: "test") { success, translate in
        // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenWeAskForATranslationThenWeGetAnError() {
        //Given
        let fakeUrlSession = FakeUrlSession(data: FakeTranslateData.CorrectData, response: FakeTranslateData.responseOK,
                                            error: FakeTranslateData.error)
        let translation = Translation(session: fakeUrlSession)
        let expectation = XCTestExpectation(description: "Wait for queue change")

        // When
        translation.queryForTranslation(sentence: "test") { success, translate in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
