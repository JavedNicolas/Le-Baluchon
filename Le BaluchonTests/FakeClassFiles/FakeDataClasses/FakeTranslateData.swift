//
//  TranslateFakeDAta.swift
//  Le BaluchonTests
//
//  Created by Nicolas on 25/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

class FakeTranslateData {

    // ----- fake reponse from server
    static let responseOK = HTTPURLResponse(url: URL(string: "http://openclassroom.com")!,
                                          statusCode: 200, httpVersion: nil, headerFields: nil)
    static let responseKO = HTTPURLResponse(url: URL(string: "http://openclassroom.com")!,
                                          statusCode: 400, httpVersion: nil, headerFields: nil)

    // ----- fake error from server
    class TranslationError: Error {}
    static let error = TranslationError()

    // --- fake data from server
    static var CorrectData : Data {
        let url = Bundle(for: FakeTranslateData.self).url(forResource: "Translate", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }

    static var wrongData : Data {
        return "fghsrjsgj".data(using: .utf8)!
    }

}
