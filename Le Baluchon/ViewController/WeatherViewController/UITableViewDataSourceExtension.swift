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
        guard let forecastInfos = weatherTarget?.forecast else { return 0 }

        return forecastInfos.forecast.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConditionCell", for: indexPath) as! WeatherTableCell
        if let forecastInfosTarget = weatherTarget?.forecast, let forecastInfosSource = weatherSource?.forecast {
            guard let textTarget = forecastInfosTarget.forecast[indexPath.row].text,
                let dateTarget = forecastInfosTarget.forecast[indexPath.row].date,
                let dayTarget = forecastInfosTarget.forecast[indexPath.row].day,
                let lowTarget = forecastInfosTarget.forecast[indexPath.row].low,
                let highTarget = forecastInfosTarget.forecast[indexPath.row].high,
                let codeTarget = forecastInfosTarget.forecast[indexPath.row].code
            else { return cell }

            guard let text = forecastInfosSource.forecast[indexPath.row].text,
                let dateSource = forecastInfosSource.forecast[indexPath.row].date,
                let daySource = forecastInfosSource.forecast[indexPath.row].day,
                let lowSource = forecastInfosSource.forecast[indexPath.row].low,
                let highSource = forecastInfosSource.forecast[indexPath.row].high,
                let codeSource = forecastInfosSource.forecast[indexPath.row].code
                else { return cell }

            cell.weatherTextLabelTarget.text = textTarget
            cell.dateLabelTarget.text = "\(dayTarget) : \(dateTarget)"

            guard let lowCelciusTarget = Float(lowTarget), let highCelciusTarget = Float(highTarget) else {return cell}
            let roundedLowCelciusTarget = String(format: "%.0F" ,fahrenheitToCelcius(lowCelciusTarget))
            let roundedHighCelciusTarget = String(format : "%.0F", fahrenheitToCelcius(highCelciusTarget))
            cell.temperatureLabelTarget.text = "Entre \(roundedLowCelciusTarget )°C et :\(roundedHighCelciusTarget)°C"

            let urlTarget = URL(string: "https://s.yimg.com/zz/combo?a/i/us/nws/weather/gr/\(codeTarget)d.png")
            let dataTarget = try? Data(contentsOf: urlTarget!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            cell.weahterImageViewTarget.image = UIImage(data: dataTarget!)

            cell.weatherTextLabelSource.text = text
            cell.dateLabelSource.text = "\(daySource) : \(dateSource)"

            guard let lowCelciusSource = Float(lowSource), let highCelciusSource = Float(highSource) else {return cell}
            let roundedLowCelciusSource = String(format: "%.0F" ,fahrenheitToCelcius(lowCelciusSource))
            let roundedHighCelciusSource = String(format : "%.0F", fahrenheitToCelcius(highCelciusSource))
            cell.temperatureLabelSource.text = "Entre \(roundedLowCelciusSource )°C et :\(roundedHighCelciusSource)°C"

            let urlSource = URL(string: "https://s.yimg.com/zz/combo?a/i/us/nws/weather/gr/\(codeSource)d.png")
            let dataSource = try? Data(contentsOf: urlSource!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            cell.weahterImageViewSource.image = UIImage(data: dataSource!)
        }

        return cell
    }

    
}
