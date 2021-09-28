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
                items: $viewModel.albums,
                tapAction: { album, _ in
                    coordinatorDelegate?.homeContentViewDidTapAlbum(album: album)
                },
                itemBuilder: { album, _ in
                    let viewModel = HomeContentItemViewModel(album: album)
                    HomeContentItemView(viewModel: viewModel)
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Albums")
        }
    }
}


struct HomeContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HomeContentViewModel(networkAPI: NetworkAPIMock())
        HomeContentView(viewModel: viewModel, coordinatorDelegate: nil)
    }
}
