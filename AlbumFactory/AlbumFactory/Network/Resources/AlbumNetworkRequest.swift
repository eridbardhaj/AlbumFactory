import Foundation

enum AlbumNetworkRequest {
    struct Details: NetworkRequest {

        // MARK: - Properties
        // MARK: Immutable

        private let albumId: String

        // MARK: - Initializers

        init(albumId: String) {
            self.albumId = albumId
        }

        // MARK: - Protocol Conformance
        // MARK: NetworkRequest

        var httpMethod: HTTPMethod? { .get }
        var resource: String { "album.getinfo" }
        var queryItems: [URLQueryItem] {
            [ URLQueryItem(name: "mbid", value: albumId) ]
        }
        typealias ResponseType = AlbumInfoResponse
    }
}
