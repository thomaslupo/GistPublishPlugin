/**
*  Gist-plugin for Publish
*  Copyright (c) Thomas Lupo 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

internal extension String {

    /// Check if the current `String` match a regular expression test pattern
    /// `Foo.swift` will return `false`
    /// `BarTests.swift` will return `true`
    func matchesTestPattern() -> Bool {
        return self.range(of: "(.)+Test(s)?[.](.)+", options: .regularExpression, range: nil) != nil
    }
}
