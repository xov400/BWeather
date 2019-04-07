//
//  Created by Александр on 4.04.2019
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

extension URL {

    func check(forFile name: String) -> String? {
        do {
            let directoryPath = self.path
            let filesInDirectory = try FileManager.default.contentsOfDirectory(atPath: directoryPath)
            if filesInDirectory.contains(name) {
                return name
            }
        } catch let error as NSError {
            print("File \(name) not found: \(error.localizedDescription)")
        }
        return nil
    }
}
