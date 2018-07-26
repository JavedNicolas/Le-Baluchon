//
//  ChangeViewController.swift
//  Le Baluchon
//
//  Created by Nicolas on 18/05/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import UIKit

class ChangeViewController: UIViewController {

    // ------ Outlet
    @IBOutlet weak var targetSegmentedControl: UISegmentedControl!
    @IBOutlet weak var amoutTextfield: UITextField!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // ----- struct
    struct Money {
        var apiName : String
        var symbol : String
        var name : String
    }

    // ---- Attribut
    private var change : Change?

    // --------- VC functions
    override func viewDidLoad() {
        super.viewDidLoad()
        loading(false)

        Change.shared.errorDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // ---- action
    @IBAction func valider() {
        loading(true)

        let changeName = getSegmentedControlText(targetSegmentedControl)
        guard let amoutString = amoutTextfield.text else {
            Change.shared.errorDelegate!.errorHandling(self, Error.emptyFiled)
            loading(false)
            return
        }

        let amout = NSString(string: amoutString).doubleValue
        Change.shared.queryForChange(changeName.apiName) { success, changeResult in
            if success {
                self.titleLabel.text = "Conversion de euro à \(changeName.name)"
                self.separator.isHidden = false
                guard let result = changeResult, let date = result.date else {
                    self.errorHandling(self, Error.unknownError)
                    self.loading(false)
                    return
                }
                guard let rate = result.rates, let rateValue = rate[changeName.apiName] else {
                    self.errorHandling(self, Error.unknownError)
                    self.loading(false)
                    return
                }

                self.resultLabel.text = "\(self.formatDoubles(Change.shared.conversion(rateValue, amout))) \(changeName.symbol) "
                self.rateLabel.text = "Taux de : \(self.formatDoubles(rateValue)) \(changeName.symbol) pour 1 €"
                self.dateLabel.text = "Dernière mise à jours le \(date)"
                self.amoutTextfield.resignFirstResponder()
            }
            self.loading(false)
        }
    }

    // ---- Actions
    @IBAction func dismissKeyboard(_ sender: Any) {
        amoutTextfield.resignFirstResponder()
    }

    //----- functions
    /** return a formated double with 2 decimals */
    private func formatDoubles(_ numberToFormat: Double) -> Double {
        let numberAsString = String(format: "%.2f", numberToFormat)
        let number = NSString(string: numberAsString).doubleValue
        return number
    }

    /** return a Money variable depending on the segmented controller */
    private func getSegmentedControlText(_ segmentedControl : UISegmentedControl) -> Money {
        let index = segmentedControl.selectedSegmentIndex
        switch index {
        case 0: return Money(apiName: "USD", symbol: "$", name: "Dollar")
        case 1: return Money(apiName: "JPY", symbol: "¥",name: "Yen Japonaise")
        case 2: return Money(apiName:"GBP", symbol:"£",name: "Livre Anglaise")
        default:
            return Money(apiName: "USD", symbol: "$",name: "Dollar")
        }
    }

    /** Display or hide the loading bar*/
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


