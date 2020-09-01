/**
*  Gist-plugin for Publish
*  Copyright (c) Thomas Lupo 2020
*  MIT license, see LICENSE file for details
*/

import Publish
import Ink
import Foundation

/// Main plugin entry
/// Will add a custom modifier to the markdown parser in order to parse this format `> gist 05f837a3f901630e65e3652945424ba5`
public extension Plugin {
    static func gist(renderer: GistRenderer = DefaultGistRenderer()) -> Self {
        Plugin(name: "Gist") { context in
            context.markdownParser.addModifier(
                .gistBlockquote(using: renderer)
            )
        }
    }
}

public extension Modifier {
    static func gistBlockquote(using renderer: GistRenderer) -> Self {
        return Modifier(target: .blockquotes) { html, markdown in
            let prefix = "gist "
            let markdown = markdown.dropFirst().trimmingCharacters(in: .whitespaces)

            guard markdown.hasPrefix(prefix) else {
                return html
            }

            let gistId = markdown.dropFirst(prefix.count).trimmingCharacters(in: .newlines)

            let gist = try! GistEmbedGenerator(gistId: gistId).generate().get()

            return try! renderer.render(gist: gist)
        }
    }
}
