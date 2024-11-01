//  Created by Dominik Hauser on 27.10.24.
//  
//


#import "GameViewController.h"
#import "GameScene.h"
#import "DDHContactsManager.h"

@interface GameViewController ()
@property (nonatomic, strong) NSArray<DDHBirthday *> *birthdays;
@property (nonatomic, strong) GameScene *scene;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _birthdays = [[NSArray alloc] init];

    _scene = [[GameScene alloc] init];

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

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)add:(UIButton *)sender {
    DDHContactsManager *contactsManager = [[DDHContactsManager alloc] init];
    [contactsManager requestContactsAccess:^(BOOL granted) {
        NSLog(@"requestContactsAccess");
        if (granted) {
            [contactsManager fetchImportableContactsIgnoringExitingIds:@[] completionHandler:^(NSArray<CNContact *> * _Nonnull contacts) {
                NSArray<DDHBirthday *> *birthdays = [contactsManager birthdaysFromContacts:contacts];
                self.birthdays = [self.birthdays arrayByAddingObjectsFromArray:birthdays];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.scene updateForBirthdays:self.birthdays];
                });
            }];
        }
    }];
}

@end
