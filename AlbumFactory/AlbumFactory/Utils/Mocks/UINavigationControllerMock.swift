import UIKit

class UINavigationControllerMock: UINavigationController {


    // MARK: - Inner Types

    struct CalledCount: Equatable {
        var setViewControllers = 0
        var pushViewController = 0
        var popViewController = 0
        var popToRootViewController = 0
        var present = 0
        var dismiss = 0
    }

    struct ReturnValue: Equatable {
        var popViewController: UIViewController?
        var popToRootViewController: [UIViewController]?
    }

    struct Parameter: Equatable {
        var pushedViewController: UIViewController?
        var setViewControllers: [UIViewController]?
        var presentedViewController: UIViewController?
    }


    // MARK: - Properties
    // MARK: Mutable

    var calledCount = CalledCount()
    var returnValue = ReturnValue()
    var parameter = Parameter()


    // MARK: - Overrides

    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        calledCount.setViewControllers += 1
        parameter.setViewControllers = viewControllers
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        calledCount.pushViewController += 1
        parameter.pushedViewController = viewController
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        calledCount.popViewController += 1
        return returnValue.popViewController
    }

    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        calledCount.popToRootViewController += 1
        return returnValue.popToRootViewController
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        calledCount.present += 1
        parameter.presentedViewController = viewControllerToPresent
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        calledCount.dismiss += 1
        completion?()
    }
}
