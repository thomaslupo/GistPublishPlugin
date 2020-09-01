/**
*  Gist-plugin for Publish
*  Copyright (c) Thomas Lupo 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Ink

/// The HTML renderer for an `EmbeddedGist`
public protocol GistRenderer {
    func render(gist: EmbeddedGist) throws -> String
}

/// A basic renderer which will embed the `EmbeddedGist` content in a `<pre><code></code></pre>`HTML entities
public final class DefaultGistRenderer: GistRenderer {
    public init() { }

    public func render(gist: EmbeddedGist) throws -> String {
        return gist.files.map { file in
            return "<pre><code>" + file.content.escapingHTMLEntities() + "</code></pre>"
        }.joined(separator: "")
    }
}
