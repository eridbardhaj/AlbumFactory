import SwiftUI

protocol HomeViewDelegate: AnyObject {
    func homeViewDidTapAlbum(album: Album)
    func homeViewDidTapSearchButton()
}

struct HomeView: View {

    // MARK: - Properties
    // MARK: Mutable

    @ObservedObject private var viewModel: HomeViewModel
    private weak var coordinatorDelegate: HomeViewDelegate?

    // MARK: - Initializers

    init(viewModel: HomeViewModel, coordinatorDelegate: HomeViewDelegate?) {
        self.viewModel = viewModel
        self.coordinatorDelegate = coordinatorDelegate
    }

    // MARK: - View Configuration

    var body: some View {
        Group {
            CollectionView(
                items: $viewModel.itemViewModels,
                tapAction: { itemViewModel, _ in
                    coordinatorDelegate?.homeViewDidTapAlbum(album: itemViewModel.album)
                },
                itemBuilder: { itemViewModel, _ in
                    HomeItemView(
                        viewModel: itemViewModel,
                        likeAction: {
                            viewModel.tappedLikeButton(on: itemViewModel)
                        }
                    )
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar(content: {
                Button(action: {
                    coordinatorDelegate?.homeViewDidTapSearchButton()
                }) {
                    Image(systemName: "magnifyingglass")
                }
            })
            .navigationBarTitle("Albums")
        }
    }
}

struct HomeContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HomeViewModel(networkAPI: NetworkAPIMock(), storeManager: StoreManager())
        HomeView(viewModel: viewModel, coordinatorDelegate: nil)
    }
}
