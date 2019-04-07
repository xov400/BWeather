//
//  Created by Александр on 1.04.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

protocol HasLocationService {
    var locationService: LocationServiceProtocol { get }
}

protocol LocationServiceProtocol {
    func fetchLocationFile(dispatchGroup: DispatchGroup?)
    func fetchLocationsFromFile(success: @escaping ([LocationInformation]) -> Void, failure: @escaping (Error) -> Void)
    func setFavouritesLocations(favouritesLocations: [LocationInformation])
    func getFavouritesLocations() -> [LocationInformation]
}
