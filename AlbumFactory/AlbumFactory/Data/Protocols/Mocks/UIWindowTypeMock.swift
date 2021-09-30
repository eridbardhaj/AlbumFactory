import Foundation
import UIKit
import Combine

class UIWindowTypeMock: UIWindowType {

    // MARK: - Inner Types

    class CalledCount {
        var makeKeyAndVisible = 0
    }

    // MARK: - Properties
    // MARK: Immutable

    let calledCount = CalledCount()

    // MARK: - Protocol Conformance
    // MARK: UIWindowType

    var rootViewController: UIViewController?

    func makeKeyAndVisible() {
        calledCount.makeKeyAndVisible += 1
    }
}
