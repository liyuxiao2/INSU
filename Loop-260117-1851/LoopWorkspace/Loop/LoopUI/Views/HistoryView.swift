
import SwiftUI

public struct HistoryView: View {
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            Text("History Page")
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
    }
}
