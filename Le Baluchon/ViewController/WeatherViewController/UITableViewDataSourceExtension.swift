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
            guard let text = forecastInfos.forecast[indexPath.row].text,
                let date = forecastInfos.forecast[indexPath.row].date,
                let day = forecastInfos.forecast[indexPath.row].day,
                let low = forecastInfos.forecast[indexPath.row].low,
                let high = forecastInfos.forecast[indexPath.row].high,
                let code = forecastInfos.forecast[indexPath.row].code
            else { return cell }

            cell.weatherTextLabel.text = text
            cell.dateLabel.text = "\(day) : \(date)"

            guard let lowCelcius = Float(low), let highCelcius = Float(high) else {return cell}
            let roundedLowCelcius = String(format: "%.0F" ,fahrenheitToCelcius(lowCelcius))
            let roundedHighCelcius = String(format : "%.0F", fahrenheitToCelcius(highCelcius))
            cell.temperatureLabel.text = "Entre \(roundedLowCelcius )°C et :\(roundedHighCelcius)°C"

            let url = URL(string: "https://s.yimg.com/zz/combo?a/i/us/nws/weather/gr/\(code)d.png")
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            cell.weahterImageView.image = UIImage(data: data!)
        }

        return cell
    }

    
}
