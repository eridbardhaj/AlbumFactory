import Foundation
import SwiftUI

private enum AppStep: CoordinatorStep {
    case home
    case search
    case albumList(artist: Artist)
    case albumInfo(album: Album)
}

class AppCoordinator: NSObject, Coordinatable {

    // MARK: - Properties
    // MARK: Injected Dependencies

    private let window: AppWindow?
    private let application: AppApplication
    private let networkAPI: NetworkAPI

    // MARK: Immutable

    let identifier = UUID()

    // MARK: Mutable

    var childCoordinators = [UUID: Coordinatable]()
    var dismissable: CoordinatorDismissable?
    var navigationController = UINavigationController()

    // MARK: - Initializers

    init(window: AppWindow?,
         application: AppApplication,
         networkAPI: NetworkAPI,
         dismissable: CoordinatorDismissable? = nil) {
        self.window = window
        self.application = application
        self.networkAPI = networkAPI
        self.dismissable = dismissable
        super.init()
    }

    // MARK: - Protocol Conformance
    // MARK: Coordinatable

    func coordinate(to step: CoordinatorStep) {
        guard let step = step as? AppStep else { return }

        switch step {
        case .home:
            showHome()
        case .search:
            showSearchArtists()
        case .albumList(let artist):
            showAlbumList(for: artist)
        case .albumInfo(let album):
            showAlbumInfo(album: album)
        }
    }

    func start() {
        coordinate(to: AppStep.home)
    }

    // MARK: - Transitions

    private func showHome() {
        let viewModel = HomeContentViewModel(networkAPI: networkAPI)
        let viewController = UIHostingController(rootView: HomeContentView(viewModel: viewModel, coordinatorDelegate: self))
        navigationController.viewControllers = [viewController]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func showSearchArtists() {
        let viewModel = ArtistSearchContentViewModel(networkAPI: networkAPI)
        let viewController = UIHostingController(rootView: ArtistSearchContentView(viewModel: viewModel, coordinatorDelegate: self))
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showAlbumList(for artist: Artist) {}

    private func showAlbumInfo(album: Album) {}

    // MARK: - Helpers

    var supportedOrientations: UIInterfaceOrientationMask {
        [.allButUpsideDown]
    }
}

extension AppCoordinator: HomeContentViewDelegate {
    func homeContentViewDidTapAlbum(album: Album) {
        coordinate(to: AppStep.albumInfo(album: album))
    }

    func homeContentViewDidTapSearchButton() {
        coordinate(to: AppStep.search)
    }
}

extension AppCoordinator: ArtistSearchContentViewDelegate {
    func artistSearchContentViewDidSelectArtist(artist: Artist) {
        coordinate(to: AppStep.albumList(artist: artist))
    }
}
