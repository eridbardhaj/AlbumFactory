import Foundation
import Combine
import RealmSwift

class HomeContentViewModel: ObservableObject {

    // MARK: - Properties
    // MARK: Immutable

    private let networkAPI: NetworkAPI
    private let storeManager: StoreManager

    // MARK: Mutable

    private var cancellables = Set<AnyCancellable>()

    // MARK: Published

    @Published var itemViewModels = [HomeContentItemViewModel]()
    
    // MARK: - Initializers

    init(networkAPI: NetworkAPI, storeManager: StoreManager) {
        self.networkAPI = networkAPI
        self.storeManager = storeManager
        setupObserving()
    }

    // MARK: - Setups

    private func setupObserving() {
        storeManager.results.objectWillChange
            .sink(receiveValue: { [weak self] _ in
                self?.handleResponse()
            })
            .store(in: &cancellables)
    }

    // MARK: - Actions

    func tappedLikeButton(on itemViewModel: HomeContentItemViewModel) {
        storeManager.deleteAlbum(album: itemViewModel.album)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }

    // MARK: - Helpers
    // MARK: Handlers

    private func handleResponse() {
        itemViewModels = storeManager.results.map { Album(persistedAlbum: $0) }
            .filter { $0.name != "(null)" && $0.mbid != nil }
            .map { HomeContentItemViewModel(album: $0) }
    }
}
