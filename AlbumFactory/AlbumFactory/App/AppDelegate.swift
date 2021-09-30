import UIKit

@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {

    // MARK: - Properties
    // MARK: Immutable

    private let dependencyResolver = DependencyResolver.self

    // MARK: Mutable

    var window: UIWindowType?
    var appCoordinator: AppCoordinator!

    // MARK: - Protocol Conformance
    // MARK: UIApplicationDelegate

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        setupGlobals()

        #if TEST
        #else
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(
            window: window,
            networkKit: dependencyResolver.networkKit,
            storeManager: dependencyResolver.storeManager
        )
        appCoordinator.start()
        #endif

        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        appCoordinator.supportedOrientations
    }

    // MARK: - Setups

    private func setupGlobals() {
        RealmMigrator.setDefaultConfiguration()
    }
}
