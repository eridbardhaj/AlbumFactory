import Foundation
import Combine

class NetworkKitTypeMock: NetworkKit {

    init() {
        super.init(agent: DependencyResolver.agent)
    }

    // MARK: - Overrides

    override func albumDetails(_ albumId: String) -> AnyPublisher<AlbumNetworkRequest.Details.ResponseType, Error> {
        run(request: urlRequest(for: .albumDetails))
    }

    override func artistAlbums(_ artistId: String) -> AnyPublisher<ArtistNetworkRequest.Albums.ResponseType, Error> {
        run(request: urlRequest(for: .artistAlbums))
    }

    override func searchArtists(searchKeyword search: String) -> AnyPublisher<ArtistNetworkRequest.Search.ResponseType, Error> {
        run(request: urlRequest(for: .artistSearch))
    }

    override func artistDetails(_ artistId: String) -> AnyPublisher<ArtistNetworkRequest.Details.ResponseType, Error> {
        run(request: urlRequest(for: .artistDetails))
    }

    func urlRequest(for resource: NetworkResource) -> URLRequest {
        var jsonFilename: String
        switch resource {
        case .artistSearch:
            jsonFilename = "artist_search"
        case .artistAlbums:
            jsonFilename = "artist_albums"
        case .albumDetails:
            jsonFilename = "album_details"
        case .artistDetails:
            jsonFilename = "artist_details"
        }

        let url = Bundle.main.url(forResource: jsonFilename, withExtension: "json")!
        return URLRequest(url: url)
    }
}
