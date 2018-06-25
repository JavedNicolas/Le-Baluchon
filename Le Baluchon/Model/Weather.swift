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
    private let id = YahooWeatherId
    private let password = YahooWeatherPassword
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
    func queryForForecast(inTown: String, completion: @escaping () -> ()) {
        let query = "q=select * from weather.forecast where woeid in (select woeid from geo.places(1) where text='\(inTown)')\(suffix)"
        self.initQuery(query)

        guard let errorDelegate = self.errorDelegate else { return }

        self.launchQuery(success: { (data) in
            do {
                self.parsedQuery = try JSONDecoder().decode(WeatherQuery.self, from: data)
            } catch {
                errorDelegate.errorHandling(self, Error.unknownError)
            }
            self.extractUsefullInfosFromParsedQuery()
            completion()
        }, failure: { (statusCode) in


            switch statusCode {
            case 400...499: errorDelegate.errorHandling(self, Error.webClientError)
            case 500...599: errorDelegate.errorHandling(self, Error.serverError)
            default : errorDelegate.errorHandling(self, Error.unknownError)
            }
        })

    }

    /**
        Extract usefull infos from the parsed query so we can use them to
        display the forecast and current weather.
    */
    private func extractUsefullInfosFromParsedQuery() {
        guard let forecastChannel = parsedQuery?.query?.results?.channel else { return }
        guard let location = forecastChannel.location else { return }
        guard let forecastInfos = forecastChannel.item?.forecast else { return }
        guard let currentCondition = forecastChannel.item?.condition else { return }

        self.forecast = Forecast(location, forecastInfos, currentCondition)

    }

    /**
     Convert fahrenheit temperature to celcius

     - parameters:
        -  temp : The temperature une fahrenheit

     - returns: The temperature in celcius
     */
    func fahrenheitToCelcius( _ temp: Float) -> Float{
        return (temp - 32) / 1.8
    }

}
