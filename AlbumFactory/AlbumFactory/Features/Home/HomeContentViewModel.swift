import Foundation
import Combine

class HomeContentViewModel: ObservableObject {

    // MARK: - Properties
    // MARK: Immutable

    private let networkAPI: NetworkAPI

    // MARK: Mutable

    private var cancellables = Set<AnyCancellable>()

    // MARK: Published

    @Published var albums = [Album]()

    // MARK: - Initializers

    init(networkAPI: NetworkAPI) {
        self.networkAPI = networkAPI
        setupObserving()
    }

    // MARK: - Setups

    private func setupObserving() {
        networkAPI.run(request: ArtistNetworkRequest.Albums(artistId: "b95ce3ff-3d05-4e87-9e01-c97b66af13d4"))
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
        albums = response.albums
    }
}
