import SwiftUI

struct AlbumDetailsView: View {

    // MARK: - Properties
    // MARK: Mutable

    @ObservedObject private var viewModel: AlbumDetailsViewModel

    // MARK: - Initializers

    init(viewModel: AlbumDetailsViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View Configuration

    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                LoadingView()
            case .diskData(let content):
                mainView(for: content)
            case .networkData(let content):
                mainView(for: content)
            }
        }
    }

    func mainView(for content: AlbumDetailsViewModel.ViewState.AlbumDetailsContent) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.defaultVertical) {
                AlbumDetailsHeaderView(
                    name: content.name,
                    systemIconName: content.systemIconName,
                    imageURLString: content.imageUrlString) {
                        viewModel.tappedLikeButton()
                    }

                Text(content.artistName)
                    .font(.title2)
                    .padding(Spacing.defaultEdgeInsets)
                Text(content.name)
                    .font(.title2)
                    .bold()
                    .padding(Spacing.defaultEdgeInsets)

                ForEach(content.trackViewModels) { trackViewModel in
                    AlbumTrackView(viewModel: trackViewModel)
                }

                Text(content.info)
            }
        }
    }
}

struct AlbumDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let tracks = [
            Track(name: "Not Afraid", duration: 200, visitUrl: nil),
            Track(name: "Space Bound", duration: 192, visitUrl: nil),
        ]
        let artist = Artist(mbid: "123123123", name: "Eminem", listeners: "22210231", plays: "234234234", content: "Eminem is a very well known artist", imageUrl: "https://lastfm.freetls.fastly.net/i/u/174s/be7d9be5645e1a7d64f51579401e48c7.png")
        let album = Album(mbid: "123-123", name: "Recovery", artist: artist, plays: "111232", listeners: "200123", imageUrl: "https://lastfm.freetls.fastly.net/i/u/174s/be7d9be5645e1a7d64f51579401e48c7.png", tracks: tracks)
        let viewModel = AlbumDetailsViewModel(album: album,storeManager: DependencyResolver.storeManager, networkAPI: NetworkAPIMock())
        AlbumDetailsView(viewModel: viewModel)
    }
}
