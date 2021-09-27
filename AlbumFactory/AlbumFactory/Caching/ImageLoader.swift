import AlamofireImage
import SwiftUI
import Combine

class ImageLoader {

    // MARK: - Properties
    // MARK: Injected

    private let imageDownloader: ImageDownloader

    // MARK: - Initializers

    init(imageDownloader: ImageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .fifo,
        maximumActiveDownloads: 4,
        imageCache: AutoPurgingImageCache()
    )) {
        self.imageDownloader = imageDownloader
    }

    // MARK: - Actions

    func image(for url: URL) -> AnyPublisher<UIImage?, Never> {
        Future { [weak self] subscriber in
            let urlRequest = URLRequest(url: url)
            self?.imageDownloader.download(urlRequest, completion: { response in
                if case .success(let image) = response.result {
                    subscriber(.success(image))
                }
            })
        }
        .eraseToAnyPublisher()
    }

    func image(for urlString: String?) -> AnyPublisher<UIImage?, Never> {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return Just<UIImage?>(nil).eraseToAnyPublisher()
        }

        return image(for: url)
    }
}
