//
//  File.swift
//  Le Baluchon
//
//  Created by Nicolas on 26/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

struct ChangeQuery : Decodable {
    let success : Bool?
    let base : String?
    let date : String?
    let rates : [String:Double]?
}

