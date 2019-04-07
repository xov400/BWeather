//
//  Created by Alexander Gulin on 03/02/2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

protocol ViewUpdatable {

    var needsUpdate: Bool { get set }

    func update<T: Equatable, U: Equatable>(new newViewModel: U,
                                            old oldViewModel: U,
                                            keyPath: KeyPath<U, T>,
                                            configureBlock: (T) -> Void)
}

extension ViewUpdatable {

    func update<T: Equatable, U: Equatable>(new newViewModel: U,
                                            old oldViewModel: U,
                                            keyPath: KeyPath<U, T>,
                                            configureBlock: (T) -> Void) {
        let newValue = newViewModel[keyPath: keyPath]
        if needsUpdate {
            configureBlock(newValue)
            return
        }
        let oldValue = oldViewModel[keyPath: keyPath]
        if oldValue != newValue {
            configureBlock(newValue)
        }
    }
}
