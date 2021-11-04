import SwiftUI

typealias ArtistAlbumsItemView = LikeContentView<ArtistAlbumsItemViewModel>

struct ArtistAlbumsItemView_Previews: PreviewProvider {
    static var previews: some View {
        let tracks = [
            Track(name: "Not Afraid", duration: 200, visitUrl: nil),
            Track(name: "Space Bound", duration: 192, visitUrl: nil),
        ]
        let artist = Artist(mbid: "123123123", name: "Eminem", listeners: "22210231", plays: "234234234", content: "Eminem is a very well known artist", imageUrl: "https://lastfm.freetls.fastly.net/i/u/174s/be7d9be5645e1a7d64f51579401e48c7.png")
        let album = Album(mbid: "123-123", name: "Recovery", artist: artist, plays: "111232", listeners: "200123", imageUrl: "https://lastfm.freetls.fastly.net/i/u/174s/be7d9be5645e1a7d64f51579401e48c7.png", tracks: tracks)
        let viewModel = ArtistAlbumsItemViewModel(album: album, storeManager: StoreManagerTypeMock())
        ArtistAlbumsItemView(viewModel: viewModel)
    }
}
