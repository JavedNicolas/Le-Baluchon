//
//  weather.swift
//  Le Baluchon
//
//  Created by Nicolas on 18/05/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

class Weather{
    // Singleton
    static var shared = Weather()

    // -------- Struct
    struct Forecast {
        var location : WeatherLocation
        var forecast : [WeatherCondition]

        init (_ location : WeatherLocation, _ forecast : [WeatherCondition]){
            self.location = location
            self.forecast = forecast
        }
    }

    // --------- Attribut
    var parsedQuery : WeatherQuery?

    private var session = URLSession(configuration: .default)
    private var task : URLSessionDataTask?
    var errorDelegate : ErrorDelegate?
    private var useErrorDelegate = true

    // -------- Inits
    private init() {}

    /** init for the tests */
    init(session : URLSession){
        self.session = session
        useErrorDelegate = false
    }

    // ---------- Methods

    /**
     Launch the query to get the last forecast for a given town
     - parameters:
        - inTown : The given Town
        - completion: The completion Handler which is called when the query end (in a bad or a good way
                        and escape if the query succeeded and the forecast if so).
    */
    func queryForForecast(inTown: String, completion: @escaping (Bool, Forecast?) -> ()) {
        let request = createRequest(inTown)
        task?.cancel()

        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {

                guard let reponse = response as? HTTPURLResponse, reponse.statusCode == 200 else {
                    if let response = response as? HTTPURLResponse {
                        self.statusCodeErrorHandling(statusCode: response.statusCode)
                        completion(false, nil)
                    }
                    return
                }

                guard let data = data, error == nil else {
                    self.throwError(error: Error.unknownError)
                    completion(false, nil)
                    return
                }

                // parse the answer
                do {
                    self.parsedQuery = try JSONDecoder().decode(WeatherQuery.self, from: data)
                } catch {
                    self.throwError(error: Error.unknownError)
                    completion(false, nil)
                }
                let forecast = self.extractUsefullInfosFromParsedQuery()
                if forecast != nil {
                    completion(true, forecast)
                }else {
                    completion(false, nil)
                }
            }
        })
        task?.resume()
    }

    /**
        Extract usefull infos from the parsed query so we can use them to
        display the forecast and current weather.
    */
    private func extractUsefullInfosFromParsedQuery() -> Forecast? {
        guard let forecastChannel = parsedQuery?.query?.results?.channel else { return nil }
        guard let location = forecastChannel.location else { return nil }
        guard let forecastInfos = forecastChannel.item?.forecast else { return nil }

        return Forecast(location, forecastInfos)
    }

    /**
     Create an instanciated URLRequest variable and return it.
     - parameters:
        - inTown : The given Town for the forecast
     - returns: an instanciated URLRequest
     */
    private func createRequest(_ inTown : String) -> URLRequest {
        var request = URLRequest(url: URL(string: Constants.WeatherConstants.ENDPOINT)!)
        request.httpMethod = Constants.WeatherConstants.HTTP_METHOD
        let body = Constants.WeatherConstants.QUERY + inTown + Constants.WeatherConstants.SUFFIX
        request.httpBody = body.data(using: .utf8)
        return request
    }

    /** Convert Farenheit to celcius and return the result */
    func fahrenheitToCelcius( _ temp: Float) -> Float{
        return (temp - 32) / 1.8
    }

    /** Launch the errorDelagete to display the error */
    private func throwError(error : Error) {
        guard let errorDelegate = self.errorDelegate else { return }
        errorDelegate.errorHandling(self, error)
    }

    /** Launch the errorDelagete to display the error for status code */
    private func statusCodeErrorHandling(statusCode : Int ){
        guard let errorDelegate = self.errorDelegate else { return }

        switch statusCode {
        case 400...499:errorDelegate.errorHandling(self, Error.webClientError)
        case 500...599:errorDelegate.errorHandling(self, Error.serverError)
        default :errorDelegate.errorHandling(self, Error.unknownError)
        }
    }

}
