import SwiftUI

struct HomeContentItemView: View {

    // MARK: - Properties
    // MARK: Immutable

    let likeAction: (() -> Void)?

    // MARK: Mutable

    @ObservedObject private var viewModel: HomeContentItemViewModel

    // MARK: - Initializers

    init(viewModel: HomeContentItemViewModel, likeAction: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.likeAction = likeAction
    }

    // MARK: - View Configuration

    var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .loading:
                ProgressView("Loading")
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
                            print("Tapped Action")
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


struct HomeContentItemView_Previews: PreviewProvider {
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
