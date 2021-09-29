import SwiftUI

struct ArtistAlbumsContentItemView: View {

    // MARK: - Properties
    // MARK: Mutable

    @ObservedObject private var viewModel: ArtistAlbumsContentItemViewModel

    // MARK: - Initializers

    init(viewModel: ArtistAlbumsContentItemViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View Configuration

    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                ProgressView("Loading")
            case.dataLoaded(let content):
                AsyncImage(imageURLString: content.imageUrlString)
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                    Text(content.name)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.black.opacity(0.4))
                }
                Image(systemName: content.systemIconName)
            }
        }
    }
}


struct ArtistAlbumsContentItemView_Previews: PreviewProvider {
    static var previews: some View {
        let tracks = [
            Track(name: "Not Afraid", duration: 200, visitUrl: nil),
            Track(name: "Space Bound", duration: 192, visitUrl: nil),
        ]
        let album = Album(mbid: "123-123", name: "Recovery", plays: "111232", listeners: "200123", visitUrl: nil, imageUrl: "https://lastfm.freetls.fastly.net/i/u/174s/be7d9be5645e1a7d64f51579401e48c7.png", tracks: tracks)
        let viewModel = HomeContentItemViewModel(album: album)
        HomeContentItemView(viewModel: viewModel)
    }
}
