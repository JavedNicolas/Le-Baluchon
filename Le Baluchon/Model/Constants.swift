//
//  Constants.swift
//  Le Baluchon
//
//  Created by Nicolas on 17/07/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

struct Constants {
    struct WeatherConstants {
        static let ID = YahooWeatherId
        static let PASSWORD = YahooWeatherPassword
        static let ENDPOINT = "https://query.yahooapis.com/v1/public/yql?"
        static let QUERY = "q=select * from weather.forecast where woeid in (select woeid from geo.places(1) where text='"
        static let SUFFIX = "')&format=json"
        static let HTTP_METHOD = "POST"
    }

    struct TranslationConstants {
        static let API_KEY = GoogleTranslateApiKey
        static let HTTP_METHOD = "POST"
        static let ENDPOINT = "https://translation.googleapis.com/language/translate/v2?key="
        static let SOURCE = "&source="
        static let TARGET = "&target="
        static let FORMAT = "&format=text"
        static let QUERY = "&q="

    }

    struct ChangeConstants {
        static let API_KEY = fixerApiKey
        static let HTTP_METHOD = "POST"
        static let ENDPOINT = "http://data.fixer.io/api/latest?"
        static let ACCESS_KEY = "access_key="
        static let SYMBOL = "&symbols="
        static let SUFFIX = "&format=1"
    }
}
