//
//  Created by Александр on 15.02.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

final class DayForecastModel {

    let date: Date
    let dayData: DayData
    let nightData: NightData

    init(date: Date, dayData: DayData, nightData: NightData) {
        self.date = date
        self.dayData = dayData
        self.nightData = nightData
    }
}

final class DayData {
    let temp: Int
    let pressure: Int
    let humidity: Int
    let cloudiness: Int
    let windSpeed: Double
    let direction: String
    let rainVolume: Double?
    let snowVolume: Double?
    let parameters: String
    let description: String
    let imageName: String

    init(temp: Int,
         pressure: Int,
         humidity: Int,
         cloudiness: Int,
         windSpeed: Double,
         direction: String,
         rainVolume: Double?,
         snowVolume: Double?,
         parameters: String,
         description: String,
         imageName: String) {
        self.temp = temp
        self.pressure = pressure
        self.humidity = humidity
        self.cloudiness = cloudiness
        self.windSpeed = windSpeed
        self.direction = direction
        self.rainVolume = rainVolume
        self.snowVolume = snowVolume
        self.parameters = parameters
        self.description = description
        self.imageName = imageName
    }
}

final class NightData {
    let temp: Int
    let pressure: Int
    let humidity: Int
    let cloudiness: Int
    let windSpeed: Double
    let direction: String
    let rainVolume: Double?
    let snowVolume: Double?
    let parameters: String
    let description: String
    let imageName: String

    init(temp: Int,
         pressure: Int,
         humidity: Int,
         cloudiness: Int,
         windSpeed: Double,
         direction: String,
         rainVolume: Double?,
         snowVolume: Double?,
         parameters: String,
         description: String,
         imageName: String) {
        self.temp = temp
        self.pressure = pressure
        self.humidity = humidity
        self.cloudiness = cloudiness
        self.windSpeed = windSpeed
        self.direction = direction
        self.rainVolume = rainVolume
        self.snowVolume = snowVolume
        self.parameters = parameters
        self.description = description
        self.imageName = imageName
    }
}
