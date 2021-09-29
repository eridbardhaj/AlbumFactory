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
    private let networkKit: NetworkKitType
    private let storeManager: StoreManagerType

    // MARK: Immutable

    let identifier = UUID()

    // MARK: Mutable

    var childCoordinators = [UUID: Coordinatable]()
    var dismissable: CoordinatorDismissable?
    var navigationController = UINavigationController()

    // MARK: - Initializers

    init(window: AppWindow?,
         application: AppApplication,
         networkKit: NetworkKitType,
         storeManager: StoreManagerType,
         dismissable: CoordinatorDismissable? = nil) {
        self.window = window
        self.application = application
        self.networkKit = networkKit
        self.storeManager = storeManager
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
        let viewModel = HomeViewModel(networkKit: networkKit, storeManager: storeManager)
        let viewController = UIHostingController(rootView: HomeView(viewModel: viewModel, coordinatorDelegate: self))
        navigationController.viewControllers = [viewController]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func showSearchArtists() {
        let viewModel = ArtistSearchViewModel(networkKit: networkKit)
        let viewController = UIHostingController(rootView: ArtistSearchView(viewModel: viewModel, coordinatorDelegate: self))
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showAlbumList(for artist: Artist) {
        let viewModel = ArtistAlbumsViewModel(artist: artist, networkKit: networkKit, storeManager: storeManager)
        let viewController = UIHostingController(rootView: ArtistAlbumsView(viewModel: viewModel, coordinatorDelegate: self))
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showAlbumInfo(album: Album) {
        let viewModel = AlbumDetailsViewModel(album: album, storeManager: storeManager, networkKit: networkKit)
        let viewController = UIHostingController(rootView: AlbumDetailsView(viewModel: viewModel))
        navigationController.pushViewController(viewController, animated: true)
    }

    // MARK: - Helpers

    var supportedOrientations: UIInterfaceOrientationMask {
        [.allButUpsideDown]
    }
}

extension AppCoordinator: HomeViewDelegate {
    func homeViewDidTapAlbum(album: Album) {
        coordinate(to: AppStep.albumInfo(album: album))
    }

    func homeViewDidTapSearchButton() {
        coordinate(to: AppStep.search)
    }
}

extension AppCoordinator: ArtistSearchViewDelegate {
    func artistSearchViewDidSelectArtist(artist: Artist) {
        coordinate(to: AppStep.albumList(artist: artist))
    }
}

extension AppCoordinator: ArtistAlbumsViewDelegate {
    func artistAlbumsViewDidTapAlbum(album: Album) {
        coordinate(to: AppStep.albumInfo(album: album))
    }
}
