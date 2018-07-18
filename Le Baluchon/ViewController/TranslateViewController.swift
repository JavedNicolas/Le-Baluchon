//
//  TranslateViewController.swift
//  Le Baluchon
//
//  Created by Nicolas on 18/05/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {

    // ------ outlets
    @IBOutlet weak var sourceTextField: UITextView!
    @IBOutlet weak var targetTextField: UITextView!
    @IBOutlet weak var validateButton: UIButton!
     @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // ----- attributs
    private var translation : Translation?

    override func viewDidLoad() {
        super.viewDidLoad()
        loading(false)
        Translation.shared.errorDelegate = self

    }

    // ---- Actions
    @IBAction func dismissKeyboard(_ sender: Any) {
        sourceTextField.resignFirstResponder()
        targetTextField.resignFirstResponder()
    }

    @IBAction func valider() {
        loading(true)

        Translation.shared.queryForTranslation(sentence: sourceTextField.text, completion: { success in
            if success {
                self.targetTextField.text = Translation.shared.translationText
            }
            self.loading(false)
        })
    }

    // ----- method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func loading(_ isLoading: Bool ) {
        activityIndicator.isHidden = !isLoading
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        validateButton.isHidden = isLoading
    }

}
