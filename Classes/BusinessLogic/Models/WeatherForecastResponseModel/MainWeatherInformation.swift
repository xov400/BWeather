//
//  Created by Александр on 30.03.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

final class MainWeatherInformation: Codable {
    let temp: Double
    let minimalTemp: Double
    let maximalTemp: Double
    let pressure: Double
    let seaLevel: Double
    let groundLevel: Double
    let humidity: Int
    let tempIndex: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case minimalTemp = "temp_min"
        case maximalTemp = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
        case humidity
        case tempIndex = "temp_kf"
    }
}
