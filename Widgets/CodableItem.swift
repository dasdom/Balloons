//  Created by Dominik Hauser on 10.03.26.
//  
//


struct CodableItem: Codable, Hashable {
    let imageData: Data?
    let balloonText: String
    let daysLeft: Int

    init(item: DDHBalloonPresentableProtocol) {
        if let birthday = item as? DDHBirthday {
            self.imageData = birthday.imageData
        } else {
            self.imageData = nil
        }
        self.balloonText = item.balloonText()
        self.daysLeft = item.daysLeft
    }
}
