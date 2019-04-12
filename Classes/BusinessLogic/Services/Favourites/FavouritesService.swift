//
//  Created by Александр on 4.04.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

final class FavouritesService: FavouritesServiceProtocol {

    private let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private let favouritesFile = "favouritesLocation.json"

    func loadFavouritesLocations() -> [LocationInformation] {
        guard let favouritesFile = documentsURL.check(forFile: favouritesFile) else {
            return []
        }
        do {
            let data = try Data(contentsOf: documentsURL.appendingPathComponent(favouritesFile), options: .mappedIfSafe)
            let favouritesLocations = try JSONDecoder().decode([LocationInformation].self, from: data)
            return favouritesLocations
        } catch {
            print("Favourites locations isn't be read")
            return []
        }
    }

    func saveFavouritesLocations(locations: [LocationInformation]) {
        do {
            let json = try JSONEncoder().encode(locations)
            var fileURL = self.documentsURL
            fileURL.appendPathComponent(favouritesFile)
            try json.write(to: fileURL)
        } catch {
            print("Could't create file \(favouritesFile) because of error: \(error)")
        }
    }
}
