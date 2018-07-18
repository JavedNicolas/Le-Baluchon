//
//  FakeSessionOverload.swift
//  Le BaluchonTests
//
//  Created by Nicolas on 25/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

class FakeUrlSession : URLSession {

    var data : Data?
    var response : URLResponse?
    var error : Error?

    init(data: Data?, response: URLResponse?, error: Error?){
        self.data = data
        self.response = response
        self.error = error
    }

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = FakeUrlSessionDataTask()
        task.completionHandler = completionHandler
        task.data = data
        task.httpResponse = response
        task.queryError = error
        return task
    }
}

class FakeUrlSessionDataTask : URLSessionDataTask {

    var completionHandler : ((Data?,URLResponse?,Error?) -> Void)?

    var data : Data?
    var httpResponse : URLResponse?
    var queryError : Error?

    override func resume() {
        completionHandler?(data, httpResponse, queryError)
    }

    override func cancel() {}
}
