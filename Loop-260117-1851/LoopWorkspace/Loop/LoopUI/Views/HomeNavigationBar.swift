//
//  HomeNavigationBar.swift
//  LoopUI
//
//  Created for Loop redesign - animated bottom tab bar with floating indicator
//  Copyright © 2026. All rights reserved.
//

import SwiftUI
import Combine

// MARK: - Tab Selection State (Observable for UIKit-SwiftUI bridge)

public class TabSelectionState: ObservableObject {
    @Published public var selectedTab: HomeTab = .home

    public init(initialTab: HomeTab = .home) {
        self.selectedTab = initialTab
    }
}

// MARK: - Tab Definition

public enum HomeTab: Int, CaseIterable {
    case home = 0
    case stats = 1
    case history = 2
    case profile = 3

    public var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .stats:
            return "chart.bar.fill"
        case .history:
            return "person.fill"
        case .profile:
            return "gearshape.fill"
        }
    }
}

// MARK: - Dip Cover Shape (White overlay with cosine wave bottom)

/// A white shape that overlays the navbar to create the dip effect.
/// Has a flat top and left/right edges, with a cosine-wave curved bottom.
struct DipCoverShape: Shape {
    var dipCenterX: CGFloat
    let dipWidth: CGFloat = 120  // Width of the dip curve (wider)
    let dipDepth: CGFloat = 40   // How deep the dip goes (deeper)

    var animatableData: CGFloat {
        get { dipCenterX }
        set { dipCenterX = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Start from top-left
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))

        // Top edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))

        // Right edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

        // Bottom edge with cosine wave dip
        // We draw from right to left, with a smooth dip centered at dipCenterX
        let steps = 100
        for i in 0...steps {
            let x = rect.maxX - (CGFloat(i) / CGFloat(steps)) * rect.width

            // Calculate distance from dip center (normalized)
            let distanceFromCenter = abs(x - dipCenterX)
            let normalizedDistance = min(distanceFromCenter / (dipWidth / 2), 1.0)

            // Cosine curve: 1 at center, 0 at edges of dip
            let cosValue = normalizedDistance < 1.0 ? (1 + cos(normalizedDistance * .pi)) / 2 : 0
            let y = rect.maxY + cosValue * dipDepth

            if i == 0 {
                path.addLine(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        // Left edge back to start
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))

        path.closeSubpath()
        return path
    }
}

// MARK: - Home Navigation Bar

public struct HomeNavigationBar: View {
    @ObservedObject var tabState: TabSelectionState
    let onTabSelected: (HomeTab) -> Void

    // Animation configuration
    private let animationDuration: Double = 0.35
    private let circleSize: CGFloat = 46  // Smaller circle
    private let dipOverlayHeight: CGFloat = 32  // Height of white overlay area
    private let barHeight: CGFloat = 72  // Extends to bottom
    private let iconAreaHeight: CGFloat = 50  // Where icons are centered (doesn't change with bar height)
    private let cornerRadius: CGFloat = 18

    public init(tabState: TabSelectionState, onTabSelected: @escaping (HomeTab) -> Void) {
        self.tabState = tabState
        self.onTabSelected = onTabSelected
    }

    /// Calculate the X center position for a tab
    private func tabCenterX(for tab: HomeTab, in width: CGFloat, horizontalPadding: CGFloat) -> CGFloat {
        let usableWidth = width - (horizontalPadding * 2)
        let tabCount = CGFloat(HomeTab.allCases.count)
        let tabWidth = usableWidth / tabCount
        return horizontalPadding + tabWidth * CGFloat(tab.rawValue) + tabWidth / 2
    }

    public var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let horizontalPadding: CGFloat = 20
            let selectedX = tabCenterX(for: tabState.selectedTab, in: width, horizontalPadding: horizontalPadding)
            let totalHeight = barHeight + dipOverlayHeight

            // Calculate Y positions (icons stay fixed, don't move with bar height changes)
            let circleY = dipOverlayHeight + 4  // Circle center Y (moved up 4px)
            let unselectedIconY = dipOverlayHeight + iconAreaHeight / 2  // Fixed position for unselected icons

            ZStack(alignment: .top) {
                // Layer 1: Light blue navbar background (at bottom)
                Rectangle()
                    .fill(Color.insuBlue)
                    .frame(height: barHeight)
                    .frame(maxHeight: .infinity, alignment: .bottom)

                // Layer 2: White dip overlay - baseline at top of navbar, dip curves down into it
                DipCoverShape(dipCenterX: selectedX)
                    .fill(Color.white)
                    .frame(width: width, height: dipOverlayHeight)

                // Layer 3: Dark blue accent circle (sits in the dip)
                Circle()
                    .fill(Color.insuDarkBlue)
                    .frame(width: circleSize, height: circleSize)
                    .shadow(color: Color.insuDarkBlue.opacity(0.25), radius: 6, x: 0, y: 3)
                    .position(x: selectedX, y: circleY)

                // Layer 4: Icons - each positioned independently
                HStack(spacing: 0) {
                    ForEach(HomeTab.allCases, id: \.self) { tab in
                        let isSelected = tab == tabState.selectedTab

                        Button(action: {
                            withAnimation(.easeInOut(duration: animationDuration)) {
                                tabState.selectedTab = tab
                            }
                            onTabSelected(tab)
                        }) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(isSelected ? .white : Color.insuDarkBlue.opacity(0.85))
                        }
                        .frame(maxWidth: .infinity)
                        .offset(y: isSelected ? circleY - 12 : unselectedIconY - 12)
                    }
                }
                .padding(.horizontal, horizontalPadding)
            }
            .frame(height: totalHeight)
        }
        .frame(height: barHeight + dipOverlayHeight)
    }
}

// MARK: - Preview

struct HomeNavigationBar_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @StateObject private var tabState = TabSelectionState()

        var body: some View {
            ZStack {
                Color.white.ignoresSafeArea()

                VStack {
                    Spacer()

                    Text("Selected: \(tabState.selectedTab.icon)")
                        .font(.headline)
                        .padding()

                    Spacer()

                    HomeNavigationBar(
                        tabState: tabState,
                        onTabSelected: { _ in }
                    )
                    .padding(.horizontal, 16)
                }
            }
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .previewDisplayName("Animated Tab Bar")
    }
}
