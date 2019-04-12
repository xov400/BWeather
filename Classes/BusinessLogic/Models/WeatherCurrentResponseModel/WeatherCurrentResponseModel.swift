//
//  Created by Александр on 14.02.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

final class WeatherCurrentResponseModel: Decodable {

    let coordinates: LocationInformation.Coord
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
