//
//  AuthResultModel.swift
//  GoogleAuthSwiftUI
//
//  Created by Satyam Sharma Chingari on 28/02/26.
//

import Foundation
import FirebaseAuth
struct AuthDataResultModel{
    let uuid: String
    let email: String?
    let photoURL: URL?
    init(user: User){
        self.uuid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL
    }
}
