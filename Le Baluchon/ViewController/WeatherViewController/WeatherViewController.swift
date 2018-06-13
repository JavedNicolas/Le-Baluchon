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
    internal var weather: Weather?


    // ---- Actions
    @IBAction func dismissKeyboard(_ sender: Any) {
        textfieldSourceLocation.resignFirstResponder()
        textfieldTargetLocation.resignFirstResponder()
    }

    @IBAction func valider() {
        guard let forecast = weather else {return}

        forecast.queryForForecast(inTown: "Paris, fr") { statusCode in
            DispatchQueue.main.async {
                self.tableViewForWeather.reloadData()
            }
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

    func fahrenheitToCelcius( _ temp: Float) -> Float{
        return (temp - 32) / 1.8

    }

}


