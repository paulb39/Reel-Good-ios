//
//  aboutViewController.m
//  ReelGood
//
//  Created by Paul Brenner on 3/4/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "aboutViewController.h"

@interface aboutViewController ()
- (IBAction)goBackToMain:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *lblAbout;

@end

@implementation aboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version =  [info objectForKey:@"CFBundleShortVersionString"]; // set version from xCode, instead of manually
    NSString* Version = [NSString stringWithFormat:@"Version: %@", version];
    
    NSString* txtInfo = [NSString stringWithFormat:@"%@\n\n%@", self.lblAbout.text, Version];
    
    self.lblAbout.text = txtInfo;
    self.lblAbout.textColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBackToMain:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
