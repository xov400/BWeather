//
//  Created by Александр on 5.02.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

final class WeatherForecastResponseModel: Decodable {
    let HTTPcode: String
    let message: Double
    let numberOfLines: Int
    let threeHoursWeatherInformationArray: [ThreeHoursWeatherInformation]
    let cityInformation: LocationInformation

    enum CodingKeys: String, CodingKey {
        case HTTPcode = "cod"
        case message
        case numberOfLines = "cnt"
        case threeHoursWeatherInformationArray = "list"
        case cityInformation = "city"
    }
}
