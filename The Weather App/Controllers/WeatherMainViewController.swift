//
//  WeatherMainViewController.swift
//  The Weather App
//
//  Created by Adrian McGee on 6/7/17.
//  Copyright © 2017 Adrian McGee. All rights reserved.
//

import UIKit

//MARK: - UIViewController Properties

class WeatherMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate, WeatherFilterViewControllerDelegate {


    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedFilterControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var headerLabelHeightConstraint: NSLayoutConstraint!


    // MARK: - Properties
    /**
     Arrays:
            - unfilteredWeatherObjectsArray is used when no filtering is selected
            - filteredWeatherObjectsArray is used when country/condition filtering is selected
            - masterSearchedWeatherObjectsArray is used to search against via the the UISearchBar
    */
    var weatherObjectsArray: [Weather] = []
    var unfilteredWeatherObjectsArray: [Weather] = []
    var filteredWeatherObjectsArray: [Weather] = []
    var masterFilteredWeatherObjectsArray: [Weather] = []
    var masterUnfilteredWeatherObjectsArray: [Weather] = []

    /**  'usingFilter' is true when there this a country/weather condition filter selected */
    var usingFilter: Bool = false

    /**  filters */
    var selectedCountryString: String?
    var selectedWeatherConditionString: String?


    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //Retrieve Weather Objects
        weatherObjectsArray = WeatherManager.shared.retrieveJsonDataAndParseIntoSortedArray()

        if weatherObjectsArray.count == 0 {
            showAlertWithTitleAndMessage(title: "Hmmm!", message: "No data received. Are you connected to the internet?")
        }

        /**
            Initialize Arrays
        */
        unfilteredWeatherObjectsArray = weatherObjectsArray
        filteredWeatherObjectsArray = unfilteredWeatherObjectsArray
        masterUnfilteredWeatherObjectsArray = unfilteredWeatherObjectsArray


