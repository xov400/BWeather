//
//  Created by Александр on 15.02.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

extension Int {
    
    mutating func getShortWeekDay() -> String {
        switch self {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return "There is no week day"
        }
    }
    mutating func getWeekDay() -> String {
        switch self {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return "There is no week day"
        }
    }
}
