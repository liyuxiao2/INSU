//
//  HomeNavigationBar.swift
//  LoopUI
//
//  Created for Loop redesign - matches Figma bottom tab bar
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

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
            return "clock.fill"
        case .profile:
            return "person.fill"
        }
    }
}

public struct HomeNavigationBar: View {
    @Binding var selectedTab: HomeTab
    let onTabSelected: (HomeTab) -> Void

    public init(selectedTab: Binding<HomeTab>, onTabSelected: @escaping (HomeTab) -> Void) {
        self._selectedTab = selectedTab
        self.onTabSelected = onTabSelected
    }

    public var body: some View {
        ZStack {
            // Background rounded rectangle
            RoundedRectangle(cornerRadius: InsuSpacing.cardCornerRadius)
                .fill(Color.insuBlue)
                .frame(height: InsuSpacing.tabBarHeight)

            HStack(spacing: 0) {
                ForEach(HomeTab.allCases, id: \.self) { tab in
                    Button(action: {
                        selectedTab = tab
                        onTabSelected(tab)
                    }) {
                        ZStack {
                            if tab == .home {
                                // Home tab has special circular highlight
                                Circle()
                                    .fill(selectedTab == tab ? Color.insuDarkBlue : Color.clear)
                                    .frame(width: 46, height: 46)
                            }

                            Image(systemName: tab.icon)
                                .font(.system(size: 24))
                                .foregroundColor(
                                    tab == .home && selectedTab == tab ? .white :
                                    selectedTab == tab ? Color.insuDarkBlue : Color.insuDarkBlue.opacity(0.6)
                                )
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: InsuSpacing.tabBarHeight)
    }
}

// MARK: - Preview

struct HomeNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            HomeNavigationBar(
                selectedTab: .constant(.home),
                onTabSelected: { _ in }
            )
            .padding(.horizontal, 20)
        }
        .background(Color.white)
        .previewDisplayName("Figma Design Match")
    }
}
