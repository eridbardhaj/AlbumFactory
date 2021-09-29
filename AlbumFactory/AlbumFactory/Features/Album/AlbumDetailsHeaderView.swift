import SwiftUI

struct AlbumDetailsHeaderView: View {

    private let name: String
    private let systemIconName: String
    private let imageURLString: String?
    private let likeAction: (() -> Void)?

    init(name: String, systemIconName: String, imageURLString: String?, likeAction: (() -> Void)?) {
        self.name = name
        self.systemIconName = systemIconName
        self.imageURLString = imageURLString
        self.likeAction = likeAction
    }

    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: Spacing.defaultVertical) {
                Group {
                    AsyncImage(imageURLString: imageURLString)
                }
                HStack(alignment: .bottom) {
                    Text(name)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(Spacing.defaultEdgeInsets)

                    Button(action: {
                        likeAction?()
                    }) {
                        Image(systemName: systemIconName)
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
