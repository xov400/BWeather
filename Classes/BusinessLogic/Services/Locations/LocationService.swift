//
//  Created by Александр on 1.04.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation
import Alamofire
import GZIP

final class LocationService {

    private static var shared: LocationService?

    private let favouritesService: FavouritesServiceProtocol

    private let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private let archiveName = "city.list.json.gz"
    private var favouritesLocations: [LocationInformation]

    private init(favouritesService: FavouritesServiceProtocol) {
        self.favouritesService = favouritesService
        self.favouritesLocations = favouritesService.loadFavouritesLocations()
    }

    static func sharedLocationService(favouritesService: FavouritesServiceProtocol) -> LocationService {
        if shared == nil {
            shared = LocationService(favouritesService: favouritesService)
        }
        return shared!
    }

    private func deleteFile(name: String,
                            success: @escaping (String) -> Void,
                            failure: @escaping (Error) -> Void) {
        guard let name = documentsURL.check(forFile: name) else {
            return
        }
        do {
            let filePath = documentsURL.appendingPathComponent(name).path
            try FileManager.default.removeItem(atPath: filePath)
            success("File \(name) deleted")
        } catch let error as NSError {
            failure(error)
        }
    }
}

extension LocationService: LocationServiceProtocol {

    func fetchLocationFile(dispatchGroup: DispatchGroup?, failure: @escaping (Error) -> Void) {
        dispatchGroup?.enter()
        let fileURL = URL(string: "http://bulk.openweathermap.org/sample/\(archiveName)")!

        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = self.documentsURL
            documentsURL.appendPathComponent(self.archiveName)

            print("File \(self.archiveName) loaded in \(documentsURL)")

            return (documentsURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        Alamofire.download(fileURL, to: destination).response { response in
            if let error = response.error {
                failure(error)
            }
            dispatchGroup?.leave()
        }
    }

    func fetchLocationsFromFile(success: @escaping ([LocationInformation]) -> Void,
                                failure: @escaping (Error) -> Void) {
        guard documentsURL.check(forFile: archiveName) != nil else {
            return
        }

        let fileURL = documentsURL.appendingPathComponent(archiveName)
        guard let data = NSData(contentsOf: fileURL),
            data.isGzippedData(),
            let unzipedData = data.gunzipped() else {
                return
        }

        do {
            let locationsArray = try JSONDecoder().decode([LocationInformation].self, from: unzipedData)
            success(locationsArray)
        } catch {
            failure(error)
        }
    }

    func setFavouritesLocations(favouritesLocations: [LocationInformation]) {
        self.favouritesLocations = favouritesLocations
        favouritesService.saveFavouritesLocations(locations: favouritesLocations)
    }

    func getFavouritesLocations() -> [LocationInformation] {
        return favouritesLocations
    }
}
