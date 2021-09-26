import Foundation

protocol NetworkRequest {
    associatedtype ResponseType: Decodable

    var httpMethod: HTTPMethod? { get }
    var resource: String { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
}

extension NetworkRequest {

    var urlRequest: URLRequest? {
        guard let targetURL = targetURL else { return nil }
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
        urlComponents.queryItems = defaultQueryItems + queryItems
        return urlComponents.url
    }

    private var defaultQueryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "api_key", value: NetworkConfiguration.apiKey),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "method", value: resource)
        ]
    }
}
