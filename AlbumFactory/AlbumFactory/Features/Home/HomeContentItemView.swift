import SwiftUI

struct HomeContentItemView: View {

    // MARK: - Properties
    // MARK: Mutable

    @ObservedObject private var viewModel: HomeContentItemViewModel

    // MARK: - Initializers

    init(viewModel: HomeContentItemViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View Configuration

    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .loading:
                Rectangle()
                    .background(Color.black)
            case.dataLoaded(let content):
                AsyncImage(imageURLString: content.imageUrlString)
                Text(content.name)
            }
        }
    }
}


struct HomeContentItemView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
    }
}
