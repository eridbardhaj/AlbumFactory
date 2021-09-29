import SwiftUI

struct HomeItemView: View {

    // MARK: - Properties
    // MARK: Immutable

    let likeAction: (() -> Void)?

    // MARK: Mutable

    @ObservedObject private var viewModel: HomeItemViewModel

    // MARK: - Initializers

    init(viewModel: HomeItemViewModel, likeAction: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.likeAction = likeAction
    }

    // MARK: - View Configuration

    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                Text("Loading...")
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            case.dataLoaded(let content):
                AsyncImage(imageURLString: content.imageUrlString)
                VStack(alignment: .leading, spacing: Spacing.defaultVertical) {
                    Spacer()
                    HStack(alignment: .bottom) {
                        Text(content.name)
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(Spacing.defaultEdgeInsets)

                        Button(action: {
                            likeAction?()
                        }) {
                            Image(systemName: content.systemIconName)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.red)
                                .padding(Spacing.defaultEdgeInsets)
                        }
                    }.background(Color.black.opacity(0.6))
                }
            }
        }
    }
}


struct HomeItemView_Previews: PreviewProvider {
    static var previews: some View {
        let tracks = [
            Track(name: "Not Afraid", duration: 200, visitUrl: nil),
            Track(name: "Space Bound", duration: 192, visitUrl: nil),
        ]
        let artist = Artist(mbid: "123123123", name: "Eminem", listeners: "22210231", plays: "234234234", content: "Eminem is a very well known artist", imageUrl: "https://lastfm.freetls.fastly.net/i/u/174s/be7d9be5645e1a7d64f51579401e48c7.png")
        let album = Album(mbid: "123-123", name: "Recovery", artist: artist, plays: "111232", listeners: "200123", imageUrl: "https://lastfm.freetls.fastly.net/i/u/174s/be7d9be5645e1a7d64f51579401e48c7.png", tracks: tracks)
        let viewModel = HomeItemViewModel(album: album)
        HomeItemView(viewModel: viewModel)
    }
}
