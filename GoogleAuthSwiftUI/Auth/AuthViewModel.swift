//
//  AuthViewModel.swift
//  GoogleAuthSwiftUI
//
//  Created by Satyam Sharma Chingari on 28/02/26.
//

import Foundation
import Combine
import GoogleSignIn
import GoogleSignInSwift

class AuthViewModel: ObservableObject {
    
    
    func signIn() async throws  {
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        let gidSignIn = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        guard let idtoken: String  = gidSignIn.user.idToken?.tokenString else {
            return
            
        }
        
        let accessToken: String  = gidSignIn.user.accessToken.tokenString
        let token = GoogleModel(idToken: idtoken, accessToken: accessToken)
         
        try await AuthManager.shared.signInWithGoogle(tokens: token)
        
        
        
    }
}
