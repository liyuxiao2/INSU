import SwiftUI

public struct ProfileView: View {
    @State private var isPersonalDetailsExpanded = false
    @State private var isFAQsExpanded = false

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Photo and Name
                VStack(spacing: 16) {
                    ZStack(alignment: .bottomTrailing) {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 150, height: 150)
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))

                        // Plus icon
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.black)
                            .clipShape(Circle())
                            .offset(x: 5, y: 5)
                    }

                    Text("Arian Emamjomeh")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                }
                .padding(.top, 60) // Account for safe area
                
                // Expandable Sections
                VStack(spacing: 20) {
                    expandableButton(title: "Personal Details", isExpanded: $isPersonalDetailsExpanded) {
                        // Content for Personal Details would go here
                        Text("Name: Arian Emamjomeh\nAge: 18\nType: 1")
                            .font(InsuTypography.subtitle)
                            .padding()
                    }
                    
                    expandableButton(title: "FAQs", isExpanded: $isFAQsExpanded) {
                        // Content for FAQs
                        Text("No FAQs currently available.")
                            .font(InsuTypography.subtitle)
                            .padding()
                    }
                }
                
                Spacer(minLength: 40)
                
                // Help Button
                Button(action: {
                    // Help action
                }) {
                    Text("Help")
                }
                .buttonStyle(InsuPrimaryButtonStyle())
                
                Spacer(minLength: InsuSpacing.tabBarHeight + 20) // Bottom padding for nav bar
            }
            .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
    
    private func expandableButton<Content: View>(title: String, isExpanded: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation {
                    isExpanded.wrappedValue.toggle()
                }
            }) {
                HStack {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image(systemName: "arrowtriangle.down.fill")
                        .rotationEffect(.degrees(isExpanded.wrappedValue ? 180 : 0))
                        .foregroundColor(.insuDarkBlue)
                }
                .padding()
                .background(Color.insuBlue)
                .cornerRadius(15) // Rounded corners for the header
            }
            
            if isExpanded.wrappedValue {
                content()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.insuBlue.opacity(0.3))
                    .cornerRadius(15)
                    .padding(.top, 5) // Slight separation if desired, or 0 for attached look
            }
        }
    }
}

