//  Created by Dominik Hauser on 03.08.25.
//  
//

import SwiftUI


struct SingleBalloonView: View {
    let balloonWidth: CGFloat
    let birthday: CodableBirthday

    var body: some View {

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
                    .font(.subheadline)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: balloonWidth, height: balloonWidth)
                    .background(balloonColor(daysLeft: birthday.daysLeft))
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
            Text("\(birthday.daysLeft)")
                .font(.footnote)
                .bold()
                .padding(.horizontal, 2)
                .background(Color(uiColor: UIColor.systemBackground))
                .cornerRadius(5)
        }
    }

    func balloonColor(daysLeft: Int) -> Color {
        Color(uiColor: UIColor(hue: CGFloat(daysLeft)/366.0, saturation: 0.7, brightness: 0.7, alpha: 1))
    }
}
