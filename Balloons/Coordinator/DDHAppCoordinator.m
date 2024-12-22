//  Created by Dominik Hauser on 20.11.24.
//  
//


#import "DDHAppCoordinator.h"
#import "DDHGameViewController.h"
#import "DDHSettingsViewController.h"
#import "DDHBirthdayInputViewController.h"
#import "DDHContactsManager.h"
#import <UserNotifications/UserNotifications.h>
#import "DDHStorage.h"
#import "NSUserDefaults+Extension.h"

@interface DDHAppCoordinator () <DDHGameViewControllerDelegate, DDHSettingsViewControllerDelegate, DDHBirthdayInputViewControllerProtocol>
@property (nonatomic, strong) DDHGameViewController *gameViewController;
@end

@implementation DDHAppCoordinator
- (UIViewController *)start {
    self.gameViewController = [[DDHGameViewController alloc] initWithDelegate:self];
    return self.gameViewController;
}

// MARK: - DDHGameViewControllerDelegate
- (void)didSelectSettingsInViewController:(UIViewController *)viewController birthdays:(NSArray<DDHBirthday *> *)birthdays {
//    if ([viewController isKindOfClass:[DDHGameViewController class]]) {
//        [(DDHGameViewController *)viewController pointGravityDown];
//    }

    DDHSettingsViewController *next = [[DDHSettingsViewController alloc] initWithDelegate:self birthdays:birthdays];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:next];
    [viewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)didSelectAddInViewController:(UIViewController *)viewController {
    DDHBirthdayInputViewController *next = [[DDHBirthdayInputViewController alloc] initWithDelegate:self];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:next];
    [viewController presentViewController:navigationController animated:YES completion:nil];
}

// MARK: - DDHSettingsViewControllerDelegate
- (void)didSelectCloseInViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
//    [self.gameViewController pointGravityUp];
}

// MARK: - DDHBirthdayInputViewControllerProtocol
- (void)didSelectImportFromContactsInViewController:(UIViewController *)viewController {
    [self importFromContacts];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)importFromContacts {
    DDHContactsManager *contactsManager = [[DDHContactsManager alloc] init];
    [contactsManager requestContactsAccess:^(BOOL granted) {
        NSLog(@"requestContactsAccess");
        if (granted) {
            [contactsManager fetchImportableContactsIgnoringExitingIds:@[] completionHandler:^(NSArray<CNContact *> * _Nonnull contacts) {

                NSArray<DDHBirthday *> *birthdays = [contactsManager birthdaysFromContacts:contacts];
                [self.gameViewController updateWithBirthdays:birthdays];
            }];
        }
    }];
}

- (void)didSelectCancelInViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [self.gameViewController updateWithBirthdays:@[]];
}

// MARK: - Misc
- (void)didChangeNumberOfShownDays:(UIViewController *)viewController numberOfShownDays:(NSInteger)numberOfShownDays {
    [self.gameViewController setNumberOfShownDays:numberOfShownDays];
}
@end
