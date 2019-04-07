//
//  Created by Александр on 29.03.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

final class SettingsService: SettingsServiceProtocol {

    private static var shared: SettingsService?

    private let units = ["imperial", "metric"]

    private var unitsIndex: Int = 1

    static func create() -> SettingsService {
        if shared == nil {
            shared = SettingsService()
        }
        return shared!
    }

    private init() {
    }

    func setUnitsIndex(index: Int) {
        unitsIndex = index
    }

    func getUnits() -> String {
        return units[unitsIndex]
    }
}
