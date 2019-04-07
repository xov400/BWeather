//
//  Created by Александр on 30.03.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

final class ThreeHoursWeatherInformation: Decodable {
    let timeOfForecast: Date
    let mainWeatherInformation: MainWeatherInformation
    let weatherCondition: [WeatherCondition]
    let cloudiness: Cloudiness
    let wind: Wind
    let rain: Rain?
    let snow: Snow?
    let sys: Sys
    let dateOfCalculation: String

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let timeOfForecastInUnixFormat = try container.decode(TimeInterval.self, forKey: .timeOfForecast)
        timeOfForecast = Date(timeIntervalSince1970: timeOfForecastInUnixFormat)
        mainWeatherInformation = try container.decode(MainWeatherInformation.self, forKey: .mainWeatherInformation)
        weatherCondition = try container.decode([WeatherCondition].self, forKey: .weatherCondition)
        cloudiness = try container.decode(Cloudiness.self, forKey: .cloudiness)
        wind = try container.decode(Wind.self, forKey: .wind)
        rain = try container.decodeIfPresent(Rain.self, forKey: .rain)
        snow = try container.decodeIfPresent(Snow.self, forKey: .snow)
        sys = try container.decode(Sys.self, forKey: .sys)
        dateOfCalculation = try container.decode(String.self, forKey: .dateOfCalculation)
    }

    enum CodingKeys: String, CodingKey {
        case timeOfForecast = "dt"
        case mainWeatherInformation = "main"
        case weatherCondition = "weather"
        case cloudiness = "clouds"
        case wind
        case rain
        case snow
        case sys
        case dateOfCalculation = "dt_txt"
    }
}

final class Cloudiness: Codable {
    let percent: Int

    enum CodingKeys: String, CodingKey {
        case percent = "all"
    }
}

final class Wind: Codable {
    let speed: Double
    let deg: Double
}

final class Rain: Codable {
    let volume: Double?

    enum CodingKeys: String, CodingKey {
        case volume = "3h"
    }
}

final class Snow: Codable {
    let volume: Double?

    enum CodingKeys: String, CodingKey {
        case volume = "3h"
    }
}

final class Sys: Codable {
    let pod: String
}
