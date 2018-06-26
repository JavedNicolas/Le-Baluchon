//
//  Change.swift
//  Le Baluchon
//
//  Created by Nicolas on 26/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

class Change : ApiQuery {

    private var endPoint = "http://data.fixer.io/api/latest"
    private var suffix = ""
    private var key = FixerApiKey

    var rateResult : ChangeQuery?


    init(){
        super.init(endPoint, "", "")
    }

    func queryForChange(_ to : String, completionHandler : @escaping () -> ()) {
        let query = "access_key=\(key)&symbols=\(to)&format=1"
        initQuery(query)

        guard let errorDelegate = self.errorDelegate else { return }

        launchQuery(success: { (data) in
            do {
                self.rateResult = try JSONDecoder().decode(ChangeQuery.self, from: data)
            } catch {
                errorDelegate.errorHandling(self, Error.unknownError)
            }
        }) { (statusCode) in
            switch statusCode {
            case 400...499: errorDelegate.errorHandling(self, Error.webClientError)
            case 500...599: errorDelegate.errorHandling(self, Error.serverError)
            default: errorDelegate.errorHandling(self, Error.unknownError)
            }
        }
        completionHandler()
    }

    func conversion(_ rate : Double, _ amout : Double) -> Double {
        return rate * amout
    }
}
