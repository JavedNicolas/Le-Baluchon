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
    internal var weatherTarget: Weather?
    internal var weatherSource: Weather?


    // ---- Actions
    @IBAction func dismissKeyboard(_ sender: Any) {
        textfieldSourceLocation.resignFirstResponder()
        textfieldTargetLocation.resignFirstResponder()
    }

    @IBAction func valider() {
        guard let forecastTarget = weatherTarget, let forecastSource = weatherSource else {return}

        guard let sourceLocation = textfieldSourceLocation.text, let targetLocation = textfieldTargetLocation.text else
        { return }

            forecastTarget.queryForForecast(inTown: targetLocation) { statusCode in
                forecastSource.queryForForecast(inTown: sourceLocation) { statusCode in
                    DispatchQueue.main.async {
                        self.tableViewForWeather.reloadData()
                    }
                }
            }
    }

    // ---- functions
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTarget = Weather()
        guard let forecastTarget = weatherTarget else {return}
        forecastTarget.errorDelegate = self

        weatherSource = Weather()
        guard let forecastSource = weatherSource else {return}
        forecastSource.errorDelegate = self
0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fahrenheitToCelcius( _ temp: Float) -> Float{
        return (temp - 32) / 1.8

    }

}


