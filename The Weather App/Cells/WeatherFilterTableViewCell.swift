//
//  WeatherFilterTableViewCell.swift
//  The Weather App
//
//  Created by Adrian McGee on 9/7/17.
//  Copyright © 2017 Adrian McGee. All rights reserved.
//

import UIKit

class WeatherFilterTableViewCell: UITableViewCell {
    // MARK: IBOutlets
    @IBOutlet weak var filterLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
