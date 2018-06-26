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

    // ----- attributs
    private var translation : Translation?
    internal var alert : UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        translation = Translation()

        if let translation = translation {
            translation.errorDelegate = self
        }
    }

    // ---- Actions
    @IBAction func dismissKeyboard(_ sender: Any) {
        sourceTextField.resignFirstResponder()
        targetTextField.resignFirstResponder()
    }

    @IBAction func valider() {

        guard let translation = translation else { return }
        translation.queryForTranslation(sentence: sourceTextField.text, sourceLanguage: "fr", targetLanguage: "en", completion: {
            DispatchQueue.main.async {
                self.targetTextField.text = translation.translationText
            }

        })
    }

    // ----- method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
