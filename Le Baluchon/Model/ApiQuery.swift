//
//  ApiQuery.swift
//  Le Baluchon
//
//  Created by Nicolas on 18/05/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

class ApiQuery {

    // ---- Structs
    private struct Query {
        var queryString : String
        var userId : String
        var password : String

        init (_ query : String , _ userId : String, _ password: String){
            self.queryString = query
            self.userId = userId
            self.password = password
        }
    }


    // ----
    private var apiString : String
    private var queryInfo : Query
    private let defaultSessions = URLSession(configuration: .default)
    private var dataTask : URLSessionDataTask?
    var urlComponent : URLComponents?

    var queryResult: [String: Any?]?

    // ---- method

    /**
     init the class with the APISTRING which is the url of the api
     whithout the query, the id, and password of the account to
     make the query

     - Parameters:
        - apistring : url of the api whithout the query
        - userId : id of the user
        - password : Password of the user
     */
    init(_ apistring: String, _ userId : String, _ password: String) {
        self.apiString = apistring
        queryInfo = Query("", userId, password)
    }

    /**
     Init the Query with the query and informations in the class
     like id, password and apistring
     */
    func initQuery(_ query : String ) {
        self.urlComponent = URLComponents(string: apiString)

        guard var urlComp = urlComponent else {return}

        urlComp.query = queryInfo.queryString
        urlComp.user = queryInfo.userId
        urlComp.password = queryInfo.password

        self.urlComponent = urlComp
    }

    /**
     Launch the query then return with escaping closure the data or an error

     - Parameters:
     - success : closure in case of success of the query, return the data and the status code
     - failure : close in case of the failure of the query, return the status code and the error

     */
    func launchQuery(success: @escaping (Data, Int) -> Void, failure: @escaping (Int, Error) -> Void) {
        if let task = dataTask {
            task.cancel()
        }

        if let component = urlComponent {
            guard let url = component.url else {return}

            dataTask = defaultSessions.dataTask(with: url) { data, reponse, error in
                let reponseCode = reponse as? HTTPURLResponse
                if let error = error {
                    if let code = reponseCode?.statusCode {
                        failure(code, error)
                    }
                } else if let data = data {
                    if let code = reponseCode?.statusCode, code >= 200 && code < 300 {
                        success(data, code)
                    }
                }
            }
            dataTask?.resume()
        }
    }

    /**
     Parse the Query data as JSON
     - Parameter data: Data to convert to JSON
     - returns: The JSON as Any
    */
    func parseDataAsJSON(_ data: Data) -> [String : Any] {
        do {
            return  (try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String : Any])!
        }catch let jsonErr {
            return ["Erreur":jsonErr]
        }
    }
}
