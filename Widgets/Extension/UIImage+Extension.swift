//  Created by Dominik Hauser on 14.12.24.
//  
//

import UIKit

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
