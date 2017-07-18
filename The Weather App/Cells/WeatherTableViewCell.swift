//
//  WeatherTableViewCell.swift
//  The Weather App
//
//  Created by Adrian McGee on 8/7/17.
//  Copyright © 2017 Adrian McGee. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    // MARK: IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
