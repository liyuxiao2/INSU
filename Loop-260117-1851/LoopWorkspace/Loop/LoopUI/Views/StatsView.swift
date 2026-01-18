
import SwiftUI

public struct StatsView: View {
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            Text("Stats Page")
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
    }
}
