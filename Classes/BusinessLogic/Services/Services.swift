//
//  Created by Alexander Gulin on 03/02/2019
//  Copyright © 2019 Home. All rights reserved.
//

typealias HasServices = HasWeatherService &
    HasSettingsService &
    HasImageService &
    HasLocationService &
    HasFavouritesService

var Services: MainServices { // swiftlint:disable:this identifier_name
    return MainServices()
}

final class MainServices: HasServices {
    lazy var favouritesService: FavouritesServiceProtocol = FavouritesService()
    lazy var settingsService: SettingsServiceProtocol = SettingsService.create()
    lazy var weatherService: WeatherServiceProtocol = WeatherService(settingsSevice: settingsService)
    lazy var imageService: ImageServiceProtocol = ImageService()
    lazy var locationService: LocationServiceProtocol =
        LocationService.sharedLocationService(favouritesService: favouritesService)
}
