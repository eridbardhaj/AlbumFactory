import SwiftUI

protocol ArtistSearchContentViewDelegate: AnyObject {
    func artistSearchContentViewDidSelectArtist(artist: Artist)
}

struct ArtistSearchContentView: View {

    // MARK: - Properties
    // MARK: Mutable

    @ObservedObject private var viewModel: ArtistSearchContentViewModel
    private weak var coordinatorDelegate: ArtistSearchContentViewDelegate?

    // MARK: - Initializers

    init(viewModel: ArtistSearchContentViewModel, coordinatorDelegate: ArtistSearchContentViewDelegate?) {
        self.viewModel = viewModel
        self.coordinatorDelegate = coordinatorDelegate
    }

    // MARK: - View Configuration

    var body: some View {
        VStack {
            SearchBar(placeholder: "Search...", text: $viewModel.searchText)
                .navigationTitle("Search Artists")
            ScrollView {
                LazyVStack(spacing: Spacing.defaultVertical) {
                    ForEach(viewModel.artists) { artist in
                        HStack(spacing: Spacing.defaultHorizontal) {
                            AsyncImage(imageURLString: artist.imageUrl)
                                .frame(width: 60, height: 60)
                                .padding(.leading, Spacing.defaultHorizontal)
                            VStack(spacing: Spacing.defaultVertical) {
                                Text(artist.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(String("Plays: \(artist.listeners ?? "N/A")"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            Spacer()
                        }
                        .onTapGesture {
                            coordinatorDelegate?.artistSearchContentViewDidSelectArtist(artist: artist)
                        }
                    }
                }
            }

            Spacer()
        }
    }
}

struct ArtistSearchContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ArtistSearchContentViewModel(networkAPI: NetworkAPIMock())
        ArtistSearchContentView(viewModel: viewModel, coordinatorDelegate: nil)
    }
}
