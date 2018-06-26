//
//  ErrorDelegateExtension.swift
//  Le Baluchon
//
//  Created by Nicolas on 13/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import UIKit

// ------- Error delegate
// ---------- Weather
extension WeatherViewController : ErrorDelegate {
    func errorHandling(_ sender: Any, _ error: DelegateError) {
        let alert = UIAlertController(title: "Erreur", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        switch error {
        case Error.serverError:
            alert.message = Error.serverError.rawValue
        case Error.webClientError:
            alert.message = Error.webClientError.rawValue
        case Error.unknownError:
            alert.message = Error.unknownError.rawValue
        default :
            alert.message = Error.unknownError.rawValue
        }

        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }

    }
}

// ---------- Translation
extension TranslateViewController : ErrorDelegate {
    func errorHandling(_ sender: Any, _ error: DelegateError) {
        let alert = UIAlertController(title: "Erreur", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        switch error {
        case Error.serverError:
            alert.message = Error.serverError.rawValue
        case Error.webClientError:
            alert.message = Error.webClientError.rawValue
        case Error.unknownError:
            alert.message = Error.unknownError.rawValue
        default :
            alert.message = Error.unknownError.rawValue
        }

        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
