import UIKit

public protocol UIWindowType: AnyObject {
    var rootViewController: UIViewController? { get set }
    func makeKeyAndVisible()
}

extension UIWindow: UIWindowType {}
