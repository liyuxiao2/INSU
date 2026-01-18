//
//  InsuOnboardingCoordinator.swift
//  Loop
//
//  Created for INSU onboarding flow
//

import SwiftUI
import UIKit

/// Manages the INSU onboarding flow navigation
/// Runs before the existing therapy settings onboarding
class InsuOnboardingCoordinator: UINavigationController {

    // MARK: - Properties

    private var completionHandler: (() -> Void)?

    // MARK: - Initialization

    init(completion: @escaping () -> Void) {
        self.completionHandler = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide navigation bar for onboarding
        navigationBar.isHidden = true

        // Start with splash screen
        showSplash()
    }

    // MARK: - Navigation Methods

    private func showSplash() {
        let splashView = InsuSplashView { [weak self] in
            self?.navigateToCarousel()
        }
        let hostingController = UIHostingController(rootView: splashView)
        hostingController.view.backgroundColor = .clear
        setViewControllers([hostingController], animated: false)
    }

    private func navigateToCarousel() {
        let carouselView = InsuCarouselView(
            onGetStarted: { [weak self] in
                self?.navigateToAuth()
            },
            onLoginTapped: { [weak self] in
                self?.navigateToAuth()
            }
        )
        let hostingController = UIHostingController(rootView: carouselView)
        hostingController.view.backgroundColor = .clear

        // Fade transition
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .fade
        view.layer.add(transition, forKey: kCATransition)

        setViewControllers([hostingController], animated: false)
    }

    private func navigateToAuth() {
        let authView = InsuAuthView(
            onComplete: { [weak self] in
                self?.completeOnboarding()
            }
        )
        let hostingController = UIHostingController(rootView: authView)
        pushViewController(hostingController, animated: true)
    }

    // MARK: - Completion

    private func completeOnboarding() {
        // Mark INSU onboarding as complete in UserDefaults
        UserDefaults.standard.hasCompletedInsuOnboarding = true

        // Notify completion to proceed to therapy onboarding
        completionHandler?()
    }
}

// MARK: - Static Helper

extension InsuOnboardingCoordinator {
    /// Check if INSU onboarding has been completed
    static var isComplete: Bool {
        return UserDefaults.standard.hasCompletedInsuOnboarding
    }

    /// Reset onboarding state (for testing)
    static func resetOnboardingState() {
        UserDefaults.standard.hasCompletedInsuOnboarding = false
    }
}
