//
//  Created by Александр on 29.03.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

protocol HasSettingsService {
    var settingsService: SettingsServiceProtocol { get set }
}

protocol SettingsServiceProtocol {
    func setUnitsIndex(index: Int)
    func getUnits() -> String
}
