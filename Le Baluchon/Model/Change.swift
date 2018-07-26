//
//  Change.swift
//  Le Baluchon
//
//  Created by Nicolas on 26/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

class Change {
    // ----------- Methods 
    static var shared = Change()

    // ----------- Attributs
    var rateResult : ChangeQuery?
    var errorDelegate : ErrorDelegate?
    private var session = URLSession(configuration: .default)
    private var task : URLSessionDataTask?
    private var useErrorDelegate = true

    // ------------ inits
    private init(){}

    /** init for the tests */
    init(session : URLSession){
        self.session = session
        self.useErrorDelegate = false
    }

    // -------------- Methods

    /**
     Launch the query to get the last forecast for a given town.
     - parameters:
        - to : The given currency code to convert in
        - completion: The completion Handler which is called when the query end (in a bad or a good way
        and escape if the query succeeded and the query change if so).
     */
    func queryForChange(_ to : String, completion : @escaping (Bool, ChangeQuery?) -> ()) {
        let request = createRequest(to)

        task?.cancel()
        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let reponse = response as? HTTPURLResponse, reponse.statusCode == 200 else {
                    if let response = response as? HTTPURLResponse {
                        self.statusCodeErrorHandling(statusCode: response.statusCode)
                         completion(false, nil)
                    }
                    return
                }

                guard let data = data, error == nil else {
                    self.throwError(error: Error.unknownError)
                    completion(false, nil)
                    return
                }

                // parse the answer
                do {
                    self.rateResult = try JSONDecoder().decode(ChangeQuery.self, from: data)
                } catch {
                    self.throwError(error: Error.unknownError)
                    completion(false, nil)
                }
                
                if self.rateResult != nil {
                    completion(true, self.rateResult)
                }else {
                    completion(false, nil)
                }
            }
        })
        task?.resume()
    }

    func conversion(_ rate : Double, _ amout : Double) -> Double {
        return rate * amout
    }

    /**
     Create an instanciated URLRequest variable and return it
     - parameters:
        - currency : the currency code
     - returns: an instanciated URLRequest
     */
    private func createRequest(_ currency : String) -> URLRequest {
        var requesst = URLRequest (url: URL(string: Constants.ChangeConstants.ENDPOINT +
            Constants.ChangeConstants.ACCESS_KEY + Constants.ChangeConstants.API_KEY)!)
        requesst.httpMethod = Constants.ChangeConstants.HTTP_METHOD
        let body = Constants.ChangeConstants.SYMBOL + currency + Constants.ChangeConstants.SUFFIX
        requesst.httpBody = body.data(using: .utf8)
        return requesst
    }

    /** Launch the errorDelagete to display the error */
    private func throwError(error : Error) {
        guard let errorDelegate = self.errorDelegate else { return }
        errorDelegate.errorHandling(self, error)
    }

    /** Launch the errorDelagete to display the status code error */
    private func statusCodeErrorHandling(statusCode : Int ){
        guard let errorDelegate = self.errorDelegate else { return }

        switch statusCode {
        case 400...499:errorDelegate.errorHandling(self, Error.webClientError)
        case 500...599:errorDelegate.errorHandling(self, Error.serverError)
        default :errorDelegate.errorHandling(self, Error.unknownError)
        }
    }
}
