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
    internal var alert : UIAlertController!

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
        guard let translation = translation else {
            self.errorHandling(self, Error.unknownError)
            return
        }
        
        loading(true)
        translation.queryForTranslation(sentence: sourceTextField.text, sourceLanguage: "fr", targetLanguage: "en", completion: {
            self.targetTextField.text = translation.translationText
            self.loading(false)
        })
    }

    // ----- method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func loading(_ display: Bool) {
        if display == true {
            let title = "Chargement"
            let message = "La traduction est en cours. \n Merci de bien vouloir patienter ..."
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
        }else{
            alert.dismiss(animated: true, completion: nil)
        }
    }

}
