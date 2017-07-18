//
//  WeatherPlaceViewController.swift
//  The Weather App
//
//  Created by Adrian McGee on 10/7/17.
//  Copyright © 2017 Adrian McGee. All rights reserved.
//

import UIKit

class WeatherLocationViewController: UIViewController {

    var selectedWeatherObject: Weather?

    // MARK: - IBOutlets
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var weatherConditionLabel: UILabel!


    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }


    /**  Configure the UI from the selected Weather Object */
    func setupView() {

        if let weather = selectedWeatherObject {

            if let imageName = weather.conditionIconText {

                backgroundImageView.image = UIImage.init(named: "\(imageName).jpg")
                weatherConditionImageView.image = UIImage.init(named: "\(imageName).png")

            }

            if let name = weather.name {
                if let country = weather.country {
                    if let countryName = country.name {
                        placeNameLabel.text = "\(name), \(countryName)"

                    }

                }
            } else {
                placeNameLabel.text = "--"

            }

            if let humidity = weather.humidity {
                humidityLabel.text = humidity
            } else {
                humidityLabel.text = "--"

            }

            if let wind = weather.wind {
                windLabel.text = wind
            } else {
                windLabel.text = "--"

            }

            if let temp = weather.temperature {
                temperatureLabel.text = "\(temp)°"
            } else {
                temperatureLabel.text = "--"

            }

            if let feelsLikeTemp = weather.feelsLikeTemp {
                feelsLikeTemperatureLabel.text = "Feels like \(feelsLikeTemp)°"
            } else {
                feelsLikeTemperatureLabel.text = "--"

            }

            if let condition = weather.condition {
                weatherConditionLabel.text = condition
            } else {
                weatherConditionLabel.text = "--"
            }
        }
    }

    // MARK: - Actions
    @IBAction func backButtonTapped(_ sender: Any) {

        if let navigator = navigationController {
            navigator.popViewController(animated: true)

        }
    }

    // MARK: - Overidden Functions
    override var prefersStatusBarHidden: Bool {
        return true
    }


}
