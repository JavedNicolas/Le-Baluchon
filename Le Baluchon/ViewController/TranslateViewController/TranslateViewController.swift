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

    @IBAction func valider(_ sender: Any) {

        guard let translation = translation else { return }
        translation.queryForTranslation(sentence: sourceTextField.text, sourceLanguage: "fr", targetLanguage: "en", completion: {
            self.targetTextField.text = translation.translationText
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
