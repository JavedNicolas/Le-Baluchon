//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Nicolas on 18/05/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

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
    @IBOutlet weak var currentPositionButton: UIButton!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // ---- properties
    internal var weatherTarget: Weather?
    internal var weatherSource: Weather?
    private let tableviewRowHeight = CGFloat(130)
    private let locationManager = CLLocationManager()

    // ---- Actions
    @IBAction func dismissKeyboard(_ sender: Any) {
        textfieldSourceLocation.resignFirstResponder()
        textfieldTargetLocation.resignFirstResponder()
    }

    @IBAction func getCurrentLocationFormButton(_ sender: Any) {
        getLocation()
    }

    @IBAction func valider() {
        loading(true)
        guard let forecastTarget = weatherTarget, let forecastSource = weatherSource else {
            self.errorHandling(self, Error.unknownError)
            loading(false)
            return
        }

        guard let sourceLocation = textfieldSourceLocation.text, let targetLocation = textfieldTargetLocation.text else
        {
            self.errorHandling(self, Error.unknownError)
            loading(false)
            return
        }

        forecastTarget.queryForForecast(inTown: targetLocation) { successTarget in
            if successTarget {
                forecastSource.queryForForecast(inTown: sourceLocation) { successSource in
                    if successSource {
                        self.tableViewForWeatherTarget.reloadData()
                        self.tableViewForWeatherSource.reloadData()
                        self.tableViewForWeatherDate.reloadData()

                        guard let locationSource = forecastSource.forecast?.location.city else { return }
                        guard let locationTarget = forecastTarget.forecast?.location.city else { return }

                        self.sourceLabel.text = locationSource
                        self.targetLabel.text = locationTarget
                        self.dateLabel.text = "Date"
                    }
                    self.loading(false)
                }
            }else {
                self.loading(false)
            }
        }
    }

    // ---- functions
    override func viewDidLoad() {
        super.viewDidLoad()

        loading(false)
        weatherTarget = Weather()
        guard let forecastTarget = weatherTarget else {return}
        forecastTarget.errorDelegate = self

        weatherSource = Weather()
        guard let forecastSource = weatherSource else {return}
        forecastSource.errorDelegate = self

        tableViewForWeatherDate.rowHeight = tableviewRowHeight
        tableViewForWeatherSource.rowHeight = tableviewRowHeight
        tableViewForWeatherTarget.rowHeight = tableviewRowHeight
        launchPositionLocation()
        getLocation()
    }

    func launchPositionLocation() {
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }

    func getLocation() {
        let geocoder = CLGeocoder()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            guard let forecastTarget = self.weatherTarget,
                let errorDelegate = forecastTarget.errorDelegate else {return}
            guard let location = locationManager.location else {
                errorDelegate.errorHandling(self, Error.localisationProblem)
                return
            }
            
            geocoder.reverseGeocodeLocation(location) { (placemark, error) in
                if (error != nil) {
                    errorDelegate.errorHandling(self, Error.localisationProblem)
                }else {
                    guard let placemark = placemark, let lastLocation = placemark.last, let city = lastLocation.locality else {
                        errorDelegate.errorHandling(self, Error.localisationProblem)
                        return
                    }
                    self.textfieldSourceLocation.text = city
                }
            }
        }else {
            currentPositionButton.isHidden = true
        }

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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


