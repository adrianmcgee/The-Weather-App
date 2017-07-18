//
//  Weather.swift
//  The Weather App
//
//  Created by Adrian McGee on 6/7/17.
//  Copyright © 2017 Adrian McGee. All rights reserved.
//


import Foundation

struct Weather {
    let id: String?
    let name: String?
    let condition: String?
    let conditionIconText: String?
    let wind: String?
    let humidity: String?
    let temperature: String?
    let feelsLikeTemp: String?
    let lastUpdated: Double?
    let country: Country?
}

extension Weather {


/**
    Initialize Object
*/
    init(dictionary: NSDictionary) {

        // Initialize properties
        self.id = dictionary["_venueID"] as? String
        self.name = dictionary["_name"] as? String
        self.condition = dictionary["_weatherCondition"] as? String
        self.conditionIconText = dictionary["_weatherConditionIcon"] as? String
        self.wind = dictionary["_weatherWind"] as? String
        self.humidity = dictionary["_weatherHumidity"] as? String
        self.temperature = dictionary["_weatherTemp"] as? String
        self.feelsLikeTemp = dictionary["_weatherFeelsLike"] as? String
        self.lastUpdated = dictionary["_weatherLastUpdated"] as? Double

        let countryDict = dictionary["_country"] as? NSDictionary
        let countryObject = Country.countryObjectsFromDictionaryArray(dictionary: countryDict!)
        self.country = countryObject

    }

/**
    Returns an array of Weather objects
*/
    static func weatherObjectsFromDictionaryArray(array: NSArray) -> [Weather] {

        var weatherObjectsArray: [Weather] = []

        for item in array {
            weatherObjectsArray.append(Weather(dictionary: item as! NSDictionary))

        }

        return weatherObjectsArray
    }


}
