import UIKit

public protocol AppApplication: AnyObject {
    var delegate: UIApplicationDelegate? { get }
    var keyWindow: UIWindow? { get }
}

extension UIApplication: AppApplication {}
