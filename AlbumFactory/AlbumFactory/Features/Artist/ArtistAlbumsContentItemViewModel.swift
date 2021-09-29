import Foundation
import Combine
import SwiftUI

class ArtistAlbumsContentItemViewModel: ObservableObject, Identifiable, Equatable {

    // MARK: - Inner Types

    enum ViewState: Equatable {
        struct ArtistAlbumsItemContent: Equatable {
            let name: String
            let imageUrlString: String?
            let isLiked: Bool

            var systemIconName: String {
                isLiked ? "heart.fill" : "heart"
            }
        }

        case loading
        case dataLoaded(content: ArtistAlbumsItemContent)
    }

    // MARK: - Properties
    // MARK: Immutable

    let album: Album
    let storeManager: StoreManager

    // MARK: Mutable

    private var cancellables = Set<AnyCancellable>()

    // MARK: Published

    @Published var likedAlbum = false
    @Published private(set) var viewState: ViewState = .loading

    // MARK: - Initializers

    init(album: Album, storeManager: StoreManager) {
        self.album = album
        self.storeManager = storeManager
        setupObserving()
    }

    // MARK: - Setups

    private func setupObserving() {
        $likedAlbum
            .map { [unowned self] _ in
                ViewState.dataLoaded(
                    content: ViewState.ArtistAlbumsItemContent(
                        name: self.album.name,
                        imageUrlString: self.album.imageUrl,
                        isLiked: self.isAlbumLiked
                    )
                )
            }
            .assign(to: \.viewState, on: self)
            .store(in: &cancellables)
    }

    // MARK: - Actions

    func tappedLikeButton() {
        likedAlbum.toggle()
    }

    // MARK: - Protocol Conformance
    // MARK: Equatable

    static func == (lhs: ArtistAlbumsContentItemViewModel, rhs: ArtistAlbumsContentItemViewModel) -> Bool {
        lhs.album == rhs.album &&
        lhs.likedAlbum == rhs.likedAlbum &&
        lhs.viewState == rhs.viewState
    }

    // MARK: - Helpers

    var isAlbumLiked: Bool {
        storeManager.isAlbumStored(album: album)
    }
}
