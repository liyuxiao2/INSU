
import SwiftUI

public struct ProfileView: View {
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            Text("Profile Page")
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
    }
}
