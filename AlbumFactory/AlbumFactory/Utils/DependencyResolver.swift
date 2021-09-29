import Foundation
import Alamofire
import RealmSwift

class DependencyResolver {
    static let session = Session()
    static let networkHandler = NetworkHandler(session: session)
    static let jsonDecoder = JSONDecoder()
    static let agent = NetworkAgent(networkHandler: networkHandler, jsonDecoder: jsonDecoder)
    static let networkAPI = NetworkKit(agent: agent)
    static let application: AppApplication = UIApplication.shared
    static let realm = try! Realm()
    static let storeManager = StoreManager(realm: realm)
}
