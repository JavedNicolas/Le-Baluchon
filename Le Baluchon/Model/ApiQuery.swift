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

    // ---- attribut
    private var queryEndPoint : String
    private var queryInfo : Query
    internal var defaultSessions = URLSession(configuration: .default)
    private var dataTask : URLSessionDataTask?
    var urlComponent : URLComponents?
    var errorDelegate : ErrorDelegate?

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
        self.queryEndPoint = apistring
        queryInfo = Query("", userId, password)
    }

    init(session : URLSession){
        defaultSessions = session
        self.queryEndPoint = ""
        queryInfo = Query("", "", "")
    }

    /**
     Init the Query with the query and informations in the class
     like id, password and apistring
     */
    func initQuery(_ query : String) {
        self.urlComponent = URLComponents(string: queryEndPoint)

        guard var urlComp = urlComponent else {return}

        urlComp.query = query
        if urlComp.user == "" {
            urlComp.user = queryInfo.userId
            urlComp.password = queryInfo.password
        }

        self.urlComponent = urlComp
    }

    /**
     Launch the query then return with escaping closure the data or an error

     - Parameters:
     - success : closure in case of success of the query, return the data and the status code
     - failure : close in case of the failure of the query, return the status code and the error

     */
    func launchQuery(success: @escaping (Data) -> Void, failure: @escaping (Int) -> Void) {
        if let task = dataTask {
            task.cancel()
        }

        if let component = urlComponent {
            guard let url = component.url else {return}

            dataTask = defaultSessions.dataTask(with: url) { data, reponse, error in
                let reponseCode = reponse as? HTTPURLResponse
                DispatchQueue.main.async {
                    guard let code = reponseCode?.statusCode else {return}

                    if error != nil {
                        failure(code)
                    } else if let data = data, code >= 200 && code < 300 {
                        success(data)
                    } else if code >= 300 {
                        failure(code)
                    }
                }
            }
            dataTask?.resume()
        }
    }
}
