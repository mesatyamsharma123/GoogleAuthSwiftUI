import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications
@main
struct GoogleAuthSwiftUIApp: App {
    
   
    @StateObject private var authVM = AuthManager.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            if authVM.user != nil {
                NavigationStack{
                    HomeView()
                }
            }
            else{
                LandingView()
            }
        }
        
    }
}

final class AppDelegate: NSObject , UIApplicationDelegate ,MessagingDelegate, UNUserNotificationCenterDelegate {
    func application(_ application:UIApplication,didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey:Any]? = nil) -> Bool{
        
        FirebaseApp.configure()
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
                
                if !hasLaunchedBefore {
               
                    try? Auth.auth().signOut()
                    
                
                    UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                }
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
         
            
            guard let error = error else { return }
            print("Error requesting notification authorization: \(error)")
        }
                
     
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
                return
            }
            if let token = token {
                print("FCM registration token: \(token)")
            }
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
            completionHandler([.banner, .badge, .sound])
       
            
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //Handle data here

    
    }
    
}
