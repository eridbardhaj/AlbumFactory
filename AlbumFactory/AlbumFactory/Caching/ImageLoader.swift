import AlamofireImage
import Alamofire
import SwiftUI
import Combine

protocol ImageLoaderType {
    func image(for url: URL) -> AnyPublisher<UIImage?, Never>
    func image(for urlString: String?) -> AnyPublisher<UIImage?, Never>
}

protocol ImageDownloaderType {
    func download(_ urlRequest: URLRequestConvertible,
                  cacheKey: String?,
                  receiptID: String,
                  serializer: ImageResponseSerializer?,
                  filter: ImageFilter?,
                  progress: ImageDownloader.ProgressHandler?,
                  progressQueue: DispatchQueue,
                  completion: ImageDownloader.CompletionHandler?)
    -> RequestReceipt?
}

extension ImageDownloader: ImageDownloaderType {}


class ImageLoader: ImageLoaderType {

    // MARK: - Properties
    // MARK: Injected

    private let imageDownloader: ImageDownloaderType

    // MARK: - Initializers

    init(imageDownloader: ImageDownloaderType = ImageDownloader(
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
            _ = self?.imageDownloader.download(urlRequest, cacheKey: nil, receiptID: UUID().uuidString, serializer: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, completion: { response in
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
