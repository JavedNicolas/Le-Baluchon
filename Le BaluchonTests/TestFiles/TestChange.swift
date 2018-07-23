//
//  TestChange.swift
//  Le BaluchonTests
//
//  Created by Nicolas on 23/07/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import XCTest
@testable import Le_Baluchon

class TestChange: XCTestCase {

    func testGivenWeAskForChangeThenWeGetCorrectData() {
        // given
        let fakeUrlSession = FakeUrlSession(data: FakeChangeData.correctData, response: FakeChangeData.responseOK, error: nil)
        let change = Change(session: fakeUrlSession)
        let expectation = XCTestExpectation(description: "Wating for queue change")

        // when
        change.queryForChange("USD") { (success, changeResult) in
            // then
            XCTAssertTrue(success)
            XCTAssertNotNil(changeResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenWeAskForChangeThenWeGetInCorrectData() {
        // given
        let fakeUrlSession = FakeUrlSession(data: FakeChangeData.wrongData, response: FakeChangeData.responseOK, error: nil)
        let change = Change(session: fakeUrlSession)
        let expectation = XCTestExpectation(description: "Wating for queue change")

        // when
        change.queryForChange("USD") { (success, changeResult) in
            // then
            XCTAssertFalse(success)
            XCTAssertNil(changeResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenWeAskForChangeThenWeGetABadHTTPCode() {
        // given
        let fakeUrlSession = FakeUrlSession(data: nil, response: FakeChangeData.responseKO, error: nil)
        let change = Change(session: fakeUrlSession)
        let expectation = XCTestExpectation(description: "Wating for queue change")

        // when
        change.queryForChange("USD") { (success, changeResult) in
            // then
            XCTAssertFalse(success)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenWeAskForChangeThenWeGetAnError() {
        // given
        let fakeUrlSession = FakeUrlSession(data: FakeChangeData.correctData , response: FakeChangeData.responseOK,
                                            error: FakeChangeData.error)
        let change = Change(session: fakeUrlSession)
        let expectation = XCTestExpectation(description: "Wating for queue change")

        // when
        change.queryForChange("USD") { (success, changeResult) in
            // then
            XCTAssertFalse(success)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenWeGotChangeRateThenWeConvertInputValueToCurrency() {
        // given
        let fakeUrlSession = FakeUrlSession(data: FakeChangeData.correctData, response: FakeChangeData.responseOK, error: nil)
        let change = Change(session: fakeUrlSession)
        let expectation = XCTestExpectation(description: "Wating for queue change")

        // when
        change.queryForChange("USD") { (success, changeResult) in
            // then
            XCTAssertTrue(success)
            XCTAssertNotNil(changeResult)
            let convertedCurrency = change.conversion((changeResult?.rates!["USD"])!, 200)
            XCTAssertEqual(convertedCurrency, 234.662)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
}
