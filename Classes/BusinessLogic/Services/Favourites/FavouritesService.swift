//
//  Created by Александр on 4.04.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

final class FavouritesService: FavouritesServiceProtocol {

    private let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private let favouritesFile = "favouritesLocation.json"

    func fetchFavouritesLocations() -> [LocationInformation] {
        guard let favouritesFile = documentsURL.check(forFile: favouritesFile) else {
            return []
        }
        do {
            let data = try Data(contentsOf: documentsURL.appendingPathComponent(favouritesFile), options: .mappedIfSafe)
            let favouritesLocations = try JSONDecoder().decode([LocationInformation].self, from: data)
            return favouritesLocations
        } catch {
            print("FavouritesLocations isn't be read")
            return []
        }
    }

    func saveFavourites(locations: [LocationInformation]) {
        do {
            let json = try JSONEncoder().encode(locations)
            var documentsURL = self.documentsURL
            documentsURL.appendPathComponent(favouritesFile)
            print(documentsURL)
            try json.write(to: documentsURL)
        } catch {
            print("could't create file text.txt because of error: \(error)")
        }
    }
}
