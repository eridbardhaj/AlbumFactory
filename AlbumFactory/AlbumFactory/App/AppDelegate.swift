import UIKit

@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {

    // MARK: - Properties
    // MARK: Immutable

    private let dependencyResolver = DependencyResolver.self

    // MARK: Mutable

    var window: AppWindow?
    var appCoordinator: AppCoordinator!

    // MARK: - Protocol Conformance
    // MARK: UIApplicationDelegate

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(
            window: window,
            application: dependencyResolver.application,
            networkAPI: dependencyResolver.networkAPI
        )
        appCoordinator.start()

        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        appCoordinator.supportedOrientations
    }
}