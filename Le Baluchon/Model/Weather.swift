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
    private let apiURL = "https://query.yahooapis.com/v1/public/yql?q="

    // --- Structs
    struct WeatherInfos {
        var date : String
        var text : String
        var temp : Int

        init(_ json: [String : Any]) {
            date = json["date"] as? String ?? ""
            text = json["text"] as? String ?? ""
            temp = json["temp"] as? Int ?? 0
        }
    }

    // ----- Attribut
    var currentWeather : WeatherInfos?

    init(){
        super.init(apiURL, id, password)
    }

    func queryForCurrentWeather(inTown: String, completion: @escaping () -> ()) {
        let query = "select item.condition from weather.forecast where woeid in (select woeid from geo.places(1) where text='Paris, fr')&format=json&callback=callbackFunction"
        self.initQuery(query)
        self.launchQuery(success: { (data, statusCode) in
            let json = self.parseDataAsJSON(data)
            self.currentWeather = WeatherInfos(json)
            completion()
        }, failure: { (statusCode, error) in
            print(error)
        })
    }

}
