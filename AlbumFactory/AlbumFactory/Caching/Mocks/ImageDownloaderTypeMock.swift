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
        var downloadResult: Result<Image, AFIError>!
    }

    // MARK: - Properties
    // MARK: Immutable

    let calledCount = CalledCount()
    let returnValue = ReturnValue()

    // MARK: - Protocol Conformance
    // MARK: ImageDownloaderType

    func download(_ urlRequest: URLRequestConvertible, cacheKey: String?, receiptID: String, serializer: ImageResponseSerializer?, filter: ImageFilter?, progress: ImageDownloader.ProgressHandler?, progressQueue: DispatchQueue, completion: ImageDownloader.CompletionHandler?) -> RequestReceipt? {
        calledCount.download += 1
        completion?(
            AFIDataResponse<Image>(
                request: nil,
                response: nil,
                data: nil,
                metrics: nil,
                serializationDuration: 1234,
                result: returnValue.downloadResult
            )
        )
        return nil
    }
}

