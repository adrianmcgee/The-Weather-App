//
//  WeatherManager.swift
//  The Weather App
//
//  Created by Adrian McGee on 9/7/17.
//  Copyright © 2017 Adrian McGee. All rights reserved.
//

import Foundation


final class WeatherManager {


    private init() {
    }

    // MARK: Shared Instance
    static let shared = WeatherManager()


    // MARK: - public
    /**  Retrieve remote JSON data and return an array of parse Weather objects */
    public func retrieveJsonDataAndParseIntoSortedArray() -> [Weather] {

        var weatherObjectsArray: [Weather] = []

//        let file = "json.txt"
//
//        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//
//            let path = dir.appendingPathComponent(file)
//
//            NSLog("path = \(path)")
//
//            //reading
//            do {
//                let text2 = try String(contentsOf: path, encoding: String.Encoding.utf8)
//                NSLog("text2 = \(text2)")
//            }
//            catch {/* error handling here */}
//
//        }

        let path = Bundle.main.path(forResource: "json", ofType: "txt")

        do {
            if let jsonPath = path{
               // var text = try String(contentsOfFile: jsonPath, encoding: NSUTF8StringEncoding, error: nil)
                let text = try String(contentsOfFile: jsonPath, encoding: String.Encoding.utf8)

               let jsonDict = convertToDictionary(text: text)

                if let dict = jsonDict{
                    if let data = dict["data"] as? NSArray {

                        let weatherObjectArray = Weather.weatherObjectsFromDictionaryArray(array: data)

                        for object in weatherObjectArray {
                            weatherObjectsArray.append(object)
                        }

                    }
                }



            }
        }
        catch {

        }




//        let jsonUrl = URL(string: "http://dnu5embx6omws.cloudfront.net/venues/weather.json")
//        do {
//            let jsonData = try Data(contentsOf: jsonUrl!)
//            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as! [NSString: Any]
//
//            if let data = jsonObject["data"] as? NSArray {
//
//                let weatherObjectArray = Weather.weatherObjectsFromDictionaryArray(array: data)
//
//                for object in weatherObjectArray {
//                    weatherObjectsArray.append(object)
//                }
//
//            }
//
//        } catch {
//            print("Error info: \(error)")
//        }
        return sortArrayByPlaceName(array: weatherObjectsArray)

    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }


    /**  Sort Array alphabetically by place name */
    public func sortArrayByPlaceName(array: [Weather]) -> [Weather] {

        let sortedArray = array.sorted(by: { (weather1, weather2) -> Bool in
            guard let weatherName1 = weather2.name else {
                return true
            }
            guard let weatherName2 = weather1.name else {
                return false
            }
            return weatherName2 < weatherName1
        })

        return sortedArray
    }

    /**  Sort Array by Temperature */
    public func sortArrayByTemperature(array: [Weather]) -> [Weather] {

        let sortedArray = array.sorted(by: { (weather1, weather2) -> Bool in
            guard let temp1 = weather2.temperature else {
                return true
            }
            guard let temp2 = weather1.temperature else {
                return false
            }
            let temp1Int: Int = Int(temp1)!
            let temp2Int: Int = Int(temp2)!

            return temp2Int < temp1Int

        })

        return sortedArray
    }

    /**  Sort Array by last updated date */
    public func sortArrayByDateUpdated(array: [Weather]) -> [Weather] {

        let sortedArray = array.sorted(by: { (weather1, weather2) -> Bool in
            guard let lastUpdated1 = weather2.lastUpdated else {
                return true
            }
            guard let lastUpdated2 = weather1.lastUpdated else {
                return false
            }
            return lastUpdated2 > lastUpdated1
        })

        return sortedArray
    }


}
