//  Created by Dominik Hauser on 27.11.24.
//  
//

import SwiftUI

struct BirthdayBalloonsEntryView : View {
    var entry: Provider.Entry
    var nameFormatter: PersonNameComponentsFormatter = {
        let formatter = PersonNameComponentsFormatter()
        formatter.style = .medium
        return formatter
    }()
    var birthdays: [CodableBirthday] {
        entry.birthdays.map({ .init(birthday: $0) }).sorted {
            $0.daysLeft > $1.daysLeft
        }
    }

    var body: some View {
//        ZStack(alignment: .trailing) {
            BalloonsView(birthdays: birthdays)

//            VStack {
//                ForEach(birthdays.reversed().prefix(5), id: \.self) { birthday in
//                    HStack(spacing: 10) {
//                        Text(nameFormatter.string(from: birthday.personNameComponents))
//                        Text("\(birthday.daysLeft)")
//                    }
//                    .font(.footnote)
//                }
//                Spacer()
//            }
//            .padding(.vertical, 4)
//            .padding(.horizontal, 10)
//            .background(Color(uiColor: UIColor.systemBackground.withAlphaComponent(0.8)))
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//            .padding(.bottom, 16)
//        }
    }

    func balloonColor(daysLeft: Int) -> Color {
        Color(uiColor: UIColor(hue: CGFloat(daysLeft)/366.0, saturation: 0.7, brightness: 0.7, alpha: 1))
    }
}
