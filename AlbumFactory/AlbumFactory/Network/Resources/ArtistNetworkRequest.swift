import Foundation

enum ArtistNetworkRequest {
    struct Search: NetworkRequest {

        // MARK: - Properties
        // MARK: Immutable

        private let textQuery: String

        // MARK: - Initializers

        init(textQuery: String) {
            self.textQuery = textQuery
        }

        // MARK: - Protocol Conformance
        // MARK: NetworkRequest

        var httpMethod: HTTPMethod? { .get }
        var resource: NetworkResource { .artistSearch }
        var queryItems: [URLQueryItem] {
            [ URLQueryItem(name: "artist", value: textQuery) ]
        }
        typealias ResponseType = ArtistSearchResponse
    }

    struct Albums: NetworkRequest {

        // MARK: - Properties
        // MARK: Immutable

        private let artistId: String

        // MARK: - Initializers

        init(artistId: String) {
            self.artistId = artistId
        }

        // MARK: - Protocol Conformance
        // MARK: NetworkRequest

        var httpMethod: HTTPMethod? { .get }
        var resource: NetworkResource { .artistAlbums }
        var queryItems: [URLQueryItem] {
            [ URLQueryItem(name: "mbid", value: artistId) ]
        }
        typealias ResponseType = ArtistAlbumsResponse
    }
}
