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
    struct Query {
        var queryString : String
        var userId : String
        var password : String

        init (_ query : String , _ userId : String, _ password: String){
            self.queryString = query
            self.userId = userId
            self.password = password
        }
    }

    struct QueryAnswer {

    }

    // ----
    let defaultSessions = URLSession(configuration: .default)
    var dataTask : URLSessionDataTask?
    var apiString : String
    var queryResult: [String: Any?]?
    let notificationName = Notification.Name(rawValue: "QueryCompleted")
    var queryInfo : Query
    var urlComponent : URLComponents?

    // ---- method
    init(_ apistring: String, _ userId : String, _ password: String) {
        self.apiString = apistring
        queryInfo = Query("", userId, password)
    }

    func initQuery(_ query : String ) {
        self.urlComponent = URLComponents(string: apiString)

        guard var urlComp = urlComponent else {return}

        urlComp.query = queryInfo.queryString
        urlComp.user = queryInfo.userId
        urlComp.password = queryInfo.password

        self.urlComponent = urlComp
    }

    func launchQuery(completionHanlder: @escaping (Data) -> Void ) {
        if let task = dataTask {
            task.cancel()
        }

        if let component = urlComponent {
            guard let url = component.url else {return}

            dataTask = defaultSessions.dataTask(with: url) { data, reponse, error in
                if let error = error {
                   print(error)
                } else if let data = data {
                    let reponseCode = reponse as? HTTPURLResponse
                    if reponseCode?.statusCode == 200 {
                        self.updateResult(data)

                        let notification = Notification(name: self.notificationName)
                        NotificationCenter.default.post(notification)
                    }
                }
            }
            dataTask?.resume()
        }
    }

    private func updateResult(_ data: Data) {
        print(data)
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            print(json)
        }catch let jsonErr {
            print(jsonErr)
        }
    }

    func getResult() {
        print(queryResult)
    }
}
