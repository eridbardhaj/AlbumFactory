import Foundation
import Alamofire

class DependencyResolver {
    static let session = Session()
    static let networkHandler = NetworkHandler(session: session)
    static let jsonDecoder = JSONDecoder()
    static let agent = NetworkAgent(networkHandler: networkHandler, jsonDecoder: jsonDecoder)
    static let networkAPI = NetworkKit(agent: agent)
    static let application: AppApplication = UIApplication.shared
}
