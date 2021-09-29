import SwiftUI

struct ArtistSearchItemView: View {

    // MARK: - Properties
    // MARK: Mutable

    @ObservedObject private var viewModel: ArtistSearchItemViewModel

    // MARK: - Initializers

    init(viewModel: ArtistSearchItemViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View Configuration

    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .empty:
                Text("")
            case .data(let content):
                HStack(spacing: Spacing.defaultHorizontal) {
                    AsyncImage(imageURLString: content.imageUrlString)
                        .frame(width: 60, height: 60)
                        .padding(.leading, Spacing.defaultHorizontal)
                    VStack(spacing: Spacing.defaultVertical) {
                        Text(content.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(content.plays)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct ArtistSearchItemView_Previews: PreviewProvider {
    static var previews: some View {
        let artist = Artist(mbid: "123123123", name: "Eminem", listeners: "22210231", plays: "234234234", content: "Eminem is a very well known artist", imageUrl: "https://lastfm.freetls.fastly.net/i/u/174s/be7d9be5645e1a7d64f51579401e48c7.png")
        let viewModel = ArtistSearchItemViewModel(artist: artist)
        ArtistSearchItemView(viewModel: viewModel)
    }
}
