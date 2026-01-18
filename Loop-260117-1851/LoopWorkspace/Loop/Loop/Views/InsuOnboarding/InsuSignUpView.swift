//
//  InsuSignUpView.swift
//  Loop
//
//  Created for INSU onboarding flow
//  Mock UI only - no actual authentication
//  Figma specs: Input 297x46px, Profile 150x150px, Tab 32px Semibold
//

import SwiftUI

struct InsuSignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var agreedToTerms = false

    var onComplete: () -> Void
    var onSwitchToLogin: () -> Void

    // Figma dimensions
    private let inputWidth: CGFloat = 297
    private let inputHeight: CGFloat = 46
    private let inputCornerRadius: CGFloat = 10
    private let profileSize: CGFloat = 150
    private let horizontalPadding: CGFloat = 48

    var body: some View {
        VStack(spacing: 0) {
            // Tab selector header
            authTabSelector(isSignUpSelected: true)

            ScrollView {
                VStack(spacing: 20) {
                    // Profile photo placeholder - Figma: 150x150px
                    profilePhotoButton
                        .padding(.top, 32)

                    // Email field - Figma: 297x46px
                    inputField(
                        title: "Email",
                        placeholder: "Enter your email",
                        text: $email,
                        isSecure: false
                    )

                    // Password field - Figma: 297x46px
                    inputField(
                        title: "Password",
                        placeholder: "Enter your password",
                        text: $password,
                        isSecure: true
                    )

                    // Terms checkbox
                    termsCheckbox
                        .padding(.top, 8)

                    // Sign Up button - Figma: 297x46px, shadow
                    primaryButton(title: "Sign Up", action: onComplete)
                        .padding(.top, 16)

                    // Divider
                    orDivider

                    // Google sign up
                    googleSignUpButton

                    Spacer()
                        .frame(height: 40)
                }
                .padding(.horizontal, horizontalPadding)
            }
        }
        .background(Color.white)
    }

    // MARK: - Subviews

    // Figma: Tab headers 32px Semibold, active=black, inactive=#696969
    private func authTabSelector(isSignUpSelected: Bool) -> some View {
        HStack(spacing: 0) {
            Button(action: {}) {
                Text("Sign Up")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }

            Button(action: onSwitchToLogin) {
                Text("Log In")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.insuGray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
        }
        .background(Color.white)
    }

    // Figma: Profile circle 150x150px
    private var profilePhotoButton: some View {
        VStack(spacing: 8) {
            Button(action: {
                // Mock - no actual image picker
            }) {
                ZStack {
                    Circle()
                        .fill(Color.insuInactiveGray)
                        .frame(width: profileSize, height: profileSize)

                    Image(systemName: "camera.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.insuGray)
                }
            }

            Text("Add Profile Photo")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.insuGray)
        }
    }

    // Figma: Input 297x46px, 10px radius, shadow, 20px label
    private func inputField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(.black)

            if isSecure {
                SecureField(placeholder, text: text)
                    .font(.system(size: 16))
                    .padding(.horizontal, 16)
                    .frame(width: inputWidth, height: inputHeight)
                    .background(Color.white)
                    .cornerRadius(inputCornerRadius)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            } else {
                TextField(placeholder, text: text)
                    .font(.system(size: 16))
                    .padding(.horizontal, 16)
                    .frame(width: inputWidth, height: inputHeight)
                    .background(Color.white)
                    .cornerRadius(inputCornerRadius)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            }
        }
    }

    private var termsCheckbox: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: { agreedToTerms.toggle() }) {
                Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                    .font(.system(size: 20))
                    .foregroundColor(.insuPrimaryBlue)
            }

            Text("I agree to all the ")
                .foregroundColor(.insuGray) +
            Text("Terms & Conditions")
                .foregroundColor(.insuPrimaryBlue)
                .fontWeight(.medium)

            Spacer()
        }
        .font(.system(size: 15))
    }

    // Figma: Button 297x46px, 10px radius, #a4c8e1, shadow
    private func primaryButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
                .frame(width: inputWidth, height: inputHeight)
                .background(Color.insuLightBlue)
                .cornerRadius(inputCornerRadius)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        }
    }

    private var orDivider: some View {
        HStack {
            Rectangle()
                .fill(Color.insuInactiveGray)
                .frame(height: 1)

            Text("or")
                .font(.system(size: 15))
                .foregroundColor(.insuGray)
                .padding(.horizontal, 16)

            Rectangle()
                .fill(Color.insuInactiveGray)
                .frame(height: 1)
        }
        .frame(width: inputWidth)
        .padding(.vertical, 16)
    }

    private var googleSignUpButton: some View {
        Button(action: onComplete) {
            HStack(spacing: 12) {
                Image(systemName: "globe")
                    .font(.system(size: 20))
                Text("Sign up with Google")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.insuGray)
            .frame(width: inputWidth, height: inputHeight)
            .background(Color.white)
            .cornerRadius(inputCornerRadius)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct InsuSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        InsuSignUpView(
            onComplete: {},
            onSwitchToLogin: {}
        )
    }
}
#endif
