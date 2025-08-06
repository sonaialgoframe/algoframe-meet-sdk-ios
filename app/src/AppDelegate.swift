import UIKit
import Firebase
import AlgoframeMeetSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let algoframeMeet = AlgoframeMeet.sharedInstance()

        // algoframeMeet.webRtcLoggingSeverity = .verbose

        algoframeMeet.conferenceActivityType = "org.algoframe.AlgoframeMeet.ios.conference" // Must match the one defined in Info.plist{}
        algoframeMeet.customUrlScheme = "org.algoframe.meet"
        algoframeMeet.universalLinkDomains = ["meet.jit.si", "alpha.algoframe.net", "beta.meet.jit.si"]

        algoframeMeet.defaultConferenceOptions = AlgoframeMeetConferenceOptions.fromBuilder { builder in
            // For testing configOverrides a room needs to be set
            // builder.room = "https://meet.jit.si/test0988test"

            builder.setFeatureFlag("welcomepage.enabled", withBoolean: true)
            builder.setFeatureFlag("ios.screensharing.enabled", withBoolean: true)
            builder.setFeatureFlag("ios.recording.enabled", withBoolean: true)
        }

        algoframeMeet.application(application, didFinishLaunchingWithOptions: launchOptions ?? [:])

        if self.appContainsRealServiceInfoPlist() {
            print("Enabling Firebase")
            FirebaseApp.configure()
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(!algoframeMeet.isCrashReportingDisabled())
        }

        let vc = ViewController()
        self.window?.rootViewController = vc
        algoframeMeet.showSplashScreen()

        self.window?.makeKeyAndVisible()

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("Application will terminate!")
        if let rootController = self.window?.rootViewController as? ViewController {
            rootController.terminate()
        }
    }

    // MARK: Linking delegate methods

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return AlgoframeMeet.sharedInstance().application(application, continue: userActivity, restorationHandler: restorationHandler)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if url.absoluteString.contains("google/link/?dismiss=1&is_weak_match=1") {
            return false
        }

        return AlgoframeMeet.sharedInstance().application(app, open: url, options: options)
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AlgoframeMeet.sharedInstance().application(application, supportedInterfaceOrientationsFor: window)
    }
}

// Firebase utilities
extension AppDelegate {
    func appContainsRealServiceInfoPlist() -> Bool {
        return InfoPlistUtil.containsRealServiceInfoPlist(in: Bundle.main)
    }
}