        //Hide Empty Cells AT Bottom of TableView
        tableView.tableFooterView = UIView()

    }


    // MARK: TableView Delegate Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {


        if usingFilter {
            return filteredWeatherObjectsArray.count

        } else {
            return unfilteredWeatherObjectsArray.count

        }

    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Getting the right element
        var weatherObject: Weather
        if usingFilter {
            weatherObject = filteredWeatherObjectsArray[indexPath.row]
        } else {
            weatherObject = unfilteredWeatherObjectsArray[indexPath.row]
        }



        // Instantiate a cell
        let cell: WeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! WeatherTableViewCell
        if let name = weatherObject.name {
            cell.nameLabel.text = name
        }

        if let temp = weatherObject.temperature {
            cell.tempLabel.text = "\(temp)°"
        } else {
            cell.tempLabel.text = "--"
        }


        if let imageName = weatherObject.conditionIconText {

            cell.backgroundImageView.image = UIImage.init(named: "\(imageName).jpg")

        } else {
            cell.backgroundImageView.image = UIImage.init(named: "")

        }

        if let lastUpdated = weatherObject.lastUpdated {
            let date = Date(timeIntervalSince1970: lastUpdated)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy hh:mm"
            dateFormatter.locale = Locale.init(identifier: Locale.current.regionCode!)
            let dateString = dateFormatter.string(from: date)

            cell.lastUpdatedLabel.text = "Updated: \(dateString)"
        } else {
            cell.lastUpdatedLabel.text = "Updated: --"
        }

        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Getting the right element
        var weatherObject: Weather
        if usingFilter {
            weatherObject = filteredWeatherObjectsArray[indexPath.row]
        } else {
            weatherObject = unfilteredWeatherObjectsArray[indexPath.row]
        }




        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "placeVC") as? WeatherLocationViewController {
            viewController.selectedWeatherObject = weatherObject
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }

        searchBar.endEditing(true)
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }



    // MARK: Segmented Control Sort Logic
    @IBAction func filterControlTapped(_ sender: UISegmentedControl) {


        /**  Initialize the correct Array to sort */
        var sortedArray: [Weather] = []
        if usingFilter {
            sortedArray = filteredWeatherObjectsArray
        } else {
            sortedArray = unfilteredWeatherObjectsArray
        }

        /**  Sort Array */
        if sender.selectedSegmentIndex == 0 {
            sortedArray = WeatherManager.shared.sortArrayByPlaceName(array: sortedArray)
        } else if sender.selectedSegmentIndex == 1 {

            sortedArray = WeatherManager.shared.sortArrayByTemperature(array: sortedArray)

        } else if sender.selectedSegmentIndex == 2 {
            sortedArray = WeatherManager.shared.sortArrayByDateUpdated(array: sortedArray)
        }

        /**  Write Array back */
        if usingFilter {
            filteredWeatherObjectsArray = sortedArray
        } else {
            unfilteredWeatherObjectsArray = sortedArray
        }

        tableView.reloadData()
        tableView.setContentOffset(CGPoint.zero, animated: true)
        searchBar.endEditing(true)


    }

    // MARK: Search Bar Delegate Functions
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var searchArray: [Weather] = []
        var masterArray: [Weather] = []

        /**  Initialize the correct Array to search */
        if (usingFilter) {
            masterArray = masterFilteredWeatherObjectsArray
        } else {
            masterArray = masterUnfilteredWeatherObjectsArray
        }

        if searchText == "" {
            searchArray = masterArray

        } else {
            searchArray = masterArray.filter {
                return ($0.name!.localizedLowercase).range(of: searchText.localizedLowercase) != nil
            }

        }

        /**  Sort Array based on the selected sort option */
        if segmentedFilterControl.selectedSegmentIndex == 0 {
            searchArray = WeatherManager.shared.sortArrayByPlaceName(array: searchArray)

        } else if segmentedFilterControl.selectedSegmentIndex == 1 {
            searchArray = WeatherManager.shared.sortArrayByTemperature(array: searchArray)


        } else if segmentedFilterControl.selectedSegmentIndex == 2 {
            searchArray = WeatherManager.shared.sortArrayByDateUpdated(array: searchArray)


        }

        /**  Write array back */
        if (usingFilter) {
            filteredWeatherObjectsArray = searchArray
        } else {
            unfilteredWeatherObjectsArray = searchArray
        }


        tableView.reloadData()
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.endEditing(true)
    }



    // MARK: Actions
    /**  Prepare and present Filter View */
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        let popoverFilterViewController = storyboard?.instantiateViewController(withIdentifier: "filterVC") as? WeatherFilterViewController
        popoverFilterViewController?.modalPresentationStyle = .popover
        popoverFilterViewController?.preferredContentSize = CGSize.init(width: 600, height: 600)
        popoverFilterViewController?.weatherObjectsArray = weatherObjectsArray;
        popoverFilterViewController?.delegate = self;


        if let condition = selectedWeatherConditionString {
            popoverFilterViewController?.selectedWeatherConditionString = condition
        }
        if let country = selectedCountryString {
            popoverFilterViewController?.selectedCountryString = country
        }



        let popoverPresentationViewController = popoverFilterViewController?.popoverPresentationController
        popoverPresentationViewController?.permittedArrowDirections = UIPopoverArrowDirection.up
        present(popoverFilterViewController!, animated: true, completion: nil)


    }


    /**  Refresh the Weather objects list from the remote JSON data */
    @IBAction func refreshButtonTapped(_ sender: Any) {

        unfilteredWeatherObjectsArray = WeatherManager.shared.retrieveJsonDataAndParseIntoSortedArray()

        if unfilteredWeatherObjectsArray.count > 0 {
            showAlertWithTitleAndMessage(title: "Hooray!", message: "Weather Refreshed")
            tableView.reloadData()
        } else {
            showAlertWithTitleAndMessage(title: "Boo!", message: "Something went wrong with the refresh. Are you connected to the internet?")

        }

    }

    /**  Display Alert message */
    func showAlertWithTitleAndMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil) })
    }

    // MARK: ScrollView Delegate Functions
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        searchBar.endEditing(true)

    }



    // MARK: FilterView Delegate Function
    func sendFilter(countryName: String?, weatherCondition: String?) {

        /**  Filter by selected Country */
        if let country = countryName {

            selectedCountryString = country
            if country == "All" {

                if let condition = weatherCondition {

                    if condition != "All" {
                        usingFilter = true
                        filteredWeatherObjectsArray = unfilteredWeatherObjectsArray.filter {

                            return ($0.condition ?? "").range(of: condition) != nil
                        }
                    } else {
                        filteredWeatherObjectsArray = unfilteredWeatherObjectsArray
                    }

                } else {
                    usingFilter = false

                }
            } else {
                usingFilter = true
                filteredWeatherObjectsArray = unfilteredWeatherObjectsArray.filter {

                    if let countryObject = $0.country {
                        return (countryObject.name ?? "").range(of: country) != nil
                    }

                    return false
                }
            }

        }

        /**  Filter by selected Weather Condition */
        if let condition = weatherCondition {
            selectedWeatherConditionString = condition
            if condition == "All" {

                if let country = countryName {

                    if country != "All" {
                        usingFilter = true
                        filteredWeatherObjectsArray = unfilteredWeatherObjectsArray.filter {

                            if let countryObject = $0.country {
                                return (countryObject.name ?? "").range(of: country) != nil
                            }

                            return false
                        }
                    }

                } else {
                    usingFilter = false
                }
            } else {
                usingFilter = true

                filteredWeatherObjectsArray = filteredWeatherObjectsArray.filter {

                    return ($0.condition ?? "").range(of: condition) != nil
                }
            }


        }


        masterFilteredWeatherObjectsArray = filteredWeatherObjectsArray


        /**  Sort Filtered Array based on selected sort option */
        if segmentedFilterControl.selectedSegmentIndex == 0 {
            filteredWeatherObjectsArray = WeatherManager.shared.sortArrayByPlaceName(array: filteredWeatherObjectsArray)
        } else if segmentedFilterControl.selectedSegmentIndex == 1 {

            filteredWeatherObjectsArray = WeatherManager.shared.sortArrayByTemperature(array: filteredWeatherObjectsArray)

        } else if segmentedFilterControl.selectedSegmentIndex == 2 {
            filteredWeatherObjectsArray = WeatherManager.shared.sortArrayByDateUpdated(array: filteredWeatherObjectsArray)
        }
        tableView.reloadData()
    }


    // MARK: Overidden Functions
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        /**  Hide title label in landscape due to restricted vertical real estate */
        if UIDevice.current.orientation.isLandscape {
            headerLabelHeightConstraint.constant = 0;
        } else {
            headerLabelHeightConstraint.constant = 70;

        }
    }

    /**  Enable full screen view */
    override var prefersStatusBarHidden: Bool {
        return true
    }


}

