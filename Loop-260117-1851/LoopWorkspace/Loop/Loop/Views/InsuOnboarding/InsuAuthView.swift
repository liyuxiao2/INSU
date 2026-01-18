//
//  InsuAuthView.swift
//  Loop
//
//  Combined Sign Up / Log In view with sliding tab indicator
//  Mock UI only - no actual authentication
//

import SwiftUI

struct InsuAuthView: View {
    @State private var selectedTab: AuthTab = .signUp
    @State private var email = ""
    @State private var password = ""
    @State private var agreedToTerms = false

    var onComplete: () -> Void

    enum AuthTab {
        case signUp
        case logIn
    }

    // Figma dimensions
    private let inputWidth: CGFloat = 297
    private let inputHeight: CGFloat = 46
    private let inputCornerRadius: CGFloat = 10
    private let profileSize: CGFloat = 150
    private let horizontalPadding: CGFloat = 48

    var body: some View {
        VStack(spacing: 0) {
            // Tab selector with sliding underline
            tabSelector

            ScrollView {
                if selectedTab == .signUp {
                    signUpContent
                } else {
                    logInContent
                }
            }
        }
        .background(Color.white)
    }

    // MARK: - Tab Selector with Sliding Underline

    private var tabSelector: some View {
        VStack(spacing: 0) {
            // Tab buttons
            HStack(spacing: 0) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = .signUp
                    }
                }) {
                    Text("Sign Up")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(selectedTab == .signUp ? .black : .insuGray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = .logIn
                    }
                }) {
                    Text("Log In")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(selectedTab == .logIn ? .black : .insuGray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            }

            // Sliding underline
            GeometryReader { geometry in
                let tabWidth = geometry.size.width / 2
                let underlineWidth: CGFloat = 124

                Rectangle()
                    .fill(Color.black)
                    .frame(width: underlineWidth, height: 2)
                    .offset(x: selectedTab == .signUp
                        ? (tabWidth - underlineWidth) / 2
                        : tabWidth + (tabWidth - underlineWidth) / 2)
                    .animation(.easeInOut(duration: 0.3), value: selectedTab)
            }
            .frame(height: 2)
        }
        .background(Color.white)
    }

    // MARK: - Sign Up Content

    private var signUpContent: some View {
        VStack(spacing: 20) {
            // Profile photo placeholder
            profilePhotoButton
                .padding(.top, 32)

            // Email field
            inputField(
                title: "Email",
                placeholder: "Enter your email",
                text: $email,
                isSecure: false
            )

            // Password field
            inputField(
                title: "Password",
                placeholder: "Enter your password",
                text: $password,
                isSecure: true
            )

            // Terms checkbox
            termsCheckbox
                .padding(.top, 8)

            // Sign Up button
            primaryButton(title: "Sign Up", action: onComplete)
                .padding(.top, 16)

            // Divider
            orDivider

            // Google sign up
            googleButton(text: "Sign up with Google")

            Spacer()
                .frame(height: 40)
        }
        .padding(.horizontal, horizontalPadding)
    }

    // MARK: - Log In Content

    private var logInContent: some View {
        VStack(spacing: 20) {
            // Welcome header
            welcomeHeader
                .padding(.top, 48)

            // Email field
            inputField(
                title: "Email",
                placeholder: "Enter your email",
                text: $email,
                isSecure: false
            )
            .padding(.top, 16)

            // Password field
            inputField(
                title: "Password",
                placeholder: "Enter your password",
                text: $password,
                isSecure: true
            )

            // Forgot password
            HStack {
                Spacer()
                Text("Forgot password?")
                    .font(.system(size: 10))
                    .foregroundColor(.black)
            }
            .frame(width: inputWidth)

            // Log In button
            primaryButton(title: "Log In", action: onComplete)
                .padding(.top, 24)

            // Or divider
            orDivider

            // Google sign in
            googleButton(text: "Sign in with Google")

            Spacer()
                .frame(height: 40)
        }
        .padding(.horizontal, horizontalPadding)
    }

    // MARK: - Shared Components

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
                    .foregroundColor(.black)
            }

            (Text("I agree to all the ")
                .foregroundColor(.black) +
            Text("Terms & Conditions")
                .foregroundColor(.black)
                .fontWeight(.bold))

            Spacer()
        }
        .font(.system(size: 13))
        .frame(width: inputWidth)
    }

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
                .font(.system(size: 14))
                .foregroundColor(.black)
                .padding(.horizontal, 16)

            Rectangle()
                .fill(Color.insuInactiveGray)
                .frame(height: 1)
        }
        .frame(width: inputWidth)
        .padding(.vertical, 16)
    }

    private func googleButton(text: String) -> some View {
        Button(action: onComplete) {
            HStack(spacing: 12) {
                Image(systemName: "globe")
                    .font(.system(size: 20))
                (Text(text.replacingOccurrences(of: "Google", with: ""))
                    .font(.system(size: 14)) +
                Text("Google")
                    .font(.system(size: 14, weight: .bold)))
            }
            .foregroundColor(.black)
            .frame(width: inputWidth, height: inputHeight)
            .background(Color.white)
            .cornerRadius(inputCornerRadius)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct InsuAuthView_Previews: PreviewProvider {
    static var previews: some View {
        InsuAuthView(onComplete: {})
    }
}
#endif
