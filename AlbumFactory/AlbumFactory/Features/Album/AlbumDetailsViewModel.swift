import Foundation
import Combine
import SwiftUI

class AlbumDetailsViewModel: ObservableObject {

    // MARK: - Inner Types

    enum ViewState: Equatable {
        struct AlbumDetailsContent: Equatable {
            let name: String
            let artistName: String
            let info: String
            let imageUrlString: String?
            let isLiked: Bool
            let trackViewModels: [AlbumTrackViewModel]

            var systemIconName: String {
                isLiked ? "heart.fill" : "heart"
            }
        }

        case loading
        case networkData(content: AlbumDetailsContent)
        case diskData(content: AlbumDetailsContent)
    }

    // MARK: - Properties
    // MARK: Immutable

    let storeManager: StoreManager
    let networkAPI: NetworkAPI

    // MARK: Mutable

    private var cancellables = Set<AnyCancellable>()

    // MARK: Published

    @Published var album: Album
    @Published private(set) var viewState: ViewState = .loading

    // MARK: - Initializers

    init(album: Album, storeManager: StoreManager, networkAPI: NetworkAPI) {
        self.album = album
        self.storeManager = storeManager
        self.networkAPI = networkAPI
        setupObserving()
    }

    // MARK: - Setups

    private func setupObserving() {
        handleResponse(album, isNetworkData: false)

        networkAPI.albumDetails(album.mbid)
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
                receiveValue: { [weak self] in self?.handleResponse($0.album, isNetworkData: true) }
            )
            .store(in: &cancellables)
    }

    // MARK: - Actions

    func tappedLikeButton() {
        if isAlbumLiked {
            storeManager.deleteAlbum(album: album)
        } else {
            storeManager.storeAlbum(album: album)
        }

        updateViewState(isNetworkData: true)
    }

    func updateViewState(isNetworkData: Bool) {
        let content = ViewState.AlbumDetailsContent(
            name: album.name,
            artistName: album.artist?.name ?? "",
            info: album.artist?.content ?? "",
            imageUrlString: album.imageUrl,
            isLiked: isAlbumLiked,
            trackViewModels: album.tracks.map { AlbumTrackViewModel(track: $0) }
        )

        viewState = isNetworkData ? ViewState.networkData(content: content) : ViewState.diskData(content: content)
    }

    // MARK: - Helpers

    private func handleResponse(_ album: Album, isNetworkData: Bool) {
        if !album.tracks.isEmpty {
            self.album.updateTracks(tracks: album.tracks)
            storeManager.updateAlbumTracks(album: self.album)
        }
        updateViewState(isNetworkData: isNetworkData)
    }

    var isAlbumLiked: Bool {
        storeManager.isAlbumStored(album: album)
    }
}
