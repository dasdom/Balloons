//  Created by Dominik Hauser on 14.12.24.
//  
//



enum PositionCalculator {
    static let numberOfShownDays: CGFloat = 50

    static func balloonX(for daysLeft: Int, canvasWidth: CGFloat) -> CGFloat {
        return xValue(for: CGFloat(daysLeft), canvasWidth: canvasWidth)
    }

    static func labelX(for displayMonth: CodableDisplayMonth, canvasWidth: CGFloat) -> CGFloat {
        return xValue(for: CGFloat(displayMonth.start + displayMonth.end)/2, canvasWidth: canvasWidth)
    }

    static func lineX(for displayMonth: CodableDisplayMonth, canvasWidth: CGFloat) -> CGFloat {
        return xValue(for: CGFloat(displayMonth.start), canvasWidth: canvasWidth)
    }

    static func xValue(for days: CGFloat, canvasWidth: CGFloat) -> CGFloat {
        return canvasWidth * days / numberOfShownDays
    }
}