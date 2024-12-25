//  Created by Dominik Hauser on 25.12.24.
//  
//

import WidgetKit

// https://forums.developer.apple.com/forums/thread/660202
class WidgetContentLoader: NSObject {
	@objc public static func reloadWidgetContent() {
        WidgetCenter.shared.reloadAllTimelines()
	}
}
