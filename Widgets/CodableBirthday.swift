//  Created by Dominik Hauser on 14.12.24.
//  
//

struct CodableBirthday: Codable, Hashable {
    let givenName: String?
    let familyName: String?
    let imageData: Data?
    let daysLeft: Int

    init(givenName: String, familyName: String, imageData: Data?, daysLeft: Int) {
        self.givenName = givenName
        self.familyName = familyName
        self.imageData = imageData
        self.daysLeft = daysLeft
    }

    init(birthday: DDHBirthday) {
        self.givenName = birthday.personNameComponents.givenName
        self.familyName = birthday.personNameComponents.familyName
        self.imageData = birthday.imageData
        self.daysLeft = birthday.daysLeft
    }
}
