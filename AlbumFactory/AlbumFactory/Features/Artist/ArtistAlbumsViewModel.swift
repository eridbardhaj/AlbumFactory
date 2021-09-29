import Foundation
import Combine

class ArtistAlbumsViewModel: ObservableObject {

    // MARK: - Properties
    // MARK: Immutable

    private let networkAPI: NetworkAPI
    private let artist: Artist
    private let storeManager: StoreManager

    // MARK: Mutable

    private var cancellables = Set<AnyCancellable>()

    // MARK: Published

    @Published var itemViewModels = [ArtistAlbumsItemViewModel]()

    // MARK: - Initializers

    init(artist: Artist,
         networkAPI: NetworkAPI,
         storeManager: StoreManager) {
        self.artist = artist
        self.networkAPI = networkAPI
        self.storeManager = storeManager
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

    // MARK: - Actions

    func tappedLikeButton(on itemViewModel: ArtistAlbumsItemViewModel) {
        if storeManager.isAlbumStored(album: itemViewModel.album) {
            storeManager.deleteAlbum(album: itemViewModel.album)
                .sink(
                    receiveCompletion: { completed in
                        switch completed {
                        case .failure(let error):
                            print(error)
                        case .finished:
                            itemViewModel.likedAlbum.toggle()
                            break
                        }
                    },
                    receiveValue: { _ in }
                )
                .store(in: &cancellables)
        } else {
            storeManager.storeAlbum(album: itemViewModel.album)
                .sink(
                    receiveCompletion: { completed in
                        switch completed {
                        case .failure(let error):
                            print(error)
                        case .finished:
                            itemViewModel.likedAlbum.toggle()
                            break
                        }
                    },
                    receiveValue: { _ in }
                )
                .store(in: &cancellables)
        }

//        itemViewModel.tappedLikeButton()
    }

    // MARK: - Helpers
    // MARK: Handlers

    private func handleResponse(_ response: ArtistAlbumsResponse) {
        itemViewModels = response.albums
            .filter { $0.name != "(null)" && $0.mbid != nil }
            .map { ArtistAlbumsItemViewModel(album: $0, storeManager: storeManager) }
    }
}
