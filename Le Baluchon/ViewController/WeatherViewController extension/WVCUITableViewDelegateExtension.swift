//
//  UITableViewDelegateExtension.swift
//  Le Baluchon
//
//  Created by Nicolas on 13/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import UIKit

extension WeatherViewController : UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableViewForWeatherSource {
            self.tableViewForWeatherTarget.setContentOffset(scrollView.contentOffset, animated: false)
            self.tableViewForWeatherDate.setContentOffset(scrollView.contentOffset, animated: false)
        }else if scrollView == self.tableViewForWeatherTarget {
            self.tableViewForWeatherSource.setContentOffset(scrollView.contentOffset, animated: false)
            self.tableViewForWeatherDate.setContentOffset(scrollView.contentOffset, animated: false)
        }else if scrollView == self.tableViewForWeatherDate {
            self.tableViewForWeatherSource.setContentOffset(scrollView.contentOffset, animated: false)
            self.tableViewForWeatherTarget.setContentOffset(scrollView.contentOffset, animated: false)
        }
    }
}
