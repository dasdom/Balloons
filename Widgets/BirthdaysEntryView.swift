//  Created by Dominik Hauser on 27.11.24.
//  
//

import SwiftUI

struct CodableBirthday: Codable, Hashable {
    let givenName: String?
    let familyName: String?
    let imageData: Data?
    let daysLeft: Int

    init(birthday: DDHBirthday) {
        self.givenName = birthday.personNameComponents.givenName
        self.familyName = birthday.personNameComponents.familyName
        self.imageData = birthday.imageData
        self.daysLeft = birthday.daysLeft
    }
}

struct CodableDisplayMonth: Codable, Hashable {
    let name: String
    let start: Int
    let end: Int
}

struct BirthdaysEntryView : View {
    private let numberOfShownDays: CGFloat = 50
    var entry: Provider.Entry
    var nameFormatter: PersonNameComponentsFormatter = {
        let formatter = PersonNameComponentsFormatter()
        formatter.style = .abbreviated
        return formatter
    }()
    var birthdays: [CodableBirthday] {
        entry.birthdays.map({ .init(birthday: $0) })
    }
    var displayMonths: [CodableDisplayMonth] {
        DDHDateHelper.displayMonthsUseVeryShort(false).map({ CodableDisplayMonth(name: $0.name, start: $0.start, end: $0.end) })
    }

    var body: some View {
        GeometryReader { proxy in
            ForEach(displayMonths, id: \.self) { displayMonth in
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 1, height: 14)
                    .position(x: lineX(for: displayMonth, canvasWidth: proxy.size.width),
                              y: proxy.size.height - 3)
            }

            ForEach(birthdays, id: \.self) { birthday in
                let y = CGFloat.random(in: 10..<80)
                let x = balloonX(for: birthday.daysLeft, canvasWidth: proxy.size.width)

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
                                .background(Color(uiColor: .systemPink))
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

            ForEach(displayMonths, id: \.start) { displayMonth in
                Text(displayMonth.name)
                    .position(x: labelX(for: displayMonth, canvasWidth: proxy.size.width), y: proxy.size.height)
            }

            Rectangle()
//                .fill()
                .frame(width: proxy.size.width + 40, height: 2)
                .position(x: proxy.size.width/2 + 20, y: proxy.size.height-10)

            Rectangle()
//                .fill(Color.red)
                .frame(width: 2, height: 8)
                .position(x: 0, y: proxy.size.height-10)
        }
    }

    private func balloonX(for daysLeft: Int, canvasWidth: CGFloat) -> CGFloat {
        let xPos = canvasWidth * CGFloat(daysLeft) / numberOfShownDays
//        print(xPos)
        return xPos
    }

    private func labelX(for displayMonth: CodableDisplayMonth, canvasWidth: CGFloat) -> CGFloat {
        return canvasWidth * CGFloat(displayMonth.start + displayMonth.end)/2 / numberOfShownDays
    }

    private func lineX(for displayMonth: CodableDisplayMonth, canvasWidth: CGFloat) -> CGFloat {
        return canvasWidth * CGFloat(displayMonth.start) / numberOfShownDays
    }
}

extension UIImage {
    func resized(with size: CGSize) -> UIImage {
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = true;

        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
        return renderer.image { context in
            let frame = CGRect(origin: .zero, size: size)
            draw(in: frame)
        }
    }
}
