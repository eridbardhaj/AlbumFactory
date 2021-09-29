import Foundation
import Combine
import SwiftUI

class ArtistSearchItemViewModel: ObservableObject, Equatable, Identifiable {

    // MARK: - Inner Types

    enum ViewState: Equatable {
        struct ArtistSearchItemViewContent: Equatable {
            let name: String
            let imageUrlString: String?
            let plays: String
        }

        case empty
        case data(content: ArtistSearchItemViewContent)
    }

    // MARK: - Properties
    // MARK: Immutable

    let artist: Artist

    // MARK: Mutable

    private var cancellables = Set<AnyCancellable>()

    // MARK: Published

    @Published private(set) var viewState: ViewState = .empty

    // MARK: - Initializers

    init(artist: Artist) {
        self.artist = artist
        updateState()
    }

    // MARK: - Actions

    private func updateState() {
        viewState = ViewState.data(
            content: ViewState.ArtistSearchItemViewContent(
                name: artist.name,
                imageUrlString: artist.imageUrl,
                plays: String("Plays: \(artist.listeners ?? "N/A")")
            )
        )
    }

    // MARK: - Protocol Conformance
    // MARK: Equatable

    static func == (lhs: ArtistSearchItemViewModel, rhs: ArtistSearchItemViewModel) -> Bool {
        lhs.artist == rhs.artist &&
        lhs.viewState == rhs.viewState
    }
}
