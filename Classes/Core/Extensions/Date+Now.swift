//
//  Created by Александр on 29.03.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

extension Date {

    var toFormattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm"
        return dateFormatter.string(from: self)
    }
}
