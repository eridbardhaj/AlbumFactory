import Foundation
import Combine
import SwiftUI

class ArtistSearchViewModel: ObservableObject {

    // MARK: - Inner Types

    enum ViewState {
        case empty(text: String, action: (() -> Void)?)
        case data(itemViewModels: [ArtistSearchItemViewModel])
    }

    // MARK: - Properties
    // MARK: Immutable

    private let networkAPI: NetworkAPI

    // MARK: Mutable

    private var cancellables = Set<AnyCancellable>()

    // MARK: Published

    @Published private(set) var viewState: ViewState = .empty(text: "Search your favourite artists", action: nil)
    @Published var searchText: String = ""

    // MARK: - Initializers

    init(networkAPI: NetworkAPI) {
        self.networkAPI = networkAPI
        start()
    }

    // MARK: - Setups

    func start() {
        $searchText.debounce(for: 1, scheduler: DispatchQueue.main)
            .filter { !$0.isEmpty }
            .flatMap { [unowned self] in self.networkAPI.searchArtists(searchKeyword: String($0)) }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.viewState = ViewState.empty(text: "Network failed") {
                            self?.start()
                        }
                        print(error)
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] in self?.handleResponse($0) }
            )
            .store(in: &cancellables)
    }

    // MARK: - Helpers
    // MARK: Handlers

    private func handleResponse(_ response: ArtistSearchResponse) {
        let itemViewModels = response.artists
            .filter { $0.name != "(null)" && !$0.mbid.isEmpty }
            .map { ArtistSearchItemViewModel(artist: $0) }
        viewState = ViewState.data(itemViewModels: itemViewModels)
    }
}
