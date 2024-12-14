//  Created by Dominik Hauser on 14.12.24.
//  
//

struct CodableDisplayMonth: Codable, Hashable {
    let name: String
    let start: Int
    let end: Int
}
