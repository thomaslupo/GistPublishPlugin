/**
*  Gist-plugin for Publish
*  Copyright (c) Thomas Lupo 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

internal extension StringProtocol {

    /// Returns a new `String` with HTML entities escapes. Will avoid interpretation of HTML entities in gist code (ex: `<Option>`)
    /// Copyright (c) John Sundell 2019 (https://github.com/JohnSundell/Splash/blob/master/Sources/Splash/Extensions/Strings/String%2BHTMLEntities.swift)
    func escapingHTMLEntities() -> String {
        return String(flatMap { character -> String in
            switch character {
            case "&":
                return "&amp;"
            case "<":
                return "&lt;"
            case ">":
                return "&gt;"
            default:
                return String(character)
            }
        })
    }
}
