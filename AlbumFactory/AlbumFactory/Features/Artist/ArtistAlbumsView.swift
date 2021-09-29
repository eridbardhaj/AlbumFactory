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
        let artist = Artist(mbid: "123123123", name: "Eminem", listeners: "22210231", plays: "234234234", content: "Eminem is a very well known artist", imageUrl: "https://lastfm.freetls.fastly.net/i/u/174s/be7d9be5645e1a7d64f51579401e48c7.png")
        let viewModel = ArtistAlbumsViewModel(artist: artist, networkKit: NetworkKitTypeMock(), storeManager: StoreManager())
        ArtistAlbumsView(viewModel: viewModel, coordinatorDelegate: nil)
    }
}
