import SwiftUI
import Alamofire

@main
struct AlbumFactoryApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                let session = Session()
                let networkHandler = NetworkHandler(session: session)
                let jsonDecoder = JSONDecoder()
                let agent = NetworkAgent(networkHandler: networkHandler, jsonDecoder: jsonDecoder)
                let networkAPI = NetworkKit(agent: agent)
                let viewModel = HomeContentViewModel(networkAPI: networkAPI)
                HomeContentView(viewModel: viewModel)
            }
        }
    }
}
