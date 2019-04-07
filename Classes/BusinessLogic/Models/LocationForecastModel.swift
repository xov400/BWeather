//
//  Created by Александр on 4.04.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

final class LocationForecastModel {

    let location: LocationInformation
    var daysForecastModels: [DayForecastModel]?

    init(location: LocationInformation) {
        self.location = location
    }
}
