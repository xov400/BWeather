//
//  Created by Александр on 4.04.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

protocol HasFavouritesService {
    var favouritesService: FavouritesServiceProtocol { get }
}

protocol FavouritesServiceProtocol {
    func fetchFavouritesLocations() -> [LocationInformation]
    func saveFavourites(locations: [LocationInformation])
}
