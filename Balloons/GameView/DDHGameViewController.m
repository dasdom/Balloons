//  Created by Dominik Hauser on 27.10.24.
//  
//


#import "DDHGameViewController.h"
#import "DDHTimelineScene.h"
#import "DDHContactsManager.h"
#import "DDHBirthday.h"
#import "DDHStorage.h"
#import "DDHGameView.h"

@interface DDHGameViewController ()
@property (nonatomic, strong) NSArray<DDHBirthday *> *birthdays;
@property (nonatomic, strong) DDHTimelineScene *scene;
@property (nonatomic, strong) DDHStorage *storage;
@end

@implementation DDHGameViewController

- (void)loadView {
    self.view = [[DDHGameView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (DDHGameView *)contentView {
    return (DDHGameView *)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _storage = [[DDHStorage alloc] init];
    [_storage createDatabaseIfNeeded];

    _birthdays = [_storage birthdays];

    _scene = [[DDHTimelineScene alloc] initWithSize:self.view.frame.size];

    // Set the scale mode to scale to fit the window
    _scene.scaleMode = SKSceneScaleModeAspectFill;

//    SKView *skView = (SKView *)self.view;

    // Present the scene
    [self.contentView.skView presentScene:_scene];

    [self.contentView.addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
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
                [self.storage insertBirthdays:birthdays];

                self.birthdays = [self.storage birthdays];

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

@end
