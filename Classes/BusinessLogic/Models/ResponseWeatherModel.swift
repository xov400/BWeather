////
////  Created by Александр on 5.02.2019
////  Copyright © 2019 Home. All rights reserved.
////
//
//import Foundation
//
//struct ResponseWeatherModel: Decodable {
//    let HTTPcode: String
//    let message: Double
//    let numberOfLines: Int
//    let threeHoursWeatherInformationArray: [ThreeHoursWeatherInformation]
//    let cityInformation: LocationInformation
//    struct LocationInformation: Codable {
//        let id: Int
//        let name: String
//        let coord: Coord
//        let country: String
//        let population: Int
//        struct Coord: Codable {
//            let lat: Double
//            let lon: Double
//        }
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case HTTPcode = "cod"
//        case message
//        case numberOfLines = "cnt"
//        case threeHoursWeatherInformationArray = "list"
//        case cityInformation = "city"
//    }
//}
//
//struct ThreeHoursWeatherInformation: Decodable {
//    let timeOfForecastInUnixFormat: Int
//    let mainWeatherInformation: MainWeatherInformation
//    let weatherCondition: [WeatherCondition]
//    let cloudiness: Cloudiness
//    let wind: Wind
//    let sys: Sys
//    let dateOfCalculation: String
//    struct MainWeatherInformation: Codable {
//        let temp: Double
//        let minimalTemp: Double
//        let maximalTemp: Double
//        let pressure: Double
//        let seaLevel: Double
//        let groundLevel: Double
//        let humidity: Int
//        let tempIndex: Double
//
//        enum CodingKeys: String, CodingKey {
//            case temp
//            case minimalTemp = "temp_min"
//            case maximalTemp = "temp_max"
//            case pressure
//            case seaLevel = "sea_level"
//            case groundLevel = "grnd_level"
//            case humidity
//            case tempIndex = "temp_kf"
//        }
//    }
//    struct WeatherCondition: Codable {
//        let id: Int
//        let parameters: String
//        let description: String
//        let iconName: String
//
//        enum CodingKeys: String, CodingKey {
//            case id
//            case parameters = "main"
//            case description
//            case iconName = "icon"
//        }
//    }
//    struct Cloudiness: Codable {
//        let percent: Int
//
//        enum CodingKeys: String, CodingKey {
//            case percent = "all"
//        }
//    }
//    struct Wind: Codable {
//        let speed: Double
//        let deg: Double
//    }
//    struct Sys: Codable {
//        let pod: String
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case timeOfForecastInUnixFormat = "dt"
//        case mainWeatherInformation = "main"
//        case weatherCondition = "weather"
//        case cloudiness = "clouds"
//        case wind
//        case sys
//        case dateOfCalculation = "dt_txt"
//    }
//}
