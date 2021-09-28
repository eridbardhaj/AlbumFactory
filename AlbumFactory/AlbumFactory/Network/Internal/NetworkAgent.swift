import Combine
import Foundation

struct Response<T> {
    let value: T
    let response: URLResponse
}

protocol Agent {
    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error>
}

class NetworkAgent: Agent {
    
    // MARK: - Properties
    // MARK: Injected
    
    private let networkHandler: NetworkHandling
    private let jsonDecoder: JSONDecoder
    
    // MARK: - Initializers
    
    init(networkHandler: NetworkHandling,
         jsonDecoder: JSONDecoder) {
        self.networkHandler = networkHandler
        self.jsonDecoder = jsonDecoder
    }

    // MARK: - Protocol Conformance
    // MARK: Agent

    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
        networkHandler
            .dataTaskPublisher(for: request)
            .tryMap { [unowned self] result -> Response<T> in
                guard let data = result.data,
                      let response = result.response else { throw URLError(.unknown) }

                let value = try self.jsonDecoder.decode(T.self, from: data)
                return Response(value: value, response: response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

