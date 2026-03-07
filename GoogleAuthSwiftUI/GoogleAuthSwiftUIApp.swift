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
    @StateObject private var authVM = AuthManager.shared
    func application(_ application:UIApplication,didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey:Any]? = nil) -> Bool{
        
        FirebaseApp.configure()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["LoginAgain"])
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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // Data ko Hex String mein badalna padta hai dekhne ke liye
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        print("🍎 Apple ka APNs Token ye hai: \(tokenString)")
        
        // Agar Firebase use kar rahe ho, toh ye step zaroori hota hai (agar swizzling off ho)
        Messaging.messaging().apnsToken = deviceToken
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
        
            completionHandler([.alert, .badge, .sound])
       
            
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let id = response.notification.request.identifier
        if id == "LoginAgain" {
                    print("🚀 Notification Tap Detect Hua!")
                    // Signal bhejo HomeView ko
                    NotificationCenter.default.post(name: NSNotification.Name("TriggerLogout"), object: nil)
                }
        if id == "BatteryLow"{
            
        }
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NotificationCenter.default.post(name:Notification.Name("userLoggedIn"),object: nil)

    
    }
    
    
   
    
    
    
    
    
    
    
    
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print("-> Remote notificatoins token is \(deviceToken.toHexString())")
//        pushNotificationService.didRegisterForRemoteNotifications(with: deviceToken)
//      }
//
//      func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        pushNotificationService.didFailToRegisterForRemoteNotifications(with: error)
//      }
  

//    NotificationCenter.default.addObserver(forName: Notification.Name("userLoggedIn"), object: nil, queue: .main){
//         _ in
//        print("user logged in")
//        
//    }
    }

class NotificationManager {
    static func scheduleLoginAgain() {
        let content = UNMutableNotificationContent()
        content.title = "Login Again"
        content.body = "Please Login Again"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let request = UNNotificationRequest(identifier: "LoginAgain", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    static func showBatteryNotification() {
        // 1. Force enable monitoring again
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        let level = Int(UIDevice.current.batteryLevel * 100)
        
        let content = UNMutableNotificationContent()
        content.title = "Notification Test Success! "
        content.body = "Current Battery: \(level)"
        content.sound = .default 
        
        // UUID use karo taaki har notification naya lage
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(" Notification Error: \(error.localizedDescription)")
            } else {
                print(" Notification Scheduled Successfully!")
            }
        }
    }
    static   func closeScheduleLoginAgain() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["LoginAgain"])
        
    }
}
