import UIKit

public protocol UIWindowType: AnyObject {
    var rootViewController: UIViewController? { get set }
    func makeKeyAndVisible()
    var screen: UIScreen { get }
    var bounds: CGRect { get }
}

extension UIWindow: UIWindowType {}
