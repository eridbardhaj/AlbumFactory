import UIKit

public protocol UIApplicationType: AnyObject {
    var delegate: UIApplicationDelegate? { get }
    var keyWindow: UIWindow? { get }
}

extension UIApplication: UIApplicationType {}
