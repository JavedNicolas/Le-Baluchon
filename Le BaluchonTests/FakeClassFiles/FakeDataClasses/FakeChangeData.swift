//
//  FakeChangeData.swift
//  Le BaluchonTests
//
//  Created by Nicolas on 23/07/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

class FakeChangeData {

    // ----- fake reponse from server
    static let responseOK = HTTPURLResponse.init(url: URL(string: "http://openclassroom.com")!,
                                                 statusCode: 200, httpVersion: nil, headerFields: [:])
    static let responseKO = HTTPURLResponse.init(url: URL(string: "http://openclassroom.com")!,
                                                 statusCode: 400, httpVersion: nil, headerFields: [:])

    // ----- fake error from server
    class ChangeError: Error {}
    static let error = ChangeError()

    // --- fake data from server
    static var correctData : Data {
        let url = Bundle(for: FakeChangeData.self).url(forResource: "Change", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }

    static var wrongData : Data {
        return "erreur".data(using: .utf8)!
    }

}
