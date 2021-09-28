import UIKit

public protocol AppWindow: AnyObject {
    var rootViewController: UIViewController? { get set }
    func makeKeyAndVisible()
    var screen: UIScreen { get }
    var bounds: CGRect { get }
}

extension UIWindow: AppWindow {}
