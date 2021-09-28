import SwiftUI
import Alamofire

@main
struct AlbumFactoryApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                let viewModel = HomeContentViewModel(networkAPI: DependencyResolver.networkAPI)
                HomeContentView(viewModel: viewModel)
            }
        }
    }
}
