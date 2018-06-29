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

    // ----- struct
    struct Money {
        var apiName : String
        var symbol : String
        var name : String
    }


    // ---- Attribut
    private var change : Change?
    private var alert : UIAlertController!

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
            loading(true)
            let changeName = getSegmentedControlText(targetSegmentedControl)
            guard let amoutString = amoutTextfield.text else {
                change.errorDelegate!.errorHandling(self, Error.emptyFiled)
                loading(false)
                return
            }

            let amout = NSString(string: amoutString).doubleValue
            change.queryForChange(changeName.apiName) {
                self.titleLabel.text = "Conversion de euro à \(changeName.name)"
                self.separator.isHidden = false
                guard let result = change.rateResult, let date = result.date else { return }
                guard let rate = result.rates, let rateValue = rate[changeName.apiName] else { return }

                self.resultLabel.text = "\(self.formatDoubles(change.conversion(rateValue, amout))) \(changeName.symbol) "
                self.rateLabel.text = "Taux de : \(self.formatDoubles(rateValue)) \(changeName.symbol) pour 1 €"
                self.dateLabel.text = "Dernière mise à jours le \(date)"
                self.loading(false)
                self.amoutTextfield.resignFirstResponder()
            }
        }
    }

    // ---- Actions
    @IBAction func dismissKeyboard(_ sender: Any) {
        amoutTextfield.resignFirstResponder()
    }

    //----- func
    func formatDoubles(_ numberToFormat: Double) -> Double {
        let numberAsString = String(format: "%.2f", numberToFormat)
        let number = NSString(string: numberAsString).doubleValue
        return number
    }

    func getSegmentedControlText(_ segmentedControl : UISegmentedControl) -> Money {
        let index = segmentedControl.selectedSegmentIndex
        switch index {
        case 0: return Money(apiName: "USD", symbol: "$", name: "Dollar")
        case 1: return Money(apiName: "JPY", symbol: "¥",name: "Yen Japonaise")
        case 2: return Money(apiName:"GBP", symbol:"£",name: "Livre Anglaise")
        default:
            return Money(apiName: "USD", symbol: "$",name: "Dollar")
        }
    }

    func loading(_ display: Bool) {
        if display == true {
            let title = "Chargement"
            let message = "Les taux de changes sont en cours de chargement. \n Merci de bien vouloir patienter ..."
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
        }else{
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
}


