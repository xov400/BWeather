//
//  Created by Александр on 30.03.2019
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import Alamofire

final class ImageService: ImageServiceProtocol {

    func fatchImage(imageName: String, success: @escaping (UIImage) -> Void) {
        let endpoint = ImageEndpoint.fatchImage(imageName: imageName)
        let request = Alamofire.request(endpoint.baseURL)
        request.responseData { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        if let image = UIImage(data: data) {
                            success(image)
                        }
                    }
                }
            case .failure(let error):
                print("Image not loaded: \(error.localizedDescription)")
            }
        }
    }
}
