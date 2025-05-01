//  Created by Dominik Hauser on 27.04.25.
//  
//


#import "DDHPresentInputViewController.h"
#import "DDHPresentInputView.h"

@interface DDHPresentInputViewController ()

@end

@implementation DDHPresentInputViewController
- (void)loadView {
    self.view = [[DDHPresentInputView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Add present idea";
}
@end
