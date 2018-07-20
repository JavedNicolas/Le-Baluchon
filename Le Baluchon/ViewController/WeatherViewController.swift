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
    internal var weatherTarget: Weather.Forecast?
    internal var weatherSource: Weather.Forecast?
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

        guard let sourceLocation = textfieldSourceLocation.text, let targetLocation = textfieldTargetLocation.text else
        {
            self.errorHandling(self, Error.unknownError)
            loading(false)
            return
        }

        Weather.shared.queryForForecast(inTown: targetLocation) { success, forecast in
            if success{
                self.weatherTarget = forecast
                Weather.shared.queryForForecast(inTown: sourceLocation) { success, forecast in
                    if success{
                        self.weatherSource = forecast
                        self.displayForecast()
                        self.loading(false)
                    }else {
                        self.loading(false)
                    }
                }
            }else {
                self.loading(false)
            }
        }


    }

    private func displayForecast() {
        self.tableViewForWeatherTarget.reloadData()
        self.tableViewForWeatherSource.reloadData()
        self.tableViewForWeatherDate.reloadData()

        guard let weatherSource = weatherSource,
            let locationSource = weatherSource.location.city else { return }
        guard let weatherTarget = weatherTarget,
            let locationTarget = weatherTarget.location.city else { return }

        self.sourceLabel.text = locationSource
        self.targetLabel.text = locationTarget
        self.dateLabel.text = "Date"
    }

    // ---- functions
    override func viewDidLoad() {
        super.viewDidLoad()

        loading(false)
        Weather.shared.errorDelegate = self

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
            guard let errorDelegate = Weather.shared.errorDelegate else {return}
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


