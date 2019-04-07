//
//  Created by Александр on 5.02.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation
import Alamofire

enum WeatherEndpoint {
    case forecast(location: String, units: String)
    case current(location: String, units: String)
}

extension WeatherEndpoint: Endpoint {
    
    var path: String {
        switch self {
        case .forecast:
            return "forecast"
        case .current:
            return "weather"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .forecast:
            return .get
        case .current:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .forecast(let location, let units):
            return ["q": location,
                    "units": units,
                    "APPID": Bundle.main.weatherMapAppID]
        case .current(let location, let units):
            return ["q": location,
                    "units": units,
                    "APPID": Bundle.main.weatherMapAppID]
        }
    }
}
