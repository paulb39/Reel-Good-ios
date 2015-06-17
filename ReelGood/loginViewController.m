//
//  loginViewController.m
//  ReelGood
//
//  Created by Paul Brenner on 6/14/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "loginViewController.h"

@interface loginViewController ()

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;

- (IBAction)toAboutPage:(id)sender;

@end

@implementation loginViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    if ([FBSDKAccessToken currentAccessToken]) {

         NSLog(@"already loged in");
        [self performSegueWithIdentifier: @"toMain" sender: self]; // load main view controller
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version =  [info objectForKey:@"CFBundleShortVersionString"]; // set version from xCode, instead of manually
    self.lblVersion.text = [NSString stringWithFormat:@"Version: %@", version];
    
    self.loginButton.delegate = self;
    self.loginButton.readPermissions = @[@"public_profile", @"email"];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error;
{
    NSLog(@"you logged in");
    
    [self performSegueWithIdentifier: @"toMain" sender: self]; // load main view controller
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton;
{
    NSLog(@"you loged out");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)toAboutPage:(id)sender {
    [self performSegueWithIdentifier: @"goToAboutPage" sender: self];
}
@end
