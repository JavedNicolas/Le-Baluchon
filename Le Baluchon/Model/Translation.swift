//
//  Translation.swift
//  Le Baluchon
//
//  Created by Nicolas on 20/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

class Translation {
    static var shared = Translation()
    //----- Attribut
    enum Lang : String {
        case fr
        case en
    }

    var translationText : String?
    var translatedQuery : TranslationQuery?
    private var session = URLSession(configuration: .default)
    private var task : URLSessionDataTask?
    var errorDelegate : ErrorDelegate?

    private init() {}

    init(session : URLSession){
        self.session = session
    }

    func queryForTranslation(sentence : String, completion : @escaping (Bool) -> () ) {
        let request = createRequest(Lang.fr.rawValue, Lang.en.rawValue, sentence)
        task?.cancel()

        guard let errorDelegate = self.errorDelegate else { return }

        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    errorDelegate.errorHandling(self, Error.unknownError)
                    completion(false)
                    return
                }

                guard let reponse = response as? HTTPURLResponse, reponse.statusCode == 200 else {
                    if let response = response as? HTTPURLResponse {
                        self.statusCodeErrorHanlding(statusCode: response.statusCode)
                    }
                    completion(false)
                    return
                }

                do {
                    self.translatedQuery = try JSONDecoder().decode(TranslationQuery.self, from: data)
                    self.translationText = self.translatedQuery?.data?.translations?[0].translatedText
                }catch{
                    errorDelegate.errorHandling(self, Error.unknownError)
                    completion(false)
                }
                completion(true)

            }
        })
        task?.resume()
    }

    private func createRequest(_ source : String, _ target : String, _ text : String) -> URLRequest {
        var request = URLRequest(url: URL(string: Constants.TranslationConstants.ENDPOINT + Constants.TranslationConstants.API_KEY)!)
        request.httpMethod = Constants.TranslationConstants.HTTP_METHOD
        let body = Constants.TranslationConstants.SOURCE + source + Constants.TranslationConstants.TARGET + target +
            Constants.TranslationConstants.FORMAT + Constants.TranslationConstants.QUERY + text
        request.httpBody = body.data(using: .utf8)
        return request
    }

    private func statusCodeErrorHanlding(statusCode : Int) {
        guard let errorDelegate = self.errorDelegate else { return }
        switch statusCode {
        case 400...499: errorDelegate.errorHandling(self, Error.webClientError)
        case 500...599: errorDelegate.errorHandling(self, Error.serverError)
        default: errorDelegate.errorHandling(self, Error.unknownError)
        }
    }

}
