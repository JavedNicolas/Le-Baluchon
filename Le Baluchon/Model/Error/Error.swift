//
//  Error.swift
//  Le Baluchon
//
//  Created by Nicolas on 13/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

// ------- Enum
enum Error : String, DelegateError{
    case webClientError = "Une erreur est survenue, verifié votre connexion internet ou les informations de votre demande."
    case serverError = "Une erreur est survenue sur le serveur. Merci de bien vouloir ressayer plus tard"
    case unknownError = "Une erreur est survenue. Merci de bien vouloir ressayer plus tard"
}
