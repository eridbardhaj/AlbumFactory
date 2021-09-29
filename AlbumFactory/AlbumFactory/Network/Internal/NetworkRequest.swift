import Foundation

enum NetworkResource: String {
    case artistSearch = "artist.search"
    case artistAlbums = "artist.gettopalbums"
    case artistDetails = "artist.getinfo"
    case albumDetails = "album.getinfo"
}

protocol NetworkRequest {
    associatedtype ResponseType: Decodable

    var httpMethod: HTTPMethod? { get }
    var resource: NetworkResource { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
}

extension NetworkRequest {

    var urlRequest: URLRequest {
        guard let targetURL = targetURL else { preconditionFailure("There is something wrong building the target URL") }
        var urlRequest = URLRequest(url: targetURL)

        urlRequest.httpMethod = httpMethod?.rawValue
        for (headerKey, headerValue) in headers {
            urlRequest.addValue(headerValue, forHTTPHeaderField: headerKey)
        }

        return urlRequest
    }

    // MARK: - Default

    var headers: [String: String] { [:] }
    var queryItems: [URLQueryItem] { [] }

    // MARK: - Helpers

    private var targetURL: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = NetworkConfiguration.scheme
        urlComponents.host = NetworkConfiguration.host
        urlComponents.path = NetworkConfiguration.path
        urlComponents.queryItems = defaultQueryItems + queryItems
        return urlComponents.url
    }

    private var defaultQueryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "api_key", value: NetworkConfiguration.apiKey),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "method", value: resource.rawValue)
        ]
    }
}
