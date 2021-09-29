import Foundation
import Combine

class ArtistAlbumsContentViewModel: ObservableObject {

    // MARK: - Properties
    // MARK: Immutable

    private let networkAPI: NetworkAPI
    private let artist: Artist

    // MARK: Mutable

    private var cancellables = Set<AnyCancellable>()

    // MARK: Published

    @Published var albums = [Album]()

    // MARK: - Initializers

    init(artist: Artist,
         networkAPI: NetworkAPI) {
        self.artist = artist
        self.networkAPI = networkAPI
        setupObserving()
    }

    // MARK: - Setups

    private func setupObserving() {
        guard let artistId = artist.mbid else { return }

        networkAPI.artistAlbums(artistId)
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

    private func handleResponse(_ response: ArtistAlbumsResponse) {
        albums = response.albums.filter { $0.name != "(null)" }
    }
}
