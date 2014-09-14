//
//  ViewController.m
//  airdrop_custom_data
//
//  Created by Maxim Bilan on 9/14/14.
//  Copyright (c) 2014 Maxim Bilan. All rights reserved.
//

#import "ViewController.h"
#import "AirDropCustomData.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) UIPopoverController *activityPopover;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareAction:(UIButton *)sender {
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"readme 1" ofType:@"customdata"];
    NSURL *url1 = [NSURL fileURLWithPath:path1];
    AirDropCustomData *item1 = [[AirDropCustomData alloc] initWithURL:url1 subject:@"readme 1"];
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"readme 2" ofType:@"customdata"];
    NSURL *url2 = [NSURL fileURLWithPath:path2];
    AirDropCustomData *item2 = [[AirDropCustomData alloc] initWithURL:url2 subject:@"readme 2"];
    
    NSArray *items = [NSArray arrayWithObjects:item1, item2, nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    // Exclude all activities except AirDrop.
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter,
                                    UIActivityTypePostToFacebook,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage,
                                    //UIActivityTypeMail,
                                    UIActivityTypePrint,
                                    UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact,
                                    UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList,
                                    UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo,
                                    UIActivityTypePostToTencentWeibo];
    activityViewController.excludedActivityTypes = excludedActivities;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
    else {
        if (![self.activityPopover isPopoverVisible]) {
            self.activityPopover = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
            [self.activityPopover presentPopoverFromRect:[self.shareButton frame]
                                                  inView:self.view
                                permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else {
            [self.activityPopover dismissPopoverAnimated:YES];
        }
    }
}

@end
