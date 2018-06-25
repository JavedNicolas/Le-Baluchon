//
//  TVCTextfieldDelegateExtension.swift
//  Le Baluchon
//
//  Created by Nicolas on 22/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import UIKit


//------- Ui textfiled delegate
extension TranslateViewController : UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        switch textView.returnKeyType {
        case .default: textView.resignFirstResponder()
        case .done : valider()
        textView.resignFirstResponder()
        default : textView.resignFirstResponder()
        }
        return true
    }

}
