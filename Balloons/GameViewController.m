//  Created by Dominik Hauser on 27.10.24.
//  
//


#import "GameViewController.h"
#import "DDHTimelineScene.h"
#import "DDHContactsManager.h"
#import "DDHBirthday.h"

@interface GameViewController () <DDHTimelineSceneTouchHandler>
@property (nonatomic, strong) NSArray<DDHBirthday *> *birthdays;
@property (nonatomic, strong) DDHTimelineScene *scene;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _birthdays = [[NSArray alloc] init];

    _scene = [[DDHTimelineScene alloc] initWithSize:self.view.frame.size touchHandler:self];

    // Set the scale mode to scale to fit the window
    _scene.scaleMode = SKSceneScaleModeAspectFill;

    SKView *skView = (SKView *)self.view;
    
    // Present the scene
    [skView presentScene:_scene];

    UIButtonConfiguration *addButtonConfiguration = [UIButtonConfiguration plainButtonConfiguration];
    addButtonConfiguration.image = [UIImage systemImageNamed:@"plus"];
    UIButton *addButton = [UIButton buttonWithConfiguration:addButtonConfiguration primaryAction:nil];
    addButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:addButton];

    [NSLayoutConstraint activateConstraints:@[
        [addButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:16],
        [addButton.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-16],
    ]];

    [addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.scene updateWithSize:size];
    [self.scene updateForBirthdays:self.birthdays];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)add:(UIButton *)sender {

    UIButtonConfiguration *buttonConfig = sender.configuration;
    buttonConfig.showsActivityIndicator = YES;
    sender.configuration = buttonConfig;

    DDHContactsManager *contactsManager = [[DDHContactsManager alloc] init];
    [contactsManager requestContactsAccess:^(BOOL granted) {
        NSLog(@"requestContactsAccess");
        if (granted) {
            [contactsManager fetchImportableContactsIgnoringExitingIds:@[] completionHandler:^(NSArray<CNContact *> * _Nonnull contacts) {
                
                NSArray<DDHBirthday *> *birthdays = [contactsManager birthdaysFromContacts:contacts];
                self.birthdays = [self.birthdays arrayByAddingObjectsFromArray:birthdays];

                dispatch_async(dispatch_get_main_queue(), ^{

                    NSLog(@"self.scene updateForBirthdays:self.birthdays");
                    UIButtonConfiguration *buttonConfig = sender.configuration;
                    buttonConfig.showsActivityIndicator = NO;
                    sender.configuration = buttonConfig;
                    [self.scene updateForBirthdays:self.birthdays];
                });
            }];
        }
    }];
}

//// MARK: - GameSceneTouchHandler
//- (void)didTouchBirthdayWithId:(NSUUID *)birthdayId {
//    NSLog(@"birthdayId: %@", birthdayId);
//    DDHBirthday *selectedBirthday;
//    for (DDHBirthday *birthday in self.birthdays) {
//        if (birthday.uuid == birthdayId) {
//            selectedBirthday = birthday;
//            break;
//        }
//    }
//    NSLog(@"selectedBirthday: %@", selectedBirthday);
//
//    DDHPersonScene *personScene = [[DDHPersonScene alloc] initWithSize:self.view.frame.size birthday:selectedBirthday];
//    SKView *skView = (SKView *)self.view;
//    [skView presentScene:personScene transition:[SKTransition revealWithDirection:SKTransitionDirectionle duration:0.5]];
//}

@end
