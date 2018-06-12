//
//  weather.swift
//  Le Baluchon
//
//  Created by Nicolas on 18/05/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

class Weather : ApiQuery {

    // ----- Query Attribut
    private let id = "dj0yJmk9dHJTZnRmU202N3M3JmQ9WVdrOWJqRllZWE5STjJzbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD1jMA--"
    private let password = "b12a7017c524946e5628abf0e83218d0f478b45a"
    private let prefix = "https://query.yahooapis.com/v1/public/yql?"
    private let suffix = "&format=json"

    // ------ Struct
    struct Forecast {
        var location : WeatherLocation
        var forecast : [WeatherCondition]
        var currentCondition : WeatherCurrentCondition

        init (_ location : WeatherLocation, _ forecast : [WeatherCondition], _ currentCondition: WeatherCurrentCondition){
            self.location = location
            self.forecast = forecast
            self.currentCondition = currentCondition
        }
    }

    // ----- Attribut
    var parsedQuery : WeatherQuery?
    var forecast : Forecast?

    init(){
        super.init(prefix, id, password)
    }

    /**
     Launch the query to get the last forecast for a given town

     - parameters:
        -  inTown : The given Town
        - completion: The completion Handler which is called when the query end (in a bad or a good way
                        and escape the status code.

    */
    func queryForForecast(inTown: String, completion: @escaping (Int) -> ()) {
        let query = "q=select * from weather.forecast where woeid in (select woeid from geo.places(1) where text='\(inTown)') \(suffix)"
        self.initQuery(query)
        self.launchQuery(success: { (data, statusCode) in
            do {
                self.parsedQuery = try JSONDecoder().decode(WeatherQuery.self, from: data)
            } catch let parseError {
                print(parseError)
            }
            self.extractUsefullInfosFromParsedQuery()
            completion(statusCode)
        }, failure: { (statusCode, error) in
            completion(statusCode)
        })

    }

    func extractUsefullInfosFromParsedQuery() {
        guard let forecastChannel = parsedQuery?.query?.results?.channel else { return }
        guard let location = forecastChannel.location else { return }
        guard let forecastInfos = forecastChannel.item?.forecast else { return }
        guard let currentCondition = forecastChannel.item?.condition else { return }

        self.forecast = Forecast(location, forecastInfos, currentCondition)

    }

}
