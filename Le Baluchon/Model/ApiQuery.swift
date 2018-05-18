//
//  ApiQuery.swift
//  Le Baluchon
//
//  Created by Nicolas on 18/05/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

class ApiQuery {

    let defaultSessions = URLSession(configuration: .default)
    var dataTask : URLSessionDataTask?
    var apiString : String
    var queryResult: [String : Any]?

    init(_ apistring: String) {
        self.apiString = apistring
    }

    func query(_ searchTerms: String) {
        if let task = dataTask {
            task.cancel()
        }

        if var urlComponent = URLComponents(string: apiString) {
            urlComponent.query = searchTerms

            guard let url = urlComponent.url else {return}

            dataTask = defaultSessions.dataTask(with: url) { data, reponse, error in
                if let error = error {
                    // TODO error treatment
                } else if let data = data {
                    let reponseCode = reponse as? HTTPURLResponse
                    if reponseCode?.statusCode == 200 {
                        self.updateResult(data)
                    }
                }
            }
        }
    }

    private func updateResult(_ data: Data) {
        print(data)
    }
}
