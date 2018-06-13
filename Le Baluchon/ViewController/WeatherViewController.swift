//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Nicolas on 18/05/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {


    // ---- Outlets
    @IBOutlet weak var textfieldSourceLocation: UITextField!
    @IBOutlet weak var buttonSourceLocation: UIButton!
    @IBOutlet weak var textfieldTargetLocation: UITextField!
    @IBOutlet weak var buttonValidate: UIButton!
    @IBOutlet weak var tableViewForWeather: UITableView!

    // ---- properties
    private var weather: Weather?


    // ---- Actions
    @IBAction func dismissKeyboard(_ sender: Any) {
        textfieldSourceLocation.resignFirstResponder()
        textfieldTargetLocation.resignFirstResponder()
    }

    @IBAction func valider() {
        guard let forecast = weather else {return}

        forecast.queryForForecast(inTown: "Paris, fr") { statusCode in

        }
    }

    // ---- functions
    override func viewDidLoad() {
        super.viewDidLoad()
        weather = Weather()
        guard let forecast = weather else {return}

        forecast.errorDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WeatherViewController : ErrorDelegate {
    func errorHandling(_ sender: Any, _ error: DelegateError) {
        let alert = UIAlertController(title: "Erreur", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        switch error {
        case Error.serverError:
                alert.message = Error.serverError.rawValue
        case Error.webClientError:
            alert.message = Error.webClientError.rawValue
        case Error.unknownError:
            alert.message = Error.unknownError.rawValue
        default :
            alert.message = Error.unknownError.rawValue
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

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
