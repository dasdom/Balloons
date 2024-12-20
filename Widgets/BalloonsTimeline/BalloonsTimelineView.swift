//  Created by Dominik Hauser on 14.12.24.
//  
//

import SwiftUI

struct BalloonsTimelineView: View {
    let size: CGSize
    var displayMonths: [CodableDisplayMonth] {
        DDHDateHelper.displayMonthsUseVeryShort(false).map({ CodableDisplayMonth(name: $0.name, start: $0.start, end: $0.end) })
    }

    var body: some View {
        ForEach(displayMonths, id: \.self) { displayMonth in
            Rectangle()
//                .fill(Color.white)
                .frame(width: 1, height: 14)
                .position(x: PositionCalculator.lineX(for: displayMonth, canvasWidth: size.width),
                          y: size.height - 3)
        }

        ForEach(displayMonths, id: \.start) { displayMonth in
            Text(displayMonth.name)
                .position(x: PositionCalculator.labelX(for: displayMonth, canvasWidth: size.width), y: size.height)
        }

        Rectangle()
//            .fill(Color.green)
            .frame(width: size.width + 40, height: 2)
            .position(x: size.width/2 + 20, y: size.height-10)

        /// Next 14 days
        Rectangle()
            .fill(Color(uiColor: .systemOrange))
            .frame(width: PositionCalculator.xValue(for: 14, canvasWidth: size.width), height: 2)
            .position(x: PositionCalculator.xValue(for: 7, canvasWidth: size.width), y: size.height-10)

        /// Next 7 days
        Rectangle()
            .fill(Color(uiColor: .systemRed))
            .frame(width: PositionCalculator.xValue(for: 7, canvasWidth: size.width), height: 2)
            .position(x: PositionCalculator.xValue(for: 3.5, canvasWidth: size.width), y: size.height-10)

        /// Marker for today
        Rectangle()
            .fill(Color(uiColor: .systemRed))
            .frame(width: 2, height: 8)
            .position(x: 0, y: size.height-13)
    }
}
