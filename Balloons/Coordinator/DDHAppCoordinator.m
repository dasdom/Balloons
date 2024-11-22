//  Created by Dominik Hauser on 20.11.24.
//  
//


#import "DDHAppCoordinator.h"
#import "DDHGameViewController.h"
#import "DDHSettingsViewController.h"

@interface DDHAppCoordinator () <DDHGameViewControllerDelegate, DDHSettingsViewControllerDelegate>
@property (nonatomic, strong) DDHGameViewController *gameViewController;
@end

@implementation DDHAppCoordinator
- (UIViewController *)start {
    self.gameViewController = [[DDHGameViewController alloc] initWithDelegate:self];
    return self.gameViewController;
}

- (void)didSelectSettingsInViewController:(UIViewController *)viewController {
//    if ([viewController isKindOfClass:[DDHGameViewController class]]) {
//        [(DDHGameViewController *)viewController pointGravityDown];
//    }

    DDHSettingsViewController *next = [[DDHSettingsViewController alloc] initWithDelegate:self];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:next];
    [viewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)didSelectCloseInViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
//    [self.gameViewController pointGravityUp];
}

- (void)didChangeNumberOfShownDays:(UIViewController *)viewController numberOfShownDays:(NSInteger)numberOfShownDays {
    [self.gameViewController setNumberOfShownDays:numberOfShownDays];
}
@end
