//
//  Created by Александр on 30.03.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

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
