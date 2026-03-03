import Foundation
import Combine
import FirebaseAuth
import Firebase
import GoogleSignIn
import GoogleSignInSwift
import Combine

class AuthManager: ObservableObject {
    static let shared = AuthManager ()
    @Published var user: User?


    init(){
        Auth.auth().addStateDidChangeListener { _, user in
                  
                    DispatchQueue.main.async {
                        self.user = user
                    }
                }
    }
    
    func signInWithGoogle(tokens: GoogleModel)  async throws -> AuthDataResultModel {
        let credential = try await GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return   try await signInWithCredential(credential: credential)
        
    }
    
    func signInWithCredential(credential : AuthCredential) async throws  -> AuthDataResultModel {
        let users = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user : users.user)

    }
     
    func signOut() throws {
        try Auth.auth().signOut()
    }
  
   

    
    
}
