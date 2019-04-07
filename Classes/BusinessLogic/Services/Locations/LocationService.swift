//
//  Created by Александр on 1.04.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation
import Alamofire
import Zip

final class LocationService {

    private static var shared: LocationService?

    private let favouritesService: FavouritesServiceProtocol

    private let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private let archiveName = "city.list.json.gz"
    private let fileName = "city.list.json"
    private var favouritesLocations: [LocationInformation]


    private init(favouritesService: FavouritesServiceProtocol) {
        self.favouritesService = favouritesService
        self.favouritesLocations = favouritesService.fetchFavouritesLocations()
    }

    static func sharedLocationService(favouritesService: FavouritesServiceProtocol) -> LocationService {
        if shared == nil {
            shared = LocationService(favouritesService: favouritesService)
        }
        return shared!
    }

    private func unzipFile() {
        do {
            let filePath = documentsURL.appendingPathComponent(archiveName)
            let unzipDirectory = try Zip.quickUnzipFile(filePath)
            print(unzipDirectory)
        }
        catch {
            print("Unzip error: \(error.localizedDescription)")
        }
    }

    private func deleteFile(name: String) {
        guard let name = documentsURL.check(forFile: name) else {
            return
        }
        do {
            let filePath = documentsURL.appendingPathComponent(name).path
            try FileManager.default.removeItem(atPath: filePath)
            print("File \(name) deleted")
        } catch let error as NSError {
            print("File not deleted: \(error.localizedDescription)")
        }
    }
}

extension LocationService: LocationServiceProtocol {

    func fetchLocationFile(dispatchGroup: DispatchGroup?) {
        dispatchGroup?.enter()
        let fileURL = URL(string: "http://bulk.openweathermap.org/sample/\(archiveName)")!

        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = self.documentsURL
            documentsURL.appendPathComponent(self.archiveName)
            print("File \(self.archiveName) loaded")
            print("in \(documentsURL)")
            return (documentsURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        Alamofire.download(fileURL, to: destination).response { response in
            self.unzipFile()
            if let error = response.error {
                print("File not loaded: \(error.localizedDescription)")
            }
            dispatchGroup?.leave()
        }
    }

    func fetchLocationsFromFile(success: @escaping ([LocationInformation]) -> Void, failure: @escaping (Error) -> Void) {
        guard let fileName = documentsURL.check(forFile: fileName) else {
            return
        }

        do {
            let data = try Data(contentsOf: documentsURL.appendingPathComponent(fileName), options: .mappedIfSafe)
            let locationsArray = try JSONDecoder().decode([LocationInformation].self, from: data)
            print("Load locations from file")
            success(locationsArray)
        } catch let error {
            print("Can't load locations from file")
            failure(error)
        }
    }

    func setFavouritesLocations(favouritesLocations: [LocationInformation]) {
        self.favouritesLocations = favouritesLocations
        favouritesService.saveFavourites(locations: favouritesLocations)
    }

    func getFavouritesLocations() -> [LocationInformation] {
        return favouritesLocations
    }
}
