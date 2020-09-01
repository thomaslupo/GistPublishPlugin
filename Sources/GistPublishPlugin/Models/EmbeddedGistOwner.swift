/**
*  Gist-plugin for Publish
*  Copyright (c) Thomas Lupo 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

/// This entity represents the owner of an `EmbeddedGist`
public struct EmbeddedGistOwner: Decodable {
    public let login: String
    public let avatarUrl: String
    public let htmlUrl: String
}
