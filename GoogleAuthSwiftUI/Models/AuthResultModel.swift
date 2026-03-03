
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
