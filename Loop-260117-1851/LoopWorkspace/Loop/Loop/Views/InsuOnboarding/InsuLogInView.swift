//
//  InsuLogInView.swift
//  Loop
//
//  Created for INSU onboarding flow
//  Mock UI only - no actual authentication
//  Figma specs: Social buttons 72x72px, Welcome 40px, Input 297x46px
//

import SwiftUI

struct InsuLogInView: View {
    @State private var email = ""
    @State private var password = ""

    var onComplete: () -> Void
    var onSwitchToSignUp: () -> Void

    // Figma dimensions
    private let inputWidth: CGFloat = 297
    private let inputHeight: CGFloat = 46
    private let inputCornerRadius: CGFloat = 10
    private let socialButtonSize: CGFloat = 72
    private let horizontalPadding: CGFloat = 48

    var body: some View {
        VStack(spacing: 0) {
            // Tab selector header - Figma: 32px Semibold
            authTabSelector(isLoginSelected: true)

            ScrollView {
                VStack(spacing: 20) {
                    // Welcome header - Figma: 40px
                    welcomeHeader
                        .padding(.top, 48)

                    // Email field - Figma: 297x46px
                    inputField(
                        title: "Email",
                        placeholder: "Enter your email",
                        text: $email,
                        isSecure: false
                    )
                    .padding(.top, 16)

                    // Password field - Figma: 297x46px
                    inputField(
                        title: "Password",
                        placeholder: "Enter your password",
                        text: $password,
                        isSecure: true
                    )

                    // Social login buttons - Figma: 72x72px circles
                    socialLoginButtons
                        .padding(.top, 24)

                    // Log In button - Figma: 297x46px, shadow
                    primaryButton(title: "Log In", action: onComplete)
                        .padding(.top, 24)

                    // Divider
                    orDivider

                    // Google sign in
                    googleSignInButton

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
    private func authTabSelector(isLoginSelected: Bool) -> some View {
        HStack(spacing: 0) {
            Button(action: onSwitchToSignUp) {
                Text("Sign Up")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.insuGray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }

            Button(action: {}) {
                Text("Log In")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
        }
        .background(Color.white)
    }

    // Figma: Welcome 40px Semibold black
    private var welcomeHeader: some View {
        VStack(spacing: 8) {
            Text("Welcome Back.")
                .font(.system(size: 40, weight: .semibold))
                .foregroundColor(.black)

            Text("Sign in to view your data and stay on track.")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
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

    // Figma: Social buttons 72x72px circles
    private var socialLoginButtons: some View {
        HStack(spacing: 20) {
            socialButton(systemName: "f.square.fill", color: .blue)
            socialButton(systemName: "globe", color: .red)
            socialButton(systemName: "apple.logo", color: .black)
        }
    }

    // Figma: 72x72px circles with shadow
    private func socialButton(systemName: String, color: Color) -> some View {
        Button(action: onComplete) {
            Image(systemName: systemName)
                .font(.system(size: 32))
                .foregroundColor(color)
                .frame(width: socialButtonSize, height: socialButtonSize)
                .background(Color.white)
                .cornerRadius(socialButtonSize / 2)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        }
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

    private var googleSignInButton: some View {
        Button(action: onComplete) {
            HStack(spacing: 12) {
                Image(systemName: "globe")
                    .font(.system(size: 20))
                Text("Sign in with Google")
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
struct InsuLogInView_Previews: PreviewProvider {
    static var previews: some View {
        InsuLogInView(
            onComplete: {},
            onSwitchToSignUp: {}
        )
    }
}
#endif
