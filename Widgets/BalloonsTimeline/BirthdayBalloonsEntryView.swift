//  Created by Dominik Hauser on 27.11.24.
//  
//

import SwiftUI

struct BirthdayBalloonsEntryView : View {
    var entry: Provider.Entry
    var nameFormatter: PersonNameComponentsFormatter = {
        let formatter = PersonNameComponentsFormatter()
        formatter.style = .abbreviated
        return formatter
    }()
    var birthdays: [CodableBirthday] {
        entry.birthdays.map({ .init(birthday: $0) }).sorted {
            $0.daysLeft > $1.daysLeft
        }
    }

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
                    VStack(spacing: 0) {
                        if let imageData = birthday.imageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage.resized(with: CGSize(width: balloonWidth, height: balloonWidth)))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: balloonWidth, height: balloonWidth)
                                .clipShape(Circle())
                        } else {
                            Text("\(birthday.givenName?.first ?? ".")\(birthday.familyName?.first ?? ".")")
                                .aspectRatio(contentMode: .fill)
                                .frame(width: balloonWidth, height: balloonWidth)
                                .background(Color(uiColor: .systemOrange))
                                .foregroundColor(Color(uiColor: .label))
                                .clipShape(Circle())
                        }
                        Text(birthday.givenName ?? "")
                            .font(.caption)
                            .padding(.horizontal, 2)
                            .background(Color(uiColor: UIColor.systemBackground))
                            .cornerRadius(5)
                    }
                    .position(x: x, y: y)

                    Path { path in
                        path.move(to: CGPoint(x: x, y: y - proxy.size.height/2 + balloonWidth/2 + 5))
                        path.addLine(to: CGPoint(x: x, y: proxy.size.height/2-15))
                    }
                    .stroke(.secondary, lineWidth: 1)
                }
            }

            BalloonsTimelineView(size: proxy.size)
        }
    }
}
