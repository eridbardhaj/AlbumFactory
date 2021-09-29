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
            switch viewModel.viewState {
            case .empty(let text):
                EmptyContentView(text: text) {
                    viewModel.start()
                }
            case .data(let content):
                SearchBar(placeholder: "Search...", text: $viewModel.searchText)
                    .navigationTitle("Search Artists")
                ScrollView {
                    LazyVStack(spacing: Spacing.defaultVertical) {
                        ForEach(content.itemViewModels) { itemViewModel in
                            ArtistSearchItemView(viewModel: itemViewModel)
                            .onTapGesture {
                                coordinatorDelegate?.artistSearchViewDidSelectArtist(artist: itemViewModel.artist)
                            }
                        }
                    }
                }

                Spacer()
            }
        }
    }
}

struct ArtistSearchContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ArtistSearchViewModel(networkAPI: NetworkAPIMock())
        ArtistSearchView(viewModel: viewModel, coordinatorDelegate: nil)
    }
}
