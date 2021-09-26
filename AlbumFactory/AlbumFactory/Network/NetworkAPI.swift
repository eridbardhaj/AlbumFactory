import Foundation
import Combine

class NetworkAPI {
    
    // MARK: - Properties
    // MARK: Injected
    
    let agent: Agent
    
    // MARK: - Initializers
    
    init(agent: Agent) {
        self.agent = agent
    }
    
    // MARK: - Actions
    
    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Helpers

    private func prepareRequest(_ route: String) -> URLRequest {
        let urlString = NetworkAPIConfiguration.baseURLString + route
        return URLRequest(url: urlString.requiredURL)
    }
}


