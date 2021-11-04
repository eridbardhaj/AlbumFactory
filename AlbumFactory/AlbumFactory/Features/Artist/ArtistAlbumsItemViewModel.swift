import Foundation
import Combine
import SwiftUI

class ArtistAlbumsItemViewModel: LikeContentViewModel, Identifiable, Equatable {

    // MARK: - Properties
    // MARK: Immutable

    let album: Album
    let storeManager: StoreManagerType

    // MARK: Mutable

    private var cancellables = Set<AnyCancellable>()

    // MARK: Published

    @Published var likedAlbum = false

    // MARK: - Initializers

    init(album: Album, storeManager: StoreManagerType) {
        self.album = album
        self.storeManager = storeManager
        super.init(viewState: .loading)
        
        setupObserving()
    }

    // MARK: - Setups

    private func setupObserving() {
        $likedAlbum
            .map { [unowned self] _ in
                .dataLoaded(
                    content: .init(
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

    static func == (lhs: ArtistAlbumsItemViewModel, rhs: ArtistAlbumsItemViewModel) -> Bool {
        lhs.album == rhs.album &&
        lhs.likedAlbum == rhs.likedAlbum &&
        lhs.viewState == rhs.viewState
    }

    // MARK: - Helpers

    var isAlbumLiked: Bool {
        storeManager.isAlbumStored(album: album)
    }
}
