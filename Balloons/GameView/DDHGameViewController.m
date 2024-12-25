//  Created by Dominik Hauser on 27.10.24.
//  
//


#import "DDHGameViewController.h"
#import "DDHTimelineScene.h"
#import "DDHContactsManager.h"
#import "DDHBirthday.h"
#import "DDHStorage.h"
#import "DDHGameView.h"
#import "DDHSettingsViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "NSUserDefaults+Extension.h"
#import "DDHTimelineSceneProtocol.h"
#import "Balloons-Swift.h"

@interface DDHGameViewController () <DDHTimelineSceneProtocol>
@property (nonatomic, strong) id<DDHGameViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray<DDHBirthday *> *birthdays;
@property (nonatomic, strong) DDHTimelineScene *scene;
@property (nonatomic, strong) DDHStorage *storage;
@property (nonatomic, strong) UISelectionFeedbackGenerator *feedbackGenerator;
@property (nonatomic, weak) DDHGameView *contentView;
@end

@implementation DDHGameViewController

- (instancetype)initWithDelegate:(id<DDHGameViewControllerDelegate>)delegate {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _delegate = delegate;
    }
    return self;
}

- (void)loadView {
    self.view = [[DDHGameView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (DDHGameView *)contentView {
    return (DDHGameView *)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _feedbackGenerator = [UISelectionFeedbackGenerator feedbackGeneratorForView:self.view];

    _storage = [[DDHStorage alloc] init];
    [_storage createDatabaseIfNeeded];

    _birthdays = [_storage birthdays];

    _scene = [[DDHTimelineScene alloc] initWithSize:self.view.frame.size timelineDelegate:self];

    _scene.scaleMode = SKSceneScaleModeAspectFill;

    [self.contentView.skView presentScene:_scene];

    [self.contentView.addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.settingsButton addTarget:self action:@selector(settings:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.scene updateForBirthdays:self.birthdays];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.scene updateWithSize:size];
    [self.scene updateForBirthdays:self.birthdays];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)updateWithBirthdays:(NSArray<DDHBirthday *> *)birthdays {
    [self.storage insertBirthdays:birthdays];

    self.birthdays = [self.storage birthdays];

    [self setupNotificationsIfNeededWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.scene updateForBirthdays:self.birthdays];

            UIButton *addButton = self.contentView.addButton;
            UIButtonConfiguration *buttonConfig = addButton.configuration;
            buttonConfig.showsActivityIndicator = NO;
            addButton.configuration = buttonConfig;

            [WidgetContentLoader reloadWidgetContent];
        });
    }];
}

// MARK: - Actions
- (void)add:(UIButton *)sender {
    UIButtonConfiguration *buttonConfig = sender.configuration;
    buttonConfig.showsActivityIndicator = YES;
    sender.configuration = buttonConfig;

    [self.delegate didSelectAddInViewController:self];
}

//- (void)importFromContacts {
//    DDHContactsManager *contactsManager = [[DDHContactsManager alloc] init];
//    [contactsManager requestContactsAccess:^(BOOL granted) {
//        NSLog(@"requestContactsAccess");
//        if (granted) {
//            [contactsManager fetchImportableContactsIgnoringExitingIds:@[] completionHandler:^(NSArray<CNContact *> * _Nonnull contacts) {
//
//                NSArray<DDHBirthday *> *birthdays = [contactsManager birthdaysFromContacts:contacts];
//                [self.storage insertBirthdays:birthdays];
//
//                self.birthdays = [self.storage birthdays];
//
//                [self setupNotificationsIfNeededWithCompletion:^{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.scene updateForBirthdays:self.birthdays];
//                    });
//                }];
//
//            }];
//        }
//    }];
//}

- (void)setupNotificationsIfNeededWithCompletion:(void (^)(void))completionHandler {
    if ([[NSUserDefaults standardUserDefaults] notificationsActive]) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        // Fetch the pending notification requests and only add a request if it is not already added.
        [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {

            NSMutableArray<NSString *> *requestIds = [[NSMutableArray alloc] init];
            for (UNNotificationRequest *request in requests) {
                [requestIds addObject:request.identifier];
            }

            for (DDHBirthday *birthday in self.birthdays) {

                UNNotificationRequest* request = [birthday notificationRequest];
                if (NO == [requestIds containsObject:request.identifier]) {
                    [center addNotificationRequest:request withCompletionHandler:nil];
                }
            }
            completionHandler();
        }];
    } else {
        completionHandler();
    }
}

- (void)settings:(UIButton *)sender {
    [self.delegate didSelectSettingsInViewController:self birthdays:self.birthdays];
}

- (void)pointGravityDown {
    [self.scene pointGravityDown];
}

- (void)pointGravityUp {
    [self.scene pointGravityUp];
}

- (void)setNumberOfShownDays:(NSInteger)numberOfShownDays {
    [self.scene setNumberOfShownDays:numberOfShownDays];
//    [self.scene updateForBirthdays:self.birthdays];
}

// MARK: - DDHTimelineSceneProtocol
- (void)didSelectBalloonInScene:(SKScene *)scene {
    [self.feedbackGenerator selectionChanged];
}

- (void)didDeselectBalloonInScene:(SKScene *)scene {
    [self.feedbackGenerator selectionChanged];
}

- (void)scene:(SKScene *)scene didSelectDeleteForBirthdayWithUUID:(NSUUID *)uuid {
    for (DDHBirthday *birthday in self.birthdays) {
        if ([birthday.uuid isEqual:uuid]) {
            [self.storage deleteBirthday:birthday];
            break;
        }
    }
}

@end
