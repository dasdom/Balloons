//  Created by Dominik Hauser on 18.04.25.
//  
//


#import "DDHImprintViewController.h"
#import "DDHImprintView.h"

@interface DDHImprintViewController ()

@end

@implementation DDHImprintViewController

- (void)loadView {
    self.view = [[DDHImprintView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Imprint";

    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = done;
}

// MARK: - Actions
- (void)done:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
