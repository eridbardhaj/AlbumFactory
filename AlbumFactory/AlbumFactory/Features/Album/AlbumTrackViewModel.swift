import Foundation
import Combine
import SwiftUI

class AlbumTrackViewModel: ObservableObject, Equatable, Identifiable {

    // MARK: - Inner Types

    enum ViewState: Equatable {
        struct AlbumTrackContent: Equatable {
            let name: String
            let duration: String
        }

        case empty
        case data(content: AlbumTrackContent)
    }

    // MARK: - Properties
    // MARK: Immutable

    private let track: Track

    // MARK: Mutable

    private var cancellables = Set<AnyCancellable>()

    // MARK: Published

    @Published private(set) var viewState: ViewState = .empty

    // MARK: - Initializers

    init(track: Track) {
        self.track = track
        updateViewState()
    }

    // MARK: - Actions

    func updateViewState() {
        viewState = ViewState.data(
            content: ViewState.AlbumTrackContent(
                name: track.name,
                duration: track.duration?.hhMMFormattedString ?? ""
            )
        )
    }

    // MARK: - Protocol Conformance
    // MARK: Equatable

    static func == (lhs: AlbumTrackViewModel, rhs: AlbumTrackViewModel) -> Bool {
        lhs.track == rhs.track &&
        lhs.viewState == rhs.viewState
    }
}
