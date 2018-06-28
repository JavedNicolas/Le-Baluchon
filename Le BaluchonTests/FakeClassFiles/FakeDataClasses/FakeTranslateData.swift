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
    let responseOK = HTTPURLResponse.init(url: URL(string: "http://openclassroom.com")!,
                                          statusCode: 200, httpVersion: nil, headerFields: [:])
    let responseKO = HTTPURLResponse.init(url: URL(string: "http://openclassroom.com")!,
                                          statusCode: 200, httpVersion: nil, headerFields: [:])

    // --- fake data from server
    var CorrectData : Data {
        let url = Bundle(for: FakeWeatherData.self).url(forResource: "Translate", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }

    var wrongData : Data {
        return "erreur".data(using: .utf8)!
    }

}
