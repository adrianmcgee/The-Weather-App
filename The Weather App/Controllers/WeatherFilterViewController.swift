//
//  WeatherFilterViewController.swift
//  The Weather App
//
//  Created by Adrian McGee on 9/7/17.
//  Copyright © 2017 Adrian McGee. All rights reserved.
//

import UIKit

// MARK: - Delegate

protocol WeatherFilterViewControllerDelegate {
    func sendFilter(countryName: String?, weatherCondition: String?)
}

//MARK: - UIViewController Properties

class WeatherFilterViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource {


    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    var delegate: WeatherFilterViewControllerDelegate?
    var weatherObjectsArray: [Weather] = []
    var countriesSet = Set<String>()
    var weatherConditionSet = Set<String>()
    var countriesArray = [String]()
    var weatherConditionsArray = [String]()
    var selectedCountryString: String?
    var selectedWeatherConditionString: String?


    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupArrays()

        //Hide Empty Cells AT Bottom of TableView
        tableView.tableFooterView = UIView()

    }

    /**  Configure Country and Weather Condition arrays from array of Weather objects */
    func setupArrays() {

        for item in weatherObjectsArray {
            if let country = item.country {
                if let countryName = country.name {
                    countriesArray.append(countryName)
                }
            }

            if let weatherCondition = item.condition {
                weatherConditionsArray.append(weatherCondition)
            }
        }

        countriesSet = Set(countriesArray.map {
            $0
        })
        countriesArray = Array(countriesSet)
        countriesArray.insert("All", at: 0)
        countriesArray = countriesArray.sorted {
            $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending
        }

        weatherConditionSet = Set(weatherConditionsArray.map {
            $0
        })
        weatherConditionsArray = Array(weatherConditionSet)
        weatherConditionsArray = weatherConditionsArray.sorted {
            $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending
        }
        weatherConditionsArray.insert("All", at: 0)

    }



    // MARK: - Table View Delegate Functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Instantiate a cell
        let cell: WeatherFilterTableViewCell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath as IndexPath) as! WeatherFilterTableViewCell

        if indexPath.section == 0 {
            let currentCountry = countriesArray[indexPath.row]
            cell.filterLabel.text = currentCountry

            if let country = selectedCountryString {
                if country == currentCountry {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            } else {
                if currentCountry == "All" {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }

        } else {
            let currentCondition = weatherConditionsArray[indexPath.row]

            cell.filterLabel.text = currentCondition


            if let condition = selectedWeatherConditionString {
                if condition == currentCondition {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            } else {
                if currentCondition == "All" {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
        }

        cell.selectionStyle = UITableViewCellSelectionStyle.none

        return cell
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return countriesArray.count
        } else {
            return weatherConditionsArray.count
        }

    }


    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /**  Update selected cells and filter strings */
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }

        if indexPath.section == 0 {
            selectedCountryString = countriesArray[indexPath.row]
        } else {
            selectedWeatherConditionString = weatherConditionsArray[indexPath.row]
        }

        tableView.reloadData()
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none

    }


    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if section == 0 {
            return "Country"

        } else {
            return "Weather Condition"
        }
    }


    // MARK: - Actions
    @IBAction func doneButtonTapped(_ sender: Any) {

        /**  Pass Filters back to MainViewController */
        if let delegate = delegate {
            if let selectedCountry = selectedCountryString {

                if let selectedCondition = selectedWeatherConditionString {
                    delegate.sendFilter(countryName: selectedCountry, weatherCondition: selectedCondition)


                } else {
                    delegate.sendFilter(countryName: selectedCountry, weatherCondition: nil)

                }

            } else {
                if let selectedCondition = selectedWeatherConditionString {
                    delegate.sendFilter(countryName: nil, weatherCondition: selectedCondition)

                }
            }
        } else {
            print("Delegate is not set")
        }

        dismiss(animated: true)
    }

    // MARK: - Overidden Functions
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
