import Foundation
import Combine

protocol NetworkAPI {
    func run<Request: NetworkRequest>(request: Request) -> AnyPublisher<Request.ResponseType, Error>
}

enum NetworkKitError: Error {
    case invalidURLRequest
    case unexpected(code: Int)
}

class NetworkKit: NetworkAPI {
    
    // MARK: - Properties
    // MARK: Injected
    
    let agent: Agent
    
    // MARK: - Initializers
    
    init(agent: Agent) {
        self.agent = agent
    }
    
    // MARK: - Protocol Conformance
    // MARK: NetworkAPI

    func run<Request: NetworkRequest>(request: Request) -> AnyPublisher<Request.ResponseType, Error> {
        guard let urlRequest = request.urlRequest else {
            return Fail(error: NetworkKitError.invalidURLRequest).eraseToAnyPublisher()
        }

        return agent.run(urlRequest)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}


