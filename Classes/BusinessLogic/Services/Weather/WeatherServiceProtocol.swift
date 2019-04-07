//
//  Created by Александр on 4.02.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

protocol HasWeatherService {
    var weatherService: WeatherServiceProtocol { get }
}

protocol WeatherServiceProtocol {
    func fatchWeatherForecasts(location: String,
                              success: @escaping (WeatherForecastResponseModel) -> Void,
                              failure: @escaping (Error) -> Void)
    func fatchWeatherCurrent(location: String,
                             success: @escaping (WeatherCurrentResponseModel) -> Void,
                             failure: @escaping (Error) -> Void)
}
