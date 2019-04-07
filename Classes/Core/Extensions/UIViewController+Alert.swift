//
//  Created by Александр on 4.04.2019
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

extension UIViewController {

    func presentAlert(message: String, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: Bundle.main.appName, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: handler))
        present(alertController, animated: true)
    }
}
