import Foundation
import Combine
import SwiftUI

class ArtistAlbumsContentItemViewModel: ObservableObject {

    // MARK: - Inner Types

    enum ViewState {
        struct ArtistAlbumsItemContent {
            let name: String
            let imageUrlString: String?
            let isLiked: Bool

            var systemIconName: String {
                isLiked ? "heart" : "heart.fill"
            }
        }

        case loading
        case dataLoaded(content: ArtistAlbumsItemContent)
    }

    // MARK: - Properties
    // MARK: Immutable

    private let album: Album

    // MARK: Published

    @Published private(set) var viewState: ViewState = .loading

    // MARK: - Initializers

    init(album: Album) {
        self.album = album
        setupObserving()
    }

    // MARK: - Setups

    private func setupObserving() {
        viewState = ViewState.dataLoaded(
            content: ViewState.ArtistAlbumsItemContent(
                name: album.name ?? "",
                imageUrlString: album.imageUrl,
                isLiked: false
            )
        )
    }
}
