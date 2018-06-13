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
        guard let forecastInfos = weather?.forecast else { return 0 }

        return forecastInfos.forecast.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConditionCell", for: indexPath) as! WeatherTableCell
        if let forecastInfos = weather?.forecast {
            guard let text = forecastInfos.forecast[indexPath.row].text, let date = forecastInfos.forecast[indexPath.row].date,
                let low = forecastInfos.forecast[indexPath.row].low,
                let high = forecastInfos.forecast[indexPath.row].high
            else { return cell }

            cell.weatherText.text = text
            cell.date.text = date

            guard let lowCelcius = Float(low), let highCelcius = Float(high) else {return cell}
            let roundedLowCelcius = String(format: "%.1F" ,fahrenheitToCelcius(lowCelcius))
            let roundedHighCelcius = String(format : "%.1F", fahrenheitToCelcius(highCelcius))
            cell.temperature.text = "\(roundedLowCelcius ) - \(roundedHighCelcius)°C"
        }

        return cell
    }
    
}
