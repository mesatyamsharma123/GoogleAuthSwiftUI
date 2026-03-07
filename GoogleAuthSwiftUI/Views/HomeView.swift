import Foundation
import SwiftUI

struct HomeView: View {
    @State private var isOpenHamburger: Bool = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
@State var showNotificationScreen = false
    @StateObject var viewModel = AuthViewModel()
    var body: some View {
        ZStack {
            Image("logo")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(edges: .all)
            
            VStack {
              Image(systemName: "house.fill")
                    .font(.system(size: 100))
                Text("Home View")
                    .foregroundStyle(.black)
            }
        
            if isOpenHamburger {
                ZStack {
                   
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { isOpenHamburger.toggle()}
                        }

                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Menu")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.top, 100)
                        
                        Button("Profile") {}
                            .foregroundStyle(.white)
                        
                        Button("Settings") { }
                            .foregroundStyle(.white)
                        Button("Logout") {
                            Task{
                                do{
                                    try await viewModel.signOut()
                                    isLoggedIn = false
                                }catch {
                                    
                                }
                            } 
                            
                        }
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.brown)
                    .ignoresSafeArea()
                    .transition(.move(edge: .leading))
                }
            }
                }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    isOpenHamburger.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal")
                }
                .accessibilityLabel("Open menu")
            }
        }
        .navigationDestination(isPresented: $showNotificationScreen) {
                        NotificationView()
                    }
                    
        .onAppear {
                   
            NotificationManager.scheduleLoginAgain()
            UIDevice.current.isBatteryMonitoringEnabled = true
                }
        
        .onDisappear{
            
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("TriggerLogout"))) { _ in
                    print("📥 Signal Received: Logging out now...")
                   showNotificationScreen = true
                }
//        .onReceive(NotificationCenter.default.publisher(for: UIDevice.batteryLevelDidChangeNotification)) { _ in
//           
//            NotificationManager.showBatteryNotification()
//        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.protectedDataDidBecomeAvailableNotification)) { _ in
            print("🔓 Phone Unlock hua!")
            NotificationManager.showBatteryNotification()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification)) { _ in
            print("📸 Screenshot liya gaya!")
            NotificationManager.showBatteryNotification() 
        }
      
    }
    
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
