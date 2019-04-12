//
//  Created by Александр on 4.02.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation
import Alamofire

final class WeatherService: WeatherServiceProtocol {

    private let settingsSevice: SettingsServiceProtocol

    init(settingsSevice: SettingsServiceProtocol) {
        self.settingsSevice = settingsSevice
    }

    func fatchWeatherForecasts(location: String,
                               success: @escaping (WeatherForecastResponseModel) -> Void,
                               failure: @escaping (Error) -> Void) {
        let endpoint = WeatherEndpoint.forecast(location: location,
                                                units: settingsSevice.getUnits())
        let request = Alamofire.request(endpoint.url,
                                        method: endpoint.method,
                                        parameters: endpoint.parameters,
                                        encoding: endpoint.parameterEncoding)
        request.responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let weatherForecastModel = try JSONDecoder().decode(WeatherForecastResponseModel.self,
                                                                            from: data)
                        success(weatherForecastModel)
                    } catch {
                        failure(error)
                    }
                }
            case .failure(let error):
                failure(error)
            }
        }
    }

    func fatchWeatherCurrent(location: String,
                             success: @escaping (WeatherCurrentResponseModel) -> Void,
                             failure: @escaping (Error) -> Void) {
        let endpoint = WeatherEndpoint.current(location: location,
                                               units: settingsSevice.getUnits())
        let request = Alamofire.request(endpoint.url,
                                        method: endpoint.method,
                                        parameters: endpoint.parameters,
                                        encoding: endpoint.parameterEncoding)
        request.responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let weatherCurrentModel = try JSONDecoder().decode(WeatherCurrentResponseModel.self, from: data)
                        success(weatherCurrentModel)
                    } catch {
                        failure(error)
                    }
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
}
