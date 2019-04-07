//
//  Created by Александр on 31.03.2019
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

extension UIViewController {

    var safeAreaInsets: UIEdgeInsets {
        var insets: UIEdgeInsets = .zero
        if #available(iOS 11.0, *) {
            insets = view.safeAreaInsets
        } else {
            insets = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomLayoutGuide.length, right: 0)
        }
        return UIEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
    }
}
