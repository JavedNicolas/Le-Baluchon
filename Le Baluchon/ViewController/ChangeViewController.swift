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
    @IBOutlet weak var targetTextfield: UITextField!
    @IBOutlet weak var amoutTextfield: UITextField!

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // ---- Attribut
    private var change : Change?

    // ---- func
    override func viewDidLoad() {
        super.viewDidLoad()
        change = Change()

        if let change = self.change {
            change.errorDelegate = self
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // ---- action
    @IBAction func valider() {
        if let change = change {

            guard let changeName = targetTextfield.text else {
                change.errorDelegate!.errorHandling(self, Error.emptyFiled)
                return
            }
            guard let amoutString = amoutTextfield.text else {
                change.errorDelegate!.errorHandling(self, Error.emptyFiled)
                return
            }
            
            let amout = NSString(string: amoutString).doubleValue

            change.queryForChange(changeName) {
                guard let result = change.rateResult, let date = result.date else { return }
                guard let rate = result.rates, let rateValue = rate[changeName] else { return }

                self.resultLabel.text = "\(self.formatDoubles(change.conversion(rateValue, amout))) \(changeName) "
                self.rateLabel.text = "Taux de : \(self.formatDoubles(rateValue)) \(changeName) pour 1 EUR"
                self.dateLabel.text = "Dernière mise à jours le \(date)"
            }
        }
    }

    // ---- Actions
    @IBAction func dismissKeyboard(_ sender: Any) {
        targetTextfield.resignFirstResponder()
        amoutTextfield.resignFirstResponder()
    }

    //----- func
    func formatDoubles(_ numberToFormat: Double) -> Double {
        let numberAsString = String(format: "%.2f", numberToFormat)
        let number = NSString(string: numberAsString).doubleValue
        return number

    }
}


