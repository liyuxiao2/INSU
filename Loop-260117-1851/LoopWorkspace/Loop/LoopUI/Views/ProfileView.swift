import SwiftUI
import UIKit

public struct ProfileView: View {
    @State private var isPersonalDetailsExpanded = false
    @State private var isFAQsExpanded = false

    // Device status
    let isPumpSetUp: Bool
    let pumpName: String
    let pumpImage: UIImage?
    let isCGMSetUp: Bool
    let cgmName: String
    let cgmImage: UIImage?

    // Actions
    let onAddPump: () -> Void
    let onAddCGM: () -> Void
    let onPumpTapped: () -> Void
    let onCGMTapped: () -> Void

    public init(
        isPumpSetUp: Bool = false,
        pumpName: String = "",
        pumpImage: UIImage? = nil,
        isCGMSetUp: Bool = false,
        cgmName: String = "",
        cgmImage: UIImage? = nil,
        onAddPump: @escaping () -> Void = {},
        onAddCGM: @escaping () -> Void = {},
        onPumpTapped: @escaping () -> Void = {},
        onCGMTapped: @escaping () -> Void = {}
    ) {
        self.isPumpSetUp = isPumpSetUp
        self.pumpName = pumpName
        self.pumpImage = pumpImage
        self.isCGMSetUp = isCGMSetUp
        self.cgmName = cgmName
        self.cgmImage = cgmImage
        self.onAddPump = onAddPump
        self.onAddCGM = onAddCGM
        self.onPumpTapped = onPumpTapped
        self.onCGMTapped = onCGMTapped
    }

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

                // Pump and CGM rows
                VStack(spacing: 12) {
                    // Pump row
                    if isPumpSetUp {
                        deviceRow(
                            image: pumpImage,
                            title: pumpName,
                            subtitle: "Insulin Pump",
                            showArrow: true,
                            action: onPumpTapped
                        )
                    } else {
                        deviceSetupRow(icon: "plus", title: "Add Pump", subtitle: "Tap here to set up a pump", action: onAddPump)
                    }

                    // CGM row
                    if isCGMSetUp {
                        deviceRow(
                            image: cgmImage,
                            title: cgmName,
                            subtitle: "Continuous Glucose Monitor",
                            showArrow: true,
                            action: onCGMTapped
                        )
                    } else {
                        deviceSetupRow(icon: "plus", title: "Add CGM", subtitle: "Tap here to set up a CGM", action: onAddCGM)
                    }
                }
                .padding(.top, 10)

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

    private func deviceSetupRow(icon: String, title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Plus icon in rounded rectangle
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.insuDarkBlue)
                    .frame(width: 56, height: 56)
                    .background(Color.insuBlue)
                    .cornerRadius(12)

                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)

                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }

    private func deviceRow(image: UIImage?, title: String, subtitle: String, showArrow: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Device image
                if let uiImage = image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 56, height: 56)
                        .background(Color.insuBlue)
                        .cornerRadius(12)
                } else {
                    Image(systemName: "sensor.tag.radiowaves.forward")
                        .font(.system(size: 24))
                        .foregroundColor(.insuDarkBlue)
                        .frame(width: 56, height: 56)
                        .background(Color.insuBlue)
                        .cornerRadius(12)
                }

                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)

                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }

                Spacer()

                if showArrow {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}
