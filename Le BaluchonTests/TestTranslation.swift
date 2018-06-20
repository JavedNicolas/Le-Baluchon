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

    var translate : Translation!

    override func setUp() {
        translate = Translation()
    }

    func testGivenWeWantToTranslateASentenceWhenTheQueryEndWithSuccessThenWeGetAPositifAnswer() {
        //Given
        //in the setUp

        // Given, When
        translate.queryForTranslation(sentence: "Bonjour", sourceLanguage : "fr", targetLanguage : "en") {
            // Then
            if let parsed = self.translate.translationText {
                XCTAssertNotNil(parsed)
            }
        }
    }

}
