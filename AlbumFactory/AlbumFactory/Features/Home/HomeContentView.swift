import SwiftUI

protocol HomeContentViewDelegate: AnyObject {
    func homeContentViewDidTapAlbum(album: Album)
    func homeContentViewDidTapSearchButton()
}

struct HomeContentView: View {

    // MARK: - Properties
    // MARK: Mutable

    @ObservedObject private var viewModel: HomeContentViewModel
    private weak var coordinatorDelegate: HomeContentViewDelegate?

    // MARK: - Initializers

    init(viewModel: HomeContentViewModel, coordinatorDelegate: HomeContentViewDelegate?) {
        self.viewModel = viewModel
        self.coordinatorDelegate = coordinatorDelegate
    }

    // MARK: - View Configuration

    var body: some View {
        Group {
            CollectionView(
                items: $viewModel.itemViewModels,
                tapAction: { itemViewModel, _ in
                    coordinatorDelegate?.homeContentViewDidTapAlbum(album: itemViewModel.album)
                },
                itemBuilder: { itemViewModel, _ in
                    HomeContentItemView(
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
                    coordinatorDelegate?.homeContentViewDidTapSearchButton()
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
        let viewModel = HomeContentViewModel(networkAPI: NetworkAPIMock(), storeManager: StoreManager())
        HomeContentView(viewModel: viewModel, coordinatorDelegate: nil)
    }
}
