import Foundation
import UIKit
import Combine

class NetworkAgentTypeMock: NetworkAgentType {

    // MARK: - Inner Types

    class CalledCount {
        var run = 0
    }

    class ReturnValue {
        var run: AnyPublisher<Response<ArtistInfoResponse>, Error> = Empty(completeImmediately: false).eraseToAnyPublisher()
    }

    // MARK: - Properties
    // MARK: Immutable

    let calledCount = CalledCount()
    let returnValue = ReturnValue()

    // MARK: - Protocol Conformance
    // MARK: ImageLoaderType

    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
        calledCount.run += 1
        return response()
    }

    func response<T: Decodable>() -> AnyPublisher<Response<T>, Error> {
        returnValue.run.compactMap { $0 as? Response<T> }
        .eraseToAnyPublisher()
    }
}

