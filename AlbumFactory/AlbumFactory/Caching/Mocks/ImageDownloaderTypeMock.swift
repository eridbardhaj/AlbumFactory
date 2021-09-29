import Foundation
import UIKit
import Combine
import Alamofire
import AlamofireImage

class ImageDownloaderTypeMock: ImageDownloaderType {

    // MARK: - Inner Types

    class CalledCount {
        var download = 0
    }

    class ReturnValue {
        var download: RequestReceipt? = nil
    }

    // MARK: - Properties
    // MARK: Immutable

    let calledCount = CalledCount()
    let returnValue = ReturnValue()

    // MARK: - Protocol Conformance
    // MARK: ImageDownloaderType

    func download(_ urlRequest: URLRequestConvertible, cacheKey: String?, receiptID: String, serializer: ImageResponseSerializer?, filter: ImageFilter?, progress: ImageDownloader.ProgressHandler?, progressQueue: DispatchQueue, completion: ImageDownloader.CompletionHandler?) -> RequestReceipt? {
        calledCount.download += 1
        return returnValue.download
    }
}

