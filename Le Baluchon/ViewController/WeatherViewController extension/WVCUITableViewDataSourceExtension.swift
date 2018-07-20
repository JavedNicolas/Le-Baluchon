//
//  UITableViewDataSourceExtension.swift
//  Le Baluchon
//
//  Created by Nicolas on 13/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import UIKit

extension WeatherViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let forecastInfos = weatherTarget else { return 0 }

        return forecastInfos.forecast.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        if tableView == self.tableViewForWeatherDate {
            cell = setDateCell(tableView, cellForRowAt: indexPath)
        }else {
            cell = setConditionCell(tableView, cellForRowAt: indexPath)
        }

        return cell
    }

    /**
        Set the condition cell content

        - parameters:
            - tableView : UITableView in which the setting is being done
            - indexPath : index of the cell currently being set

        - returns: the UITableViewCell that has been set
    */
    private func setConditionCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConditionCell", for: indexPath) as! WeatherTableCell

        var forecastInfo : Weather.Forecast!
        switch tableView {
        case self.tableViewForWeatherTarget :
            forecastInfo = weatherTarget
        case self.tableViewForWeatherSource :
            forecastInfo = weatherSource
        default :
            break
        }

        guard let low = forecastInfo.forecast[indexPath.row].low,
            let high = forecastInfo.forecast[indexPath.row].high, let code = forecastInfo.forecast[indexPath.row].code,
            let codeAsInt = Int(code)
            else {
                self.errorHandling(self, Error.unknownError)
                return cell
            }

        cell.weatherTextLabel.text = weatherCodes[codeAsInt]

        guard let lowCelcius = Float(low), let highCelcius = Float(high) else {return cell}
        let roundedLowCelcius = String(format: "%.0F" , Weather.shared.fahrenheitToCelcius(lowCelcius))
        let roundedHighCelcius = String(format : "%.0F", Weather.shared.fahrenheitToCelcius(highCelcius))
        cell.temperatureLabel.text = "Entre \(roundedLowCelcius )°C et :\(roundedHighCelcius)°C"

        let url = URL(string: "https://s.yimg.com/zz/combo?a/i/us/nws/weather/gr/\(code)d.png")
        let data = try? Data(contentsOf: url!)
        cell.weahterImageView.image = UIImage(data: data!)

        return cell
    }

    /**
        Set the date cell content

        - parameters:
            - tableView : UITableView in which the setting is being done
            - indexPath : index of the cell currently being set

        - returns: the UITableViewCell that has been set
     */
    private func setDateCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateTableCell
        if let forecastInfosTarget = weatherTarget {

            guard let day = forecastInfosTarget.forecast[indexPath.row].day,
                let date = forecastInfosTarget.forecast[indexPath.row].date
                else {
                    self.errorHandling(self, Error.unknownError)
                    return cell
                }

            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "dd-MMM-yyyy"

            if let date = dateFormatter.date(from: date) {
                dateFormatter.locale = Locale(identifier: "fr")
                dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dd-MMMM", options: 0, locale: dateFormatter.locale)
                let frenchDate = dateFormatter.string(from: date)
                cell.dayLabel.text = enToFrDay[day]
                cell.dateLabel.text = frenchDate
            } else {
                self.errorHandling(self, Error.unknownError)
            }
        }
        return cell
    }

}
