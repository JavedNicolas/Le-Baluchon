//
//  WeatherTableView.swift
//  Le Baluchon
//
//  Created by Nicolas on 20/06/2018.
//  Copyright © 2018 Nicolas. All rights reserved.
//

import UIKit

class WeatherTableView : UITableView {

    let neededRowHeight = CGFloat(150)

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        rowHeight = neededRowHeight
    }
}
