//
//  ErrorDelegateAction.swift
//  Le Baluchon
//
//  Created by Nicolas on 13/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import Foundation

protocol DelegateError {}

protocol ErrorDelegate : class {
    func errorHandling(_ sender: Any, _ error : DelegateError)
}
