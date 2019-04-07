//
//  Created by Александр on 5.04.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

protocol SelectCellDelegate: class {
    func internalCollectionView(DidSelectItemAt indexPath: IndexPath, currentDataIsVisible: Bool)
}
