//
//  Translation.swift
//  Le Baluchon
//
//  Created by Nicolas on 20/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

class Translation {
    // ---- Singleton
    static var shared = Translation()

    //----- Attribut
    enum Lang : String {
        case fr
        case en
    }

    var translatedQuery : TranslationQuery?
    private var session = URLSession(configuration: .default)
    private var task : URLSessionDataTask?
    var errorDelegate : ErrorDelegate?
    var useErrorDelegate = true

    // ----------- Inits
    private init() {}

    /** init for the test */
    init(session : URLSession){
        self.session = session
        useErrorDelegate = false
    }

    // ------------- Methodes
    /**
     Launch the query to get the last forecast for a given town
     - parameters:
        - sentence : The given sentence to translate
        - completion: The completion Handler which is called when the query end (in a bad or a good way
        and escape if the query succeeded and the translated sentence if so).
     */
    func queryForTranslation(sentence : String, completion : @escaping (Bool, String?) -> () ) {
        let request = createRequest(Lang.fr.rawValue, Lang.en.rawValue, sentence)
        var translationText : String?
        task?.cancel()

        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let reponse = response as? HTTPURLResponse, reponse.statusCode == 200 else {
                    if let response = response as? HTTPURLResponse {
                        self.statusCodeErrorHanlding(statusCode: response.statusCode)
                    }
                    completion(false, nil)
                    return
                }

                guard let data = data, error == nil else {
                    self.throwError(error: Error.unknownError)
                    completion(false, nil)
                    return
                }

                // parse the answer
                do {
                    self.translatedQuery = try JSONDecoder().decode(TranslationQuery.self, from: data)
                    translationText = self.translatedQuery?.data?.translations?[0].translatedText
                }catch{
                    self.throwError(error: Error.unknownError)
                    completion(false, nil)
                }

                if translationText != nil {
                    completion(true, translationText)
                }else {
                    completion(false, nil)
                }

            }
        })
        task?.resume()
    }


     /**
     Create an instanciated URLRequest variable and return it.
     - parameters:
        - source : the source language
        - target : the target language
        - text : text to translate
     - returns: an instanciated URLRequest
     */
    private func createRequest(_ source : String, _ target : String, _ text : String) -> URLRequest {
        var request = URLRequest(url: URL(string: Constants.TranslationConstants.ENDPOINT + Constants.TranslationConstants.API_KEY)!)
        request.httpMethod = Constants.TranslationConstants.HTTP_METHOD
        let body = Constants.TranslationConstants.SOURCE + source + Constants.TranslationConstants.TARGET + target +
            Constants.TranslationConstants.FORMAT + Constants.TranslationConstants.QUERY + text
        request.httpBody = body.data(using: .utf8)
        return request
    }

    /** Launch the errorDelagete to display the error */
    private func throwError(error : Error) {
        guard let errorDelegate = self.errorDelegate else { return }
        errorDelegate.errorHandling(self, error)
    }

    /** Launch the errorDelagete to display the error for status code */
    private func statusCodeErrorHanlding(statusCode : Int) {
        guard let errorDelegate = self.errorDelegate else { return }
        switch statusCode {
        case 400...499: errorDelegate.errorHandling(self, Error.webClientError)
        case 500...599: errorDelegate.errorHandling(self, Error.serverError)
        default: errorDelegate.errorHandling(self, Error.unknownError)
        }
    }

}
