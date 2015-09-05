//
//  loginViewController.m
//  ReelGood
//
//  Created by Paul Brenner on 6/14/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "loginViewController.h"
#import "WSHelper.h"

@interface loginViewController ()

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;

- (IBAction)toAboutPage:(id)sender;

@end

@implementation loginViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    bool hasGoogleSignIn = [[GIDSignIn sharedInstance] hasAuthInKeychain];
    [GIDSignIn sharedInstance].delegate = self; // google
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    if ([WSHelper hasNetworkConnection]) {
        if ([FBSDKAccessToken currentAccessToken]) {
            // spinner
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // show loading screen
            hud.labelText = @"Loading...";
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self performSegueWithIdentifier: @"toMain" sender: self]; // load main view controller
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            // spinner
        } else if (hasGoogleSignIn) {
            [[GIDSignIn sharedInstance] signInSilently];
        }
    } else { // No network!
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Network!" message:@"Please connect to a network before using the app!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show];
    }
    


    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version =  [info objectForKey:@"CFBundleShortVersionString"]; // set version from xCode, instead of manually
    self.lblVersion.text = [NSString stringWithFormat:@"Version: %@", version];
    
    self.loginButton.delegate = self;
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
   // self.loginButton.publishPermissions = @[@"publish_actions"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error;
{
    //NSLog(@"you logged in");
    
    if (![result isCancelled]) {
    [self performSegueWithIdentifier: @"toMain" sender: self]; // load main view controller
    }
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton;
{
    //NSLog(@"you loged out");
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
   // NSLog(@"you are now signed in, do segue if did not cancel?");
    
    if (user.userID) {
        [self performSegueWithIdentifier:@"toMain" sender:self];
    }
    
    //NSLog(@"user ID is %@", user.userID);
}


// [END signin_handler]

// This callback is triggered after the disconnect call that revokes data
// access to the user's resources has completed.
// [START disconnect_handler]
- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    //NSLog(@"you are now logged out?");

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
