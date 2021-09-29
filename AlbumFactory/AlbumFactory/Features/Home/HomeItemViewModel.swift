import Foundation
import Combine
import SwiftUI

class HomeItemViewModel: ObservableObject, Identifiable, Equatable {

    // MARK: - Inner Types

    enum ViewState: Equatable {
        struct HomeItemContent: Equatable {
            let name: String
            let imageUrlString: String?
            let isLiked: Bool

            var systemIconName: String {
                isLiked ? "heart.fill" : "heart"
            }
        }

        case loading
        case dataLoaded(content: HomeItemContent)
    }

    // MARK: - Properties
    // MARK: Immutable

    let album: Album

    // MARK: Mutable

    private var cancellables = Set<AnyCancellable>()

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
            content: ViewState.HomeItemContent(
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
