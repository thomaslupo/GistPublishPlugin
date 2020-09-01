/**
*  Gist-plugin for Publish
*  Copyright (c) Thomas Lupo 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

/// This entity represents a fetched gist from the API
public struct EmbeddedGist: Decodable {

    /// Properties
    public let htmlUrl: String
    public let owner: EmbeddedGistOwner
    public let files: [EmbeddedGistFile]

    /// `CodingKeys` in order to have a custom init from `Decoder`
    private enum CodingKeys: String, CodingKey {
        case htmlUrl
        case owner
        case files
    }

    /// Custom init to transform a `Dictionary` of files to an `Array` of files
    /// Sort the `Array` of files by moving the test files at the end
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        htmlUrl = try container.decode(String.self, forKey: .htmlUrl)
        owner = try container.decode(EmbeddedGistOwner.self, forKey: .owner)

        /// The files are returned in a `Dictionary` so the order of the files array is not fixed
        /// Add a sort to put the `*Tests.` file at the end (like here: https://gist.github.com/JohnSundell/bc8bc138529978fc2fb8c90d96b7d801)
        let initialFiles = try container.decode([String: EmbeddedGistFile].self, forKey: .files)
        files = Array(initialFiles.values).sorted(by: { (file1, file2) -> Bool in
            return !file1.filename.matchesTestPattern()
        })
    }
}
