import UIKit
import SwiftUI

import ShoplDesignGuide

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let appView = AppView()
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = UIHostingController(rootView: appView)
    self.window = window
    window.makeKeyAndVisible()
    
    FontLoader.registerFonts()
    DSViewConfig.configure()
    
    return true
  }
}
