//
//  Created by Александр on 1.04.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

extension Double {

    var windDirection: String {
        if (10.0...80.0).contains(self) {
            return "southwestern"
        } else if (80.0...100.0).contains(self) {
            return "southern"
        } else if (100.0...170.0).contains(self) {
            return "southeastern"
        } else if (170.0...190.0).contains(self) {
            return "eastern"
        } else if (190.0...260.0).contains(self) {
            return "northeastern"
        } else if (260.0...280.0).contains(self) {
            return "northern"
        } else if (280.0...350.0).contains(self) {
            return "northwestern"
        } else {
            return "western"
        }
    }
}
