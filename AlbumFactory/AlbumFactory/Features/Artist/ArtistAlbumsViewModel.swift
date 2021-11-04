import Foundation
import Combine

class ArtistAlbumsViewModel: ObservableObject {

    // MARK: - Properties
    // MARK: Immutable

    private let networkKit: NetworkKitType
    private let storeManager: StoreManagerType

    // MARK: Mutable

    var artist: Artist
    private var cancellables = Set<AnyCancellable>()

    // MARK: Published

    @Published var itemViewModels = [ArtistAlbumsItemViewModel]()

    // MARK: - Initializers

    init(artist: Artist,
         networkKit: NetworkKitType,
         storeManager: StoreManagerType) {
        self.artist = artist
        self.networkKit = networkKit
        self.storeManager = storeManager
        setupObserving()
    }

    // MARK: - Setups

    private func setupObserving() {
        Publishers.CombineLatest(networkKit.artistDetails(artist.mbid), networkKit.artistAlbums(artist.mbid))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] in self?.handleResponse($0, artistAlbumResponse: $1) }
            )
            .store(in: &cancellables)
    }

    // MARK: - Actions

    func tappedLikeButton(on itemViewModel: ArtistAlbumsItemViewModel) {
        if itemViewModel.isAlbumLiked {
            storeManager.deleteAlbum(album: itemViewModel.album)
        } else {
            storeManager.storeAlbum(album: itemViewModel.album)
        }

        itemViewModel.likedAlbum.toggle()
    }

    // MARK: - Helpers
    // MARK: Handlers

    private func handleResponse(_ artistInfoResponse: ArtistInfoResponse, artistAlbumResponse: ArtistAlbumsResponse) {
        itemViewModels = artistAlbumResponse.albums
            .filter { !$0.mbid.isEmpty && $0.mbid != "(null)" }
            .map {
                var album = $0
                album.updateArtist(artist: artistInfoResponse.artist)
                return album
            }
            .filter { $0.name != "(null)" }
            .map { ArtistAlbumsItemViewModel(album: $0, storeManager: storeManager) }
    }
}
