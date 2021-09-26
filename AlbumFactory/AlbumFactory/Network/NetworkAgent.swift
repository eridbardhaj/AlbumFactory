import Combine
import Foundation

struct Response<T> {
    let value: T
    let response: URLResponse
}

protocol Agent {
    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error>
}

class NetworkAgent {
    
    // MARK: - Properties
    // MARK: Injected
    
    private let networkHandler: NetworkHandling
    private let decoder: JSONDecoder
    
    // MARK: - Initializers
    
    init(networkHandler: NetworkHandling,
         decoder: JSONDecoder) {
        self.networkHandler = networkHandler
        self.decoder = decoder
    }
}

