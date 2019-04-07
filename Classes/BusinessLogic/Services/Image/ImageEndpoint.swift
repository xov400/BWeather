//
//  Created by Александр on 30.03.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

enum ImageEndpoint {
    case fatchImage(imageName: String)
}

extension ImageEndpoint {

    var baseURL: URL {
        switch self {
        case .fatchImage (let imageName):
            return URL(string: "http://openweathermap.org/img/w/" + imageName + ".png")!
        }
    }
}
