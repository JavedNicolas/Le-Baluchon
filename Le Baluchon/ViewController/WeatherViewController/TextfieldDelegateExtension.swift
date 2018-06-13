//
//  TextfieldDelegateExtension.swift
//  Le Baluchon
//
//  Created by Nicolas on 13/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import UIKit


//------- Ui textfiled delegate
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.returnKeyType{
        case .default: textField.resignFirstResponder()
        case .done : valider()
        textField.resignFirstResponder()
        case .next : textfieldTargetLocation.becomeFirstResponder()
        default : textField.resignFirstResponder()
        }
        return true
    }

}