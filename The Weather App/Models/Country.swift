//
//  Country.swift
//  The Weather App
//
//  Created by Adrian McGee on 6/7/17.
//  Copyright © 2017 Adrian McGee. All rights reserved.
//


import Foundation

struct Country {
    let id: String?
    let name: String?
}

extension Country {
/**
    Initialize Object
*/
    init(dictionary: NSDictionary) {

        // Initialize properties
        self.id = dictionary["_countryID"] as? String
        self.name = dictionary["_name"] as? String

    }


    /**
      Returns an array of Country objects
  */
    static func countryObjectsFromDictionaryArray(dictionary: NSDictionary) -> Country {
        let country = Country(dictionary: dictionary)

        return country
    }


}