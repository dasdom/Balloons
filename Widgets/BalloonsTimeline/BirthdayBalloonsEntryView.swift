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
        entry.birthdays.map({ .init(birthday: $0) })
    }

    var body: some View {
        GeometryReader { proxy in
            ForEach(birthdays, id: \.self) { birthday in
                let y = CGFloat.random(in: 10..<80)
                let x = PositionCalculator.balloonX(for: birthday.daysLeft, canvasWidth: proxy.size.width)

                VStack {
                    VStack(spacing: 0) {
                        if let imageData = birthday.imageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage.resized(with: CGSize(width: 40, height: 40)))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } else {
                            Text("\(birthday.givenName?.first ?? ".")\(birthday.familyName?.first ?? ".")")
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .background(Color(uiColor: .systemOrange))
                                .foregroundColor(Color(uiColor: .label))
                                .clipShape(Circle())
                        }
                        Text(birthday.givenName ?? "None")
                            .font(.footnote)
                    }
                    .position(x: x, y: y)

                    Path { path in
                        path.move(to: CGPoint(x: x, y: y - proxy.size.height/2 + 25))
                        path.addLine(to: CGPoint(x: x, y: proxy.size.height/2-15))
                    }
                    .stroke(.secondary, lineWidth: 1)
                }
            }

            BalloonsTimelineView(size: proxy.size)
        }
    }
}
