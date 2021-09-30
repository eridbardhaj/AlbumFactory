import Foundation
import XCTest
import Nimble
import SwiftUI
import RealmSwift
@testable import AlbumFactory


class AppCooordinatorTests: XCTestCase {

    // MARK: - Properties
    // MARK: Mutable

    var coordinator: AppCoordinator!
    var windowMock: UIWindowTypeMock!
    var networkKitMock: NetworkKitTypeMock!
    var storeManagerMock: StoreManagerTypeMock!
    var navigationControllerMock: UINavigationControllerMock!

    // MARK: - Test lifecycle

    override func setUp() {
        super.setUp()

        setupMocks()
    }


    // MARK: - Setups

    private func setupMocks() {
        windowMock = UIWindowTypeMock()
        networkKitMock = NetworkKitTypeMock()
        storeManagerMock = StoreManagerTypeMock()
        navigationControllerMock = UINavigationControllerMock()
        coordinator = AppCoordinator(
            window: windowMock,
            navigationController: navigationControllerMock,
            networkKit: networkKitMock,
            storeManager: storeManagerMock,
            dismissable: nil
        )
    }


    // MARK: - Tests
    // MARK: Onboarding start

    func test_start_homeIsShown() {
        coordinator.start()

        let hostingViewController = self.navigationControllerMock.parameter.setViewControllers?.first as? UIHostingController<HomeView>

        expect(hostingViewController).notTo(beNil())
        expect(self.windowMock.calledCount.makeKeyAndVisible).to(equal(1))
        expect(self.windowMock.rootViewController).to(equal(navigationControllerMock))
    }

    func test_homeViewDidTapAlbum_albumDetailsIsShown() {
        let album = Album(mbid: "", name: "", artist: nil, plays: nil, listeners: nil, imageUrl: nil, tracks: [])
        coordinator.homeViewDidTapAlbum(album: album)

        let hostingViewController = self.navigationControllerMock.parameter.pushedViewController as? UIHostingController<AlbumDetailsView>

        expect(hostingViewController).notTo(beNil())
        expect(self.navigationControllerMock.calledCount.pushViewController).to(equal(1))
    }

    func test_homeViewDidTapSearchButton_searchArtistsIsShown() {
        coordinator.homeViewDidTapSearchButton()

        let hostingViewController = self.navigationControllerMock.parameter.pushedViewController as? UIHostingController<ArtistSearchView>

        expect(hostingViewController).notTo(beNil())
        expect(self.navigationControllerMock.calledCount.pushViewController).to(equal(1))
    }

    func test_artistSearchViewDidSelectArtist_artistAlbumsIsShown() {
        let artist = Artist(mbid: "", name: "", listeners: nil, plays: nil, content: nil, imageUrl: nil)
        coordinator.artistSearchViewDidSelectArtist(artist: artist)

        let hostingViewController = self.navigationControllerMock.parameter.pushedViewController as? UIHostingController<ArtistAlbumsView>

        expect(hostingViewController).notTo(beNil())
        expect(self.navigationControllerMock.calledCount.pushViewController).to(equal(1))
    }

    func test_artistAlbumsViewDidTapAlbum_artistAlbumsIsShown() {
        let album = Album(mbid: "", name: "", artist: nil, plays: nil, listeners: nil, imageUrl: nil, tracks: [])
        coordinator.artistAlbumsViewDidTapAlbum(album: album)

        let hostingViewController = self.navigationControllerMock.parameter.pushedViewController as? UIHostingController<AlbumDetailsView>

        expect(hostingViewController).notTo(beNil())
        expect(self.navigationControllerMock.calledCount.pushViewController).to(equal(1))
    }

    func test_supportedOrientations_allButUpsideDownReturned() {
        expect(self.coordinator.supportedOrientations).to(equal([.allButUpsideDown]))
    }
}
