/**
*  Gist-plugin for Publish
*  Copyright (c) Thomas Lupo 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

/// This entity represents a single file of code in an `EmbeddedGist`
public struct EmbeddedGistFile: Decodable {
    public let filename: String
    public let type: String
    public let language: String
    public let rawUrl: String
    public let truncated: Bool
    public let content: String
}
