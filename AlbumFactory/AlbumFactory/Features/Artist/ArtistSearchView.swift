import SwiftUI

protocol ArtistSearchViewDelegate: AnyObject {
    func artistSearchViewDidSelectArtist(artist: Artist)
}

struct ArtistSearchView: View {

    // MARK: - Properties
    // MARK: Mutable

    @ObservedObject private var viewModel: ArtistSearchViewModel
    private weak var coordinatorDelegate: ArtistSearchViewDelegate?

    // MARK: - Initializers

    init(viewModel: ArtistSearchViewModel, coordinatorDelegate: ArtistSearchViewDelegate?) {
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
                            coordinatorDelegate?.artistSearchViewDidSelectArtist(artist: artist)
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
        let viewModel = ArtistSearchViewModel(networkAPI: NetworkAPIMock())
        ArtistSearchView(viewModel: viewModel, coordinatorDelegate: nil)
    }
}
