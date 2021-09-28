import Foundation
import Combine
import SwiftUI

class HomeContentItemViewModel: ObservableObject {

    // MARK: - Inner Types

    enum ViewState {
        struct HomeContentItemContent {
            let name: String
            let imageUrlString: String?
        }

        case loading
        case dataLoaded(content: HomeContentItemContent)
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
            content: ViewState.HomeContentItemContent(
                name: album.name ?? "",
                imageUrlString: album.imageUrl
            )
        )
    }
}
