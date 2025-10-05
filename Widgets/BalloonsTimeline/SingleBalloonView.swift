//  Created by Dominik Hauser on 03.08.25.
//  
//

import SwiftUI


struct SingleBalloonView: View {
    let balloonWidth: CGFloat
    let birthday: CodableBirthday
    @Environment(\.widgetRenderingMode) private var widgetRenderingMode

    var body: some View {

        VStack(spacing: 0) {
            if let imageData = birthday.imageData,
               let uiImage = UIImage(data: imageData) {
                if #available(iOS 18.0, *) {
                    Image(uiImage: uiImage.resized(with: CGSize(width: balloonWidth, height: balloonWidth)))
                        .resizable()
                        .widgetAccentedRenderingMode(.fullColor)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: balloonWidth, height: balloonWidth)
                        .clipShape(Circle())
                } else {
                    Image(uiImage: uiImage.resized(with: CGSize(width: balloonWidth, height: balloonWidth)))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: balloonWidth, height: balloonWidth)
                        .clipShape(Circle())
                }
            } else {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 2)
                        .foregroundStyle(balloonColor(daysLeft: birthday.daysLeft))
                        .frame(width: balloonWidth, height: balloonWidth)
                        .widgetAccentable()

                    Text("\(birthday.givenName?.first ?? ".")\(birthday.familyName?.first ?? ".")")
                        .font(.subheadline)
                        .aspectRatio(contentMode: .fill)
                        .widgetAccentable(false)
                }
            }
            Text("\(birthday.daysLeft)")
                .font(.footnote)
                .bold()
                .padding(.horizontal, 2)
                .cornerRadius(5)
        }
    }

    func balloonColor(daysLeft: Int) -> Color {
        Color(uiColor: UIColor(hue: CGFloat(daysLeft)/366.0, saturation: 0.7, brightness: 0.7, alpha: 1))
    }
}
