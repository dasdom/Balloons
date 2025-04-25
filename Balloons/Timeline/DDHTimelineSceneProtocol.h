//  Created by Dominik Hauser on 15.12.24.
//  
//


#ifndef DDHTimelineSceneProtocol_h
#define DDHTimelineSceneProtocol_h

@class DDHBirthday;

@protocol DDHTimelineSceneProtocol <NSObject>
- (void)didSelectBalloonInScene:(SKScene *)scene;
- (void)didDeselectBalloonInScene:(SKScene *)scene;
- (void)scene:(SKScene *)scene didSelectPresentsForBirthdayWithUUID:(NSUUID *)uuid;
- (void)scene:(SKScene *)scene didSelectDeleteForBirthdayWithUUID:(NSUUID *)uuid;
@end

#endif /* DDHTimelineSceneProtocol_h */
