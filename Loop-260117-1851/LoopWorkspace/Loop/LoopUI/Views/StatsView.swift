//
//  StatsView.swift
//  LoopUI
//
//  Created for Loop redesign - Stats page
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

public struct StatsView: View {
    @ObservedObject var viewModel: StatsViewModel

    public init(viewModel: StatsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Header section - matches Home page header positioning
                    StatsHeaderView(userName: viewModel.userName)

                    // Glucose chart card
                    GlucoseChartCard(viewModel: viewModel)

                    // Glucose summary card
                    GlucoseSummaryCard(viewModel: viewModel)

                    // Time in Range card
                    TimeInRangeCard(viewModel: viewModel)
                }
                .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
                .padding(.top, 60) // Account for safe area (status bar/dynamic island)
                .padding(.bottom, InsuSpacing.tabBarHeight + 20)
            }
        }
    }
}

// MARK: - Preview

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(viewModel: StatsViewModel(isPumpConnected: false))
    }
}
