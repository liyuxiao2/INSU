//
//  GlucoseChartCard.swift
//  LoopUI
//
//  Created for Loop redesign - Stats page glucose chart
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

public struct GlucoseChartCard: View {
    @ObservedObject var viewModel: StatsViewModel

    public init(viewModel: StatsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            // Outer blue card
            RoundedRectangle(cornerRadius: InsuSpacing.cardCornerRadius)
                .fill(Color.insuBlue)

            VStack(spacing: 0) {
                // Time range selector
                TimeRangeSelector(
                    options: viewModel.hourRangeOptions,
                    selected: viewModel.selectedHourRange,
                    suffix: "Hours",
                    onSelect: { viewModel.updateHourRange($0) }
                )
                .padding(.horizontal, 12)
                .padding(.top, 12)

                // Chart area
                GlucoseLineChart(
                    data: viewModel.glucoseData,
                    targetLow: viewModel.targetRangeLow,
                    targetHigh: viewModel.targetRangeHigh,
                    selectedPoint: $viewModel.selectedDataPoint,
                    hourRange: viewModel.selectedHourRange
                )
                .padding(.horizontal, 8)
                .padding(.bottom, 12)
            }
            .background(Color.white)
            .cornerRadius(InsuSpacing.innerCardCornerRadius)
            .padding(7)
        }
        .frame(height: 280)
    }
}

// MARK: - Time Range Selector

struct TimeRangeSelector: View {
    let options: [Int]
    let selected: Int
    let suffix: String
    let onSelect: (Int) -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: InsuSpacing.innerCardCornerRadius)
                .fill(Color.insuBlue.opacity(0.3))

            HStack(spacing: 0) {
                ForEach(options, id: \.self) { option in
                    Button(action: { onSelect(option) }) {
                        Text(option == options.last ? "\(option) \(suffix)" : "\(option)")
                            .font(.system(size: 14, weight: selected == option ? .bold : .regular))
                            .foregroundColor(Color.insuTextPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                selected == option ?
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    : nil
                            )
                    }
                }
            }
            .padding(4)
        }
        .frame(height: 40)
    }
}

// MARK: - Glucose Line Chart

struct GlucoseLineChart: View {
    let data: [GlucoseDataPoint]
    let targetLow: Double
    let targetHigh: Double
    @Binding var selectedPoint: GlucoseDataPoint?
    let hourRange: Int

    // Chart bounds
    private let minY: Double = 2.0
    private let maxY: Double = 22.0

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height - 30 // Leave room for x-axis labels

            ZStack(alignment: .topLeading) {
                // Target range band (yellow)
                let lowY = yPosition(for: targetLow, in: height)
                let highY = yPosition(for: targetHigh, in: height)

                Rectangle()
                    .fill(Color.yellow.opacity(0.4))
                    .frame(height: lowY - highY)
                    .offset(y: highY)

                // Y-axis labels (right side)
                VStack {
                    Text(String(format: "%.1f", maxY))
                        .font(.system(size: 10))
                        .foregroundColor(Color.insuGray)
                    Spacer()
                    Text(String(format: "%.1f", targetHigh))
                        .font(.system(size: 10))
                        .foregroundColor(Color.insuGray)
                    Spacer()
                    Text(String(format: "%.1f", targetLow))
                        .font(.system(size: 10))
                        .foregroundColor(Color.insuGray)
                    Spacer()
                    Text(String(format: "%.1f", minY))
                        .font(.system(size: 10))
                        .foregroundColor(Color.insuGray)
                }
                .frame(width: 35, height: height)
                .offset(x: width - 35)

                // Line chart
                if data.count > 1 {
                    Path { path in
                        let chartWidth = width - 45
                        for (index, point) in data.enumerated() {
                            let x = CGFloat(index) / CGFloat(data.count - 1) * chartWidth
                            let y = yPosition(for: point.value, in: height)

                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(Color.insuDarkBlue, lineWidth: 2)

                    // Data points
                    ForEach(Array(data.enumerated()), id: \.element.id) { index, point in
                        let chartWidth = width - 45
                        let x = CGFloat(index) / CGFloat(data.count - 1) * chartWidth
                        let y = yPosition(for: point.value, in: height)

                        Circle()
                            .fill(Color.insuDarkBlue)
                            .frame(width: 8, height: 8)
                            .position(x: x, y: y)
                    }
                }

                // Selected point indicator
                if let selected = selectedPoint,
                   let index = data.firstIndex(where: { $0.id == selected.id }) {
                    let chartWidth = width - 45
                    let x = CGFloat(index) / CGFloat(data.count - 1) * chartWidth
                    let y = yPosition(for: selected.value, in: height)

                    // Vertical line
                    Rectangle()
                        .fill(Color.insuDarkBlue.opacity(0.5))
                        .frame(width: 1, height: height)
                        .position(x: x, y: height / 2)

                    // Value tooltip
                    VStack(spacing: 2) {
                        Text(String(format: "%.1f", selected.value))
                            .font(.system(size: 12, weight: .bold))
                        Text(formatTime(selected.date))
                            .font(.system(size: 10))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.insuDarkBlue)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                    .position(x: min(max(x, 40), chartWidth - 40), y: max(y - 30, 25))

                    // Highlighted point
                    Circle()
                        .fill(Color.white)
                        .frame(width: 12, height: 12)
                        .overlay(Circle().stroke(Color.insuDarkBlue, lineWidth: 3))
                        .position(x: x, y: y)
                }

                // X-axis labels
                HStack {
                    Text(xAxisStartLabel)
                        .font(.system(size: 12))
                        .foregroundColor(Color.insuGray)
                    Spacer()
                    Text(xAxisMidLabel)
                        .font(.system(size: 12))
                        .foregroundColor(Color.insuGray)
                    Spacer()
                    Text("Now")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color.insuTextPrimary)
                }
                .padding(.horizontal, 4)
                .offset(y: height + 8)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let chartWidth = geometry.size.width - 45
                        let x = value.location.x
                        let index = Int((x / chartWidth) * CGFloat(data.count - 1))
                        if index >= 0 && index < data.count {
                            selectedPoint = data[index]
                        }
                    }
                    .onEnded { _ in
                        // Keep selection visible for a moment
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            selectedPoint = nil
                        }
                    }
            )
        }
    }

    private func yPosition(for value: Double, in height: CGFloat) -> CGFloat {
        let normalizedValue = (value - minY) / (maxY - minY)
        return height * (1 - CGFloat(normalizedValue))
    }

    private var xAxisStartLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        let hoursAgo = Calendar.current.date(byAdding: .hour, value: -hourRange, to: Date())!
        return formatter.string(from: hoursAgo).uppercased()
    }

    private var xAxisMidLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        let hoursAgo = Calendar.current.date(byAdding: .hour, value: -hourRange / 2, to: Date())!
        return formatter.string(from: hoursAgo).uppercased()
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

// MARK: - Preview

struct GlucoseChartCard_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = StatsViewModel(isPumpConnected: false)
        GlucoseChartCard(viewModel: viewModel)
            .padding(.horizontal, 20)
            .previewLayout(.sizeThatFits)
    }
}
