//
//  Created by Александр on 30.03.2019
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

protocol HasImageService {
    var imageService: ImageServiceProtocol { get }
}

protocol ImageServiceProtocol {
    func fatchImage(imageName: String, success: @escaping (UIImage) -> Void)
}
