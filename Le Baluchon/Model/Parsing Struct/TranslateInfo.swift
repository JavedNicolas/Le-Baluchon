//
//  TranslateInfo.swift
//  Le Baluchon
//
//  Created by Nicolas on 20/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

struct TranslationQuery : Decodable {
    let data : TranslationData?
}

struct TranslationData : Decodable{
    let translations : [TranslatedText]?
}

struct TranslatedText : Decodable {
    let translatedText : String?
}
