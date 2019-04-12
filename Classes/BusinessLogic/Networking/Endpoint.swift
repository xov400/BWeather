//
//  Created by Александр on 5.02.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation
import Alamofire

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var parameterEncoding: ParameterEncoding { get }
}

extension Endpoint {

    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/")!
    }

    var parameters: Parameters? {
        return nil
    }

    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    var url: URL {
        return baseURL.appendingPathComponent(path)
    }
}
