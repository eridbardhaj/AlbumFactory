import SwiftUI
import Combine

enum LikeContentViewState: Equatable {
    struct ItemContent: Equatable {
        let name: String
        let imageUrlString: String?
        let isLiked: Bool

        var systemIconName: String {
            isLiked ? "heart.fill" : "heart"
        }
    }

    case loading
    case dataLoaded(content: ItemContent)
}

class LikeContentViewModel: ObservableObject {
    @Published var viewState: LikeContentViewState

    init(viewState: LikeContentViewState) {
        self.viewState = viewState
    }
}

struct LikeContentView<ViewModel: LikeContentViewModel>: View {

    // MARK: - Properties
    // MARK: Immutable

    let likeAction: (() -> Void)?

    // MARK: Mutable

    @ObservedObject private var viewModel: ViewModel

    // MARK: - Initializers

    init(viewModel: ViewModel, likeAction: (() -> Void)? = nil) {
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
            case .dataLoaded(let content):
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
