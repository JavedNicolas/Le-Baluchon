//
//  WeatherInfos.swift
//  Le Baluchon
//
//  Created by Nicolas on 12/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

// ----- Pathing to get to valuable infos
struct WeatherQuery : Decodable {
    var query : WeatherQueryContent?
}

struct WeatherQueryContent : Decodable {
    var created : String?
    var results : WeatherResults?
}

struct WeatherResults : Decodable {
    var channel : WeatherChannel?
}

struct WeatherChannel : Decodable {
    var location : WeatherLocation?
    var item : WeatherForecast?
}

// --------  Current condition
struct WeatherForecast : Decodable {
    var condition : WeatherCurrentCondition?
    var forecast : [WeatherCondition]?
}

struct WeatherCurrentCondition : Decodable {
    var date : String?
    var temp : String?
    var text : String?
}

// ------- Town and country of forecast
struct WeatherLocation : Decodable {
    var city : String?
    var country : String?
    var region : String?
}

// ---- condition for a day of the forecast
struct WeatherCondition : Decodable {
    var code : String?
    var date : String?
    var day : String?
    var high : String?
    var low : String?
    var text : String?
}
