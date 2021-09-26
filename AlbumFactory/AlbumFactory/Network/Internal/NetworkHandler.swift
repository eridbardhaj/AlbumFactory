import Foundation
import Combine
import Alamofire

protocol NetworkHandling {
    func dataTaskPublisher(for request: URLRequest) -> DataResponsePublisher<Data>
}

class NetworkHandler: NetworkHandling {

    // MARK: - Properties
    // MARK: Injected
    
    let session: Session

    // MARK: - Initializers
    
    init(session: Session) {
        self.session = session
    }

    // MARK: - Protocol Conformance
    // MARK: NetworkHandling

    func dataTaskPublisher(for request: URLRequest) -> DataResponsePublisher<Data> {
        session.request(request)
            .publishData()
    }
}
