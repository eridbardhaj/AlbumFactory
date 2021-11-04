import Foundation
import Combine
import SwiftUI

class HomeItemViewModel: LikeContentViewModel, Identifiable, Equatable {

    // MARK: - Properties
    // MARK: Immutable

    let album: Album

    // MARK: Mutable

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializers

    init(album: Album) {
        self.album = album
        super.init(viewState: .loading)

        setupObserving()
    }

    // MARK: - Setups

    private func setupObserving() {
        viewState = .dataLoaded(
            content: .init(
                name: album.name,
                imageUrlString: album.imageUrl,
                isLiked: true
            )
        )
    }

    // MARK: - Protocol Conformance
    // MARK: Equatable

    static func == (lhs: HomeItemViewModel, rhs: HomeItemViewModel) -> Bool {
        lhs.album == rhs.album &&
        lhs.viewState == rhs.viewState
    }
}
