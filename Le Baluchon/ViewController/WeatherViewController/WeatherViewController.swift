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
    @IBOutlet weak var tableViewForWeatherSource: UITableView!
    @IBOutlet weak var tableViewForWeatherTarget: UITableView!
    @IBOutlet weak var tableViewForWeatherDate: UITableView!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var sourceLabel : UILabel!
    @IBOutlet weak var targetLabel : UILabel!

    // ---- properties
    internal var weatherTarget: Weather?
    internal var weatherSource: Weather?
    private let tableviewRowHeight = CGFloat(130)


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
                    self.tableViewForWeatherTarget.reloadData()
                    self.tableViewForWeatherSource.reloadData()
                    self.tableViewForWeatherDate.reloadData()

                    guard let locationSource = forecastSource.forecast?.location.city else { return }
                    guard let locationTarget = forecastTarget.forecast?.location.city else { return }

                    self.sourceLabel.text = locationSource
                    self.targetLabel.text = locationTarget
                    self.dateLabel.text = "Date"

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

        tableViewForWeatherDate.rowHeight = tableviewRowHeight
        tableViewForWeatherSource.rowHeight = tableviewRowHeight
        tableViewForWeatherTarget.rowHeight = tableviewRowHeight
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fahrenheitToCelcius( _ temp: Float) -> Float{
        return (temp - 32) / 1.8

    }

}


