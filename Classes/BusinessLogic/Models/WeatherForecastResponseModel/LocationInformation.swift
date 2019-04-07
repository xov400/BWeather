//
//  Created by Александр on 1.04.2019
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

final class LocationInformation: Codable, Comparable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population: Int?

    final class Coord: Codable {
        let lat: Double
        let lon: Double
    }

    static func < (lhs: LocationInformation, rhs: LocationInformation) -> Bool {
        return lhs.name < rhs.name
    }

    static func == (lhs: LocationInformation, rhs: LocationInformation) -> Bool {
        return lhs.name == rhs.name
    }
}
