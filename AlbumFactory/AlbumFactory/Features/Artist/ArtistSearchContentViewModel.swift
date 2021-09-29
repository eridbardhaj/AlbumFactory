import Foundation
import Combine
import SwiftUI

class ArtistSearchContentViewModel: ObservableObject {

    // MARK: - Properties
    // MARK: Immutable

    private let networkAPI: NetworkAPI

    // MARK: Mutable

    private var cancellables = Set<AnyCancellable>()

    // MARK: Published

    @Published var artists = [Artist]()
    @Published var searchText: String = ""

    // MARK: - Initializers

    init(networkAPI: NetworkAPI) {
        self.networkAPI = networkAPI
        setupObserving()
    }

    // MARK: - Setups

    private func setupObserving() {
        $searchText.debounce(for: 1, scheduler: DispatchQueue.main)
            .filter { !$0.isEmpty }
            .flatMap { self.networkAPI.searchArtists(searchKeyword: String($0)) }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
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
        artists = response.artists.filter { $0.name != "(null)" }
    }
}
