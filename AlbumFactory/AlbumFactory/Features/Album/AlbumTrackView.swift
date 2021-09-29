import SwiftUI

struct AlbumTrackView: View {

    // MARK: - Properties
    // MARK: Mutable

    @ObservedObject private var viewModel: AlbumTrackViewModel

    // MARK: - Initializers

    init(viewModel: AlbumTrackViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View Configuration

    var body: some View {
        Group {
            switch viewModel.viewState {
            case .empty:
                Text("")
            case .data(let content):
                VStack {
                    HStack(spacing: 0) {
                        Text(content.name)
                        Spacer()
                        Text(content.duration)
                    }
                }
                .padding(Spacing.defaultEdgeInsets)
            }
        }
    }
}

struct AlbumTrackView_Previews: PreviewProvider {
    static var previews: some View {
        let tracks = [
            Track(name: "Not Afraid", duration: 200, visitUrl: nil),
            Track(name: "Space Bound", duration: 192, visitUrl: nil),
        ]
        let artist = Artist(mbid: "123123123", name: "Eminem", listeners: "22210231", plays: "234234234", content: "Eminem is a very well known artist", imageUrl: "https://lastfm.freetls.fastly.net/i/u/174s/be7d9be5645e1a7d64f51579401e48c7.png")
        let album = Album(mbid: "123-123", name: "Recovery", artist: artist, plays: "111232", listeners: "200123", imageUrl: "https://lastfm.freetls.fastly.net/i/u/174s/be7d9be5645e1a7d64f51579401e48c7.png", tracks: tracks)
        
        let viewModel = AlbumDetailsViewModel(
            album: album,
            storeManager: StoreManagerTypeMock(),
            networkKit: NetworkKitTypeMock()
        )
        AlbumDetailsView(viewModel: viewModel)
    }
}
