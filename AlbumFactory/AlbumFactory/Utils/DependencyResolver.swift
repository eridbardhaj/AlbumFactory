import Foundation
import Alamofire
import RealmSwift

class DependencyResolver {
    static let session = Session()
    static let networkHandler: NetworkHandlerType = NetworkHandler(session: session)
    static let jsonDecoder = JSONDecoder()
    static let agent: Agent = NetworkAgent(networkHandler: networkHandler, jsonDecoder: jsonDecoder)
    static let networkKit: NetworkKitType = NetworkKit(agent: agent)
    static let application: AppApplication = UIApplication.shared
    static let realm = try! Realm()
    static let storeManager: StoreManagerType = StoreManager(realm: realm)
}
