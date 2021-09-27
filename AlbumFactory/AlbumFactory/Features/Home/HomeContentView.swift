import SwiftUI

struct HomeContentView: View {

    // MARK: - Properties
    // MARK: Mutable

    @ObservedObject private var viewModel: HomeContentViewModel

    // MARK: - Initializers

    init(viewModel: HomeContentViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View Configuration

    var body: some View {
        Group {
            CollectionView(items: $viewModel.albums) { album, _ in
                let viewModel = HomeContentItemViewModel(album: album)
                HomeContentItemView(viewModel: viewModel)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Albums")
        }
    }
}


struct HomeContentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
    }
}
