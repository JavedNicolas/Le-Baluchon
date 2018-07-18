//
//  Change.swift
//  Le Baluchon
//
//  Created by Nicolas on 26/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

class Change {
    static var shared = Change()
    var rateResult : ChangeQuery?
    var errorDelegate : ErrorDelegate?
    private var session = URLSession(configuration: .default)
    private var task : URLSessionDataTask?

    private init(){}

    init(session : URLSession){
        self.session = session
    }

    func queryForChange(_ to : String, completion : @escaping (Bool) -> ()) {
        let request = createRequest(to)

        guard let errorDelegate = self.errorDelegate else { return }
        task?.cancel()
        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    errorDelegate.errorHandling(self, Error.unknownError)
                    completion(false)
                    return
                }

                guard let reponse = response as? HTTPURLResponse, reponse.statusCode == 200 else {
                    if let response = response as? HTTPURLResponse {
                        self.statusCodeErrorHandling(statusCode: response.statusCode)
                    }
                    completion(false)
                    return
                }

                do {
                    self.rateResult = try JSONDecoder().decode(ChangeQuery.self, from: data)
                } catch {
                    errorDelegate.errorHandling(self, Error.unknownError)
                    completion(false)
                }
                completion(true)
            }
        })
        task?.resume()
    }

    func conversion(_ rate : Double, _ amout : Double) -> Double {
        return rate * amout
    }

    private func createRequest(_ currency : String) -> URLRequest {
        var requesst = URLRequest (url: URL(string: Constants.ChangeConstants.ENDPOINT +
            Constants.ChangeConstants.ACCESS_KEY + Constants.ChangeConstants.API_KEY)!)
        requesst.httpMethod = Constants.ChangeConstants.HTTP_METHOD
        let body = Constants.ChangeConstants.SYMBOL + currency + Constants.ChangeConstants.SUFFIX
        requesst.httpBody = body.data(using: .utf8)
        return requesst
    }

    private func statusCodeErrorHandling(statusCode : Int ){
        guard let errorDelegate = self.errorDelegate else { return }

        switch statusCode {
        case 400...499:errorDelegate.errorHandling(self, Error.webClientError)
        case 500...599:errorDelegate.errorHandling(self, Error.serverError)
        default :errorDelegate.errorHandling(self, Error.unknownError)
        }
    }
}
