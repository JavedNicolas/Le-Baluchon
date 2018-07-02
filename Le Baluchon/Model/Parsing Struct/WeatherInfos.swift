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
    let query : WeatherQueryContent?
}

struct WeatherQueryContent : Decodable {
    let created : String?
    let results : WeatherResults?
}

struct WeatherResults : Decodable {
    let channel : WeatherChannel?
}

struct WeatherChannel : Decodable {
    let location : WeatherLocation?
    let item : WeatherForecast?
}

// --------  Current condition
struct WeatherForecast : Decodable {
    let condition : WeatherCurrentCondition?
    let forecast : [WeatherCondition]?
}

struct WeatherCurrentCondition : Decodable {
    let date : String?
    let code : String?
    let temp : String?
    let text : String?
}

// ------- Town and country of forecast
struct WeatherLocation : Decodable {
    let city : String?
    let country : String?
    let region : String?
}

// ---- condition for a day of the forecast
struct WeatherCondition : Decodable {
    let code : String?
    let date : String?
    let day : String?
    let high : String?
    let low : String?
    let text : String?
}
