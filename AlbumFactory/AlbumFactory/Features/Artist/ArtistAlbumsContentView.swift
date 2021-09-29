import SwiftUI

protocol ArtistAlbumsContentViewDelegate: AnyObject {
    func artistAlbumsContentViewDidTapAlbum(album: Album)
}

struct ArtistAlbumsContentView: View {

    // MARK: - Properties
    // MARK: Mutable

    @ObservedObject private var viewModel: ArtistAlbumsContentViewModel
    private weak var coordinatorDelegate: ArtistAlbumsContentViewDelegate?

    // MARK: - Initializers

    init(viewModel: ArtistAlbumsContentViewModel, coordinatorDelegate: ArtistAlbumsContentViewDelegate?) {
        self.viewModel = viewModel
        self.coordinatorDelegate = coordinatorDelegate
    }

    // MARK: - View Configuration

    var body: some View {
        Group {
            CollectionView(
                items: $viewModel.itemViewModels,
                tapAction: { itemViewModel, _ in
                    coordinatorDelegate?.artistAlbumsContentViewDidTapAlbum(album: itemViewModel.album)
                },
                itemBuilder: { itemViewModel, _ in
                    ArtistAlbumsContentItemView(
                        viewModel: itemViewModel,
                        likeAction: {
                            viewModel.tappedLikeButton(on: itemViewModel)
                        }
                    )
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle("Albums")
        }
    }
}

struct ArtistAlbumsContentView_Previews: PreviewProvider {
    static var previews: some View {
        let artist = Artist(id: UUID().uuidString, mbid: UUID().uuidString, name: "Eminem", listeners: "123212", visitUrl: nil, imageUrl: nil)
        let viewModel = ArtistAlbumsContentViewModel(artist: artist, networkAPI: NetworkAPIMock(), storeManager: StoreManager())
        ArtistAlbumsContentView(viewModel: viewModel, coordinatorDelegate: nil)
    }
}
