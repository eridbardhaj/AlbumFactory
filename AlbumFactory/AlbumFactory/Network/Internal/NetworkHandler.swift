import Foundation
import Combine
import Alamofire

protocol NetworkHandlerType {
    func dataTaskPublisher(for request: URLRequest) -> DataResponsePublisher<Data>
}

class NetworkHandler: NetworkHandlerType {

    // MARK: - Properties
    // MARK: Injected
    
    let session: Session

    // MARK: - Initializers
    
    init(session: Session) {
        self.session = session
    }

    // MARK: - Protocol Conformance
    // MARK: NetworkHandlerType

    func dataTaskPublisher(for request: URLRequest) -> DataResponsePublisher<Data> {
        session.request(request)
            .publishData()
    }
}
