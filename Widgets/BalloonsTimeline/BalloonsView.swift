//  Created by Dominik Hauser on 04.08.25.
//  
//


import SwiftUI


struct BalloonsView: View {
    let birthdays: [CodableBirthday]

    var body: some View {
        let balloonWidth: CGFloat = 30
        GeometryReader { proxy in
            var minY: CGFloat = 20
            var maxY: CGFloat = 75
            ForEach(birthdays, id: \.self) { birthday in
                let y = CGFloat.random(in: minY..<maxY)
                let x = PositionCalculator.balloonX(for: birthday.daysLeft, canvasWidth: proxy.size.width)

                if y < 50 {
                    minY = y+15
                    maxY = 75
                } else {
                    minY = 20
                    maxY = max(y, 75)
                }
                let _ = print("\(x), \(y)")

                return VStack {
                    SingleBalloonView(balloonWidth: balloonWidth, birthday: birthday)
                        .position(x: x, y: y)

                    Path { path in
                        path.move(to: CGPoint(x: x, y: y - proxy.size.height/2 + balloonWidth/2 + 10))
                        path.addLine(to: CGPoint(x: x, y: proxy.size.height/2-15))
                    }
                    .stroke(.secondary, lineWidth: 1)
                }
            }

            BalloonsTimelineView(size: proxy.size)
        }
    }
}
