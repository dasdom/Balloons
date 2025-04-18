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
#import <PhotosUI/PhotosUI.h>
#import "DDHBirthdayListViewController.h"
#import "DDHPersonsListViewController.h"
#import "DDHImprintViewController.h"

@interface DDHAppCoordinator () <DDHGameViewControllerDelegate, DDHSettingsViewControllerDelegate, DDHBirthdayInputViewControllerProtocol, DDHPersonsListViewControllerProtocol, PHPickerViewControllerDelegate>
@property (nonatomic, strong) DDHGameViewController *gameViewController;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) DDHBirthdayListViewController *birthdayListViewController;
@end

@implementation DDHAppCoordinator
- (instancetype)init {
    if (self = [super init]) {
        _navigationController = [[UINavigationController alloc] init];
    }
    return self;
}

- (UIViewController *)start {
//    UITabBarController *tabBarController = [[UITabBarController alloc] init];
//
//    DDHBirthdayListViewController *birthdayListViewController = [[DDHBirthdayListViewController alloc] init];
//    [self.navigationController pushViewController:birthdayListViewController animated:NO];
//    self.birthdayListViewController = birthdayListViewController;
//    self.navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"List" image:[UIImage systemImageNamed:@"list.bullet"] tag:0];

    self.gameViewController = [[DDHGameViewController alloc] initWithDelegate:self];
//    self.gameViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Balloons" image:[UIImage systemImageNamed:@"balloon"] tag:1];

//    tabBarController.viewControllers = @[self.navigationController, self.gameViewController];
//    return tabBarController;

    return self.gameViewController;
}

// MARK: - DDHGameViewControllerDelegate
- (void)didSelectInfo:(UIViewController *)viewController {
    DDHImprintViewController *next = [[DDHImprintViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:next];
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [viewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)didSelectSettings:(UIViewController *)viewController storage:(DDHStorage *)storage {
//    if ([viewController isKindOfClass:[DDHGameViewController class]]) {
//        [(DDHGameViewController *)viewController pointGravityDown];
//    }

    DDHSettingsViewController *next = [[DDHSettingsViewController alloc] initWithDelegate:self storage:storage];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:next];
    [viewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)didSelectAdd:(UIViewController *)viewController {
    DDHBirthdayInputViewController *next = [[DDHBirthdayInputViewController alloc] initWithDelegate:self];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:next];
    [viewController presentViewController:navigationController animated:YES completion:nil];
}

// MARK: - DDHSettingsViewControllerDelegate
- (void)didSelectCloseInViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
//    [self.gameViewController pointGravityUp];
}

- (void)didSelectPersonsInViewController:(UIViewController *)viewController storage:(nonnull DDHStorage *)storage {
    DDHPersonsListViewController *next = [[DDHPersonsListViewController alloc] initWithDelegate:self storage:storage];
    [viewController.navigationController pushViewController:next animated:YES];
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

- (void)didSelectPhotoInViewController:(UIViewController *)viewController {
    PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
    config.selectionLimit = 1;
    PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:config];
    picker.delegate = self;
    [viewController presentViewController:picker animated:YES completion:nil];
}

- (void)didSelectAddInViewController:(UIViewController *)viewController withBirthday:(DDHBirthday *)birthday {
//    [self.gameViewController updateWithBirthdays:@[birthday]];
    [self.gameViewController addBirthday:birthday];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectCancelInViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [self.gameViewController updateWithBirthdays:@[]];
}

// MARK: - PHPickerViewControllerDelegate
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results {
    [picker dismissViewControllerAnimated:YES completion:nil];

    [results.firstObject.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UINavigationController *navigationController = (UINavigationController *)[self.gameViewController presentedViewController];
            DDHBirthdayInputViewController *inputViewController = (DDHBirthdayInputViewController *)[navigationController topViewController];
            [inputViewController setImage:object];
        });
    }];
}

// MARK: - DDHPersonsListViewControllerProtocol
- (void)reloadBirthdaysFromViewController:(UIViewController *)viewController {
    [self.gameViewController updateWithBirthdays:@[]];
}

// MARK: - Misc
- (void)didChangeNumberOfShownDays:(UIViewController *)viewController numberOfShownDays:(NSInteger)numberOfShownDays {
    [self.gameViewController setNumberOfShownDays:numberOfShownDays];
}
@end
