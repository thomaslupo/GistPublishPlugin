/**
*  Gist-plugin for Publish
*  Copyright (c) Thomas Lupo 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// This class will use the GitHub API to retrieve the details of a gist (https://docs.github.com/en/rest/reference/gists)
/// It's inspired by the `TwitterEmbedGenerator` class of the `TwitterPublishPlugin` (https://github.com/insidegui/TwitterPublishPlugin/blob/master/Sources/TwitterPublishPlugin/Support/TwitterEmbedGenerator.swift)
final class GistEmbedGenerator {

    private let session = URLSession(configuration: .default)
    private let baseUrl = "https://api.github.com/gists/"

    let gistId: String

    /// Constructor with an unique gist identifier
    init(gistId: String) {
        self.gistId = gistId
    }
    
    func generate() -> Result<EmbeddedGist, Error> {
        guard let url = URL(string: baseUrl + gistId) else {
            return .failure(.invalidURL)
        }

        let request = URLRequest(url: url)
        var result: Result<EmbeddedGist, Error> = .failure(.timeout)

        let sema = DispatchSemaphore(value: 0)

        let task = session.dataTask(with: request) { data, res, error in
            defer { sema.signal() }

            let suffix = "while processing the gist \(self.gistId)"

            guard let res = res as? HTTPURLResponse else {
                result = .failure(Error(localizedDescription: "Unexpected response \(suffix)"))
                return
            }

            guard res.statusCode == 200 else {
                result = .failure(Error(localizedDescription: "GitHub's API returned error code \(res.statusCode) \(suffix)"))
                return
            }

            guard let data = data else {
                if let error = error {
                    result = .failure(Error(localizedDescription: "The request failed with error \(error) \(suffix)"))
                } else {
                    result = .failure(Error(localizedDescription: "The request returned no data \(suffix)"))
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let gist = try decoder.decode(EmbeddedGist.self, from: data)

                result = .success(gist)
            } catch {
                result = .failure(Error(localizedDescription: "Error decoding: \(error) \(suffix)"))
            }
        }

        task.resume()

        _ = sema.wait(timeout: .now() + 15)

        return result
    }

    struct Error: LocalizedError {
        var localizedDescription: String

        static let invalidURL = Error(localizedDescription: "Failed to construct an URL")
        static let timeout = Error(localizedDescription: "The request to GitHub's API timed out")
    }
}
