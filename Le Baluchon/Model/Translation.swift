//
//  Translation.swift
//  Le Baluchon
//
//  Created by Nicolas on 20/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

class Translation : ApiQuery {

    //----- Attribut
    private let prefix = "https://translation.googleapis.com/language/translate/v2"
    private var suffix = ""
    private let format = "text"
    private let key = GoogleTranslateApiKey
    var translationText : String?
    var translatedQuery : TranslationQuery?

    init() {
        super.init(prefix, "", "")
    }

    init(session : URLSession){
        super.init(prefix, "", "")
        self.defaultSessions = session
    }

    func queryForTranslation(sentence : String, sourceLanguage: String, targetLanguage : String, completion : @escaping () -> () ) {
        suffix = "&source=\(sourceLanguage)&target=\(targetLanguage)&format=\(format)"
        let query = "key=\(key)&q=\(sentence)\(suffix)"
        initQuery(query)

        guard let errorDelegate = self.errorDelegate else { return }

        self.launchQuery(success: { (data) in
            do {
                self.translatedQuery = try JSONDecoder().decode(TranslationQuery.self, from: data)
                self.translationText = self.translatedQuery?.data?.translations?[0].translatedText
            }catch{
                errorDelegate.errorHandling(self, Error.unknownError)
            }
            completion()
        }) { statusCode in
            switch statusCode {
            case 400...499: errorDelegate.errorHandling(self, Error.webClientError)
            case 500...599: errorDelegate.errorHandling(self, Error.serverError)
            default: errorDelegate.errorHandling(self, Error.unknownError)
            }
        }
    }
}
