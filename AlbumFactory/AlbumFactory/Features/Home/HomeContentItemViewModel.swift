import Foundation
import Combine
import SwiftUI

class HomeContentItemViewModel: ObservableObject, Identifiable, Equatable {

    // MARK: - Inner Types

    enum ViewState: Equatable {
        struct HomeContentItemContent: Equatable {
            let name: String
            let imageUrlString: String?
            let isLiked: Bool

            var systemIconName: String {
                isLiked ? "heart.fill" : "heart"
            }
        }

        case loading
        case dataLoaded(content: HomeContentItemContent)
    }

    // MARK: - Properties
    // MARK: Immutable

    let album: Album

    // MARK: Mutable

    private var cancellables = Set<AnyCancellable>()

    // MARK: Published

    @Published private(set) var likedAlbum = false
    @Published private(set) var viewState: ViewState = .loading

    // MARK: - Initializers

    init(album: Album) {
        self.album = album
        setupObserving()
    }

    // MARK: - Setups

    private func setupObserving() {
        $likedAlbum
            .print("Erid")
            .map { [album] in
                ViewState.dataLoaded(
                    content: ViewState.HomeContentItemContent(
                        name: album.name ?? "",
                        imageUrlString: album.imageUrl,
                        isLiked: $0
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

    static func == (lhs: HomeContentItemViewModel, rhs: HomeContentItemViewModel) -> Bool {
        lhs.album == rhs.album &&
        lhs.likedAlbum == rhs.likedAlbum &&
        lhs.viewState == rhs.viewState
    }

    // MARK: - Helpers

    var isAlbumLiked: Bool {
        likedAlbum
    }
}
