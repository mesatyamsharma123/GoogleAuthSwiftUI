
import Foundation
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

struct LandingView : View {
    
//    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State var showSignInPopup = false
    @StateObject var viewModel = AuthViewModel()
   
    var body: some View {
        
        ZStack{
            Image("buddy")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
       
            VStack (spacing:20){
                Spacer()
                Spacer()
                
                Button{
                    showSignInPopup = true
                    
                }
                label:{
                    Text("Get Started")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                    
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.brown.opacity(1))
              
                Text("Already have an account?")
                    .foregroundColor(.black)
                    .onTapGesture {
                        print("account")
                        withAnimation{
                            showSignInPopup = true
                        }
                        
                    }
                Text("By continuing, you agree to our Terms of Service and Privacy Policy")
                    .font(.system(size: 12))
                        .frame(width: 220)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                Spacer()
              
                
            }
            if showSignInPopup {
                ZStack {
                    Color.black.opacity(0.5).ignoresSafeArea()
                        .onTapGesture {
                            showSignInPopup.toggle()
                        }
                    VStack(spacing: 20){
                        GoogleSignInButton(scheme: .dark, style: .standard, state: .normal){
                            
                            Task{
                                do{
                                   try await viewModel.signIn()
//                                    isLoggedIn = true
                                    
                                    
                                }catch{
                                    
                                }
                            }
                           
                        }
                        SignInWithAppleButton(
                            .signIn,
                            onRequest: { _ in },
                            onCompletion: { _ in }
                        )
                        .frame(height: 45)
                        .tint(Color.white)
                      
                    }
                    .frame(width: 250)
                    .padding(40)
                    .background(.white.opacity(0.3))
                    .cornerRadius(10)
                    .foregroundStyle(Color.white)
                    .multilineTextAlignment(.center)
                    
                
                }
            }
        }
    }
}

#Preview {
    LandingView()
}
