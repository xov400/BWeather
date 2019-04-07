//
//  Created by Александр on 14.02.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

final class WeatherCurrentResponseModel: Decodable {
    let coordinates: Coord
    let weatherCondition: [WeatherCondition]
    let base: String
    let mainWeatherInformation: MainWeatherInformation
    let visibility: Int
    let wind: Wind
    let cloudiness: Cloudiness
    let sys: Sys
    let id: Int
    let cityName: String
    let HTTPcode: Int
    final class Coord: Codable {
        let lat: Double
        let lon: Double
    }
    final class WeatherCondition: Codable {
        let id: Int
        let parameters: String
        let description: String
        let iconName: String

        enum CodingKeys: String, CodingKey {
            case id
            case parameters = "main"
            case description
            case iconName = "icon"
        }
    }
    final class MainWeatherInformation: Decodable {
        let temp: Double
        let pressure: Double
        let humidity: Int
        let minimalTemp: Double
        let maximalTemp: Double

        enum CodingKeys: String, CodingKey {
            case temp
            case pressure
            case humidity
            case minimalTemp = "temp_min"
            case maximalTemp = "temp_max"
        }
    }
    final class Wind: Decodable {
        let speed: Int
        let deg: Int
    }
    final class Cloudiness: Codable {
        let percent: Int

        enum CodingKeys: String, CodingKey {
            case percent = "all"
        }
    }
    final class Sys: Decodable {
        let type: Int
        let id: Int
        let message: Double
        let country: String
        let sunrise: UInt
        let sunset: UInt
    }

    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case weatherCondition = "weather"
        case base
        case mainWeatherInformation = "main"
        case visibility
        case wind
        case cloudiness = "clouds"
        case sys
        case id
        case cityName = "name"
        case HTTPcode = "cod"
    }
}
