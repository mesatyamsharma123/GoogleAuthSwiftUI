import SwiftUI
import GoogleSignInSwift

struct ContentView: View {
    
    @StateObject var viewModel = AuthViewModel()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
          
        }
        .padding()
    }
}

#Preview {
    ContentView()
        
}
