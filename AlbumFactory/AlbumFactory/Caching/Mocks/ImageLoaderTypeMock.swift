import Foundation
import UIKit
import Combine

class ImageLoaderTypeMock: ImageLoaderType {

    // MARK: - Inner Types

    class CalledCount {
        var imageForURL = 0
        var imageForURLString = 0
    }

    class ReturnValue {
        var imageForURL: AnyPublisher<UIImage?, Never> = Empty(completeImmediately: false).eraseToAnyPublisher()

        var imageForURLString: AnyPublisher<UIImage?, Never> = Empty(completeImmediately: false).eraseToAnyPublisher()

    }

    // MARK: - Properties
    // MARK: Immutable

    let calledCount = CalledCount()
    let returnValue = ReturnValue()

    // MARK: - Protocol Conformance
    // MARK: ImageLoaderType

    func image(for url: URL) -> AnyPublisher<UIImage?, Never> {
        calledCount.imageForURL += 1
        return returnValue.imageForURL
    }

    func image(for urlString: String?) -> AnyPublisher<UIImage?, Never> {
        calledCount.imageForURLString += 1
        return returnValue.imageForURLString
    }
}

