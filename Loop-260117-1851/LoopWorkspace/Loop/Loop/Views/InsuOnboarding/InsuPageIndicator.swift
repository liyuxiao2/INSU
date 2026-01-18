//
//  InsuPageIndicator.swift
//  Loop
//
//  Created for INSU onboarding flow
//  Dimensions from Figma: Active 50x11px, Inactive 23x11px, 10px radius
//

import SwiftUI

struct InsuPageIndicator: View {
    let numberOfPages: Int
    let currentPage: Int

    // Figma dimensions
    private let activeWidth: CGFloat = 50
    private let inactiveWidth: CGFloat = 23
    private let height: CGFloat = 11
    private let cornerRadius: CGFloat = 10
    private let spacing: CGFloat = 2

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(index == currentPage ? Color.insuPrimaryBlue : Color.insuInactiveGray)
                    .frame(
                        width: index == currentPage ? activeWidth : inactiveWidth,
                        height: height
                    )
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct InsuPageIndicator_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            InsuPageIndicator(numberOfPages: 3, currentPage: 0)
            InsuPageIndicator(numberOfPages: 3, currentPage: 1)
            InsuPageIndicator(numberOfPages: 3, currentPage: 2)
        }
        .padding()
        .background(Color.white)
        .previewLayout(.sizeThatFits)
    }
}
#endif
