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
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.albums, id: \.id) { album in
                        Text(album.name ?? "N/A")
                    }
                    .navigationTitle(viewModel.titleText)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}


struct BeerListView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
    }
}
