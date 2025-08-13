//  Created by Dominik Hauser on 27.10.24.
//  
//


#import <XCTest/XCTest.h>

@interface AppStoreScreenshotsUITests : XCTestCase

@end

@implementation AppStoreScreenshotsUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testCreateAppStoreScreenshots {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    [app.buttons[@"add"] tap];

    [self takeScreenshotWithName:@"01_Input"];

    [app.staticTexts[@"Import From Contacts"] tap];
    [self handleContactsPermissionAlert];
    [self handleAccessPrompt];

    sleep(2);

    [self takeScreenshotWithName:@"02_MainView280"];

    XCUIElement *gearshapeButton = app.buttons[@"gearshape"];
    [gearshapeButton tap];

    [self takeScreenshotWithName:@"03_MainView30"];

    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.buttons[@"30 days"] tap];

    XCUIElement *closeButton = app.navigationBars[@"Settings"].buttons[@"Close"];
    [closeButton tap];

    [self takeScreenshotWithName:@"04_MainView30"];

    [gearshapeButton tap];
    [tablesQuery.buttons[@"360 days"] tap];
    [closeButton tap];

    [self takeScreenshotWithName:@"05_MainView360"];

    [app.otherElements[@"Kate"] tap];

    sleep(2);
    [self takeScreenshotWithName:@"06_Details"];

    
}

- (void)handleContactsPermissionAlert {
    XCUIApplication *springboard = [[XCUIApplication alloc] initWithBundleIdentifier:@"com.apple.springboard"];
    [springboard.buttons[@"Continue"] tap];
}

- (void)handleAccessPrompt {
    XCUIApplication *access = [[XCUIApplication alloc] initWithBundleIdentifier:@"com.apple.ContactsUI.LimitedAccessPromptView"];
    [access.buttons[@"Share All 6 Contacts"] tap];
}

- (void)takeScreenshotWithName:(NSString *)name {
    sleep(1);

    XCUIScreenshot *screenshot = [[XCUIScreen mainScreen] screenshot];

    NSString *screenshotName = [NSString stringWithFormat:@"Screenshot-%@-%@.png", [[UIDevice currentDevice] name], name];
    XCTAttachment *attachment = [[XCTAttachment alloc] initWithUniformTypeIdentifier:@"public.png"
                                                                                name:screenshotName
                                                                             payload:[screenshot PNGRepresentation]
                                                                            userInfo:nil];

    [attachment setLifetime:XCTAttachmentLifetimeKeepAlways];

    [self addAttachment:attachment];
}
@end
