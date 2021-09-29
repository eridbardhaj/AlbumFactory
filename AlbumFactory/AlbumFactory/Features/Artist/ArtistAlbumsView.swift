import SwiftUI

protocol ArtistAlbumsViewDelegate: AnyObject {
    func artistAlbumsViewDidTapAlbum(album: Album)
}

struct ArtistAlbumsView: View {

    // MARK: - Properties
    // MARK: Mutable

    @ObservedObject private var viewModel: ArtistAlbumsViewModel
    private weak var coordinatorDelegate: ArtistAlbumsViewDelegate?

    // MARK: - Initializers

    init(viewModel: ArtistAlbumsViewModel, coordinatorDelegate: ArtistAlbumsViewDelegate?) {
        self.viewModel = viewModel
        self.coordinatorDelegate = coordinatorDelegate
    }

    // MARK: - View Configuration

    var body: some View {
        Group {
            CollectionView(
                items: $viewModel.itemViewModels,
                tapAction: { itemViewModel, _ in
                    coordinatorDelegate?.artistAlbumsViewDidTapAlbum(album: itemViewModel.album)
                },
                itemBuilder: { itemViewModel, _ in
                    ArtistAlbumsItemView(
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
        let viewModel = ArtistAlbumsViewModel(artist: artist, networkAPI: NetworkAPIMock(), storeManager: StoreManager())
        ArtistAlbumsView(viewModel: viewModel, coordinatorDelegate: nil)
    }
}
