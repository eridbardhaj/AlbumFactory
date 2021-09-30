import Foundation
import Combine

protocol NetworkKitType {
    func run<Response: Decodable>(request: URLRequest) -> AnyPublisher<Response, Error>

    func albumDetails(_ albumId: String) -> AnyPublisher<AlbumNetworkRequest.Details.ResponseType, Error>
    func artistAlbums(_ artistId: String) -> AnyPublisher<ArtistNetworkRequest.Albums.ResponseType, Error>
    func searchArtists(searchKeyword search: String) -> AnyPublisher<ArtistNetworkRequest.Search.ResponseType, Error>
    func artistDetails(_ artistId: String) -> AnyPublisher<ArtistNetworkRequest.Details.ResponseType, Error>
}

enum NetworkKitError: Error {
    case invalidURLRequest
    case unexpected(code: Int)
}

class NetworkKit: NetworkKitType {
    
    // MARK: - Properties
    // MARK: Injected
    
    let agent: NetworkAgentType
    
    // MARK: - Initializers
    
    init(agent: NetworkAgentType) {
        self.agent = agent
    }
    
    // MARK: - Protocol Conformance
    // MARK: NetworkAPI

    func run<Response: Decodable>(request: URLRequest) -> AnyPublisher<Response, Error> {
        agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }

    func albumDetails(_ albumId: String) -> AnyPublisher<AlbumNetworkRequest.Details.ResponseType, Error> {
        run(request: AlbumNetworkRequest.Details(albumId: albumId).urlRequest)
    }

    func artistAlbums(_ artistId: String) -> AnyPublisher<ArtistNetworkRequest.Albums.ResponseType, Error> {
        run(request: ArtistNetworkRequest.Albums(artistId: artistId).urlRequest)
    }

    func searchArtists(searchKeyword search: String) -> AnyPublisher<ArtistNetworkRequest.Search.ResponseType, Error> {
        run(request: ArtistNetworkRequest.Search(textQuery: search).urlRequest)
    }

    func artistDetails(_ artistId: String) -> AnyPublisher<ArtistNetworkRequest.Details.ResponseType, Error> {
        run(request: ArtistNetworkRequest.Details(artistId: artistId).urlRequest)
    }
}


