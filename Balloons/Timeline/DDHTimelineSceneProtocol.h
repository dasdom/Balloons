//  Created by Dominik Hauser on 15.12.24.
//  
//


#ifndef DDHTimelineSceneProtocol_h
#define DDHTimelineSceneProtocol_h

@class DDHBirthday;

@protocol DDHTimelineSceneProtocol <NSObject>
- (void)didSelectBalloon;
- (void)didDeselectBalloon;
@end

#endif /* DDHTimelineSceneProtocol_h */
