//
//  HomeCardContainer.swift
//  LoopUI
//
//  Created for Loop redesign - Main home page matching Figma design
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

public struct HomeCardContainer: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var currentPage = 0

    let onInputBolus: () -> Void

    public init(viewModel: HomeViewModel, onInputBolus: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onInputBolus = onInputBolus
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Header: Greeting and notification bell
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Hello, \(viewModel.userName)")
                        .font(InsuTypography.greeting)
                        .foregroundColor(Color.insuTextPrimary)

                    HStack(spacing: 0) {
                        Text("View your ")
                            .font(InsuTypography.subtitle)
                            .foregroundColor(Color.insuTextPrimary)
                        Text("Dashboard")
                            .font(InsuTypography.subtitleBold)
                            .foregroundColor(Color.insuTextPrimary)
                    }
                }

                Spacer()

                Button(action: {}) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 26))
                        .foregroundColor(Color.insuTextPrimary)
                }
            }
            .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
            .padding(.top, 16)

            // Main glucose card with page indicator
            VStack(spacing: 12) {
                TabView(selection: $currentPage) {
                    // Page 0: Dashboard (Glucose)
                    DashboardCardView(
                        glucoseValue: viewModel.glucoseValue,
                        glucoseUnit: viewModel.glucoseUnit,
                        iobValue: viewModel.iobValue,
                        iobUnit: viewModel.iobUnit,
                        trendArrow: viewModel.trendArrow,
                        isStale: viewModel.isGlucoseStale
                    )
                    .tag(0)

                    // Page 1: Pod Status
                    PodStatusCardView(
                        reservoirLevel: viewModel.reservoirLevel,
                        reservoirUnit: viewModel.reservoirUnit,
                        iobValue: viewModel.iobValue,
                        iobUnit: viewModel.iobUnit,
                        onViewDetails: {}
                    )
                    .tag(1)

                    // Page 2: Insulin Mode
                    InsulinModeCardView(
                        modeName: viewModel.modeName,
                        iobValue: viewModel.iobValue,
                        iobUnit: viewModel.iobUnit,
                        isAutomated: viewModel.isAutomatedMode,
                        onChangeMode: {}
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: InsuSpacing.mainCardHeight)

                // Custom page indicator
                HStack(spacing: 5) {
                    ForEach(0..<3) { index in
                        RoundedRectangle(cornerRadius: 5)
                            .fill(currentPage == index ? Color.insuDarkBlue : Color.gray.opacity(0.4))
                            .frame(width: currentPage == index ? 50 : 23, height: 11)
                    }
                }
            }
            .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
            .padding(.top, 20)

            // Two small cards side by side
            HStack(spacing: 13) {
                // Left card: Last Bolus
                LastBolusCardView(
                    bolusValue: viewModel.lastBolusValue,
                    bolusUnit: viewModel.lastBolusUnit,
                    dateString: viewModel.lastBolusDate
                )
                .frame(maxWidth: .infinity)
                .frame(height: InsuSpacing.smallCardHeight)

                // Right card: Placeholder (empty blue card)
                RoundedRectangle(cornerRadius: InsuSpacing.cardCornerRadius)
                    .fill(Color.insuBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: InsuSpacing.smallCardHeight)
            }
            .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
            .padding(.top, 20)

            Spacer()

            // Input Bolus button
            Button(action: onInputBolus) {
                Text("Input Bolus")
            }
            .buttonStyle(InsuPrimaryButtonStyle())
            .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
            .padding(.bottom, 20)
        }
    }
}

// MARK: - Preview

struct HomeCardContainer_Previews: PreviewProvider {
    static var previews: some View {
        HomeCardContainer(
            viewModel: HomeViewModel(
                userName: "Arian",
                glucoseValue: 7.00,
                glucoseUnit: "mmol/L",
                trendArrow: "↗",
                isGlucoseStale: false,
                iobValue: 2.05,
                iobUnit: "U",
                reservoirLevel: 40,
                reservoirUnit: "U",
                modeName: "Automated",
                isAutomatedMode: true
            ),
            onInputBolus: {}
        )
        .previewDisplayName("Figma Home Page")
    }
}
