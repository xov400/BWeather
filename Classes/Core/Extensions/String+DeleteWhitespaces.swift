//
//  Created by Александр on 4.04.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

extension String {

    func deleteWhitespaces() -> String {
        return self.components(separatedBy: CharacterSet.whitespaces).joined()
    }
}
