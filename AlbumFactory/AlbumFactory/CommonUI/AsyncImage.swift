import SwiftUI

struct AsyncImage: View {

    // MARK: - Properties
    // MARK: Immutable

    private let imageLoader = ImageLoader()
    private let imageURLString: String?
    private let placeholder = UIImage(named: "album_loading_placeholder")

    // MARK: State

    @State private var image: UIImage?

    // MARK: - Initializers

    init(imageURLString: String?) {
        self.imageURLString = imageURLString
    }

    // MARK: - View Configuration

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
            } else {
                Image(uiImage: placeholder!)
            }
        }
        .onReceive(imageLoader.image(for: imageURLString), perform: { image = $0 })
    }
}
