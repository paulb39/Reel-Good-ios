//
//  ViewController.m
//  ReelGood
//
//  Created by Paul Brenner on 11/13/14.
//  Copyright (c) 2014 reelGoodApps. All rights reserved.
//

#import "ViewController.h"
#import "JSONDictionaryExtensions.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

@interface ViewController ()
- (IBAction)loginToApp:(id)sender;
- (IBAction)registerNewAccount:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)goToAboutPage:(id)sender;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    //[self performSegueWithIdentifier:@"toMain" sender:self];
    
    NSUserDefaults *settings = [NSUserDefaults new]; // get info from userDefaults
    NSString* userCheck = [settings stringForKey:kcurrentUser];
    NSString* segueCheck = [settings stringForKey:ksegueFromMain];
    
    if (segueCheck == NULL) {
        segueCheck = @"0";
        [settings setObject:segueCheck forKey:ksegueFromMain];
        [settings synchronize];
    }
    
    //NSLog(@"userCheck is %@", userCheck);
    //NSLog(@"segue check is %@", segueCheck);
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    
    if (status == NotReachable) {
        //NSLog(@"NO INTERNET");
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Error"
                       message:@"Please connect to a network before using the app"
                       delegate: nil
                       cancelButtonTitle: @"OK"
                       otherButtonTitles: nil];
        [alertDialog show];
    } else {
        //NSLog(@"Internet connection exists");
        
        
        if (userCheck != NULL && [segueCheck isEqualToString:@"0"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // show loading screen
            hud.labelText = @"Updating...";
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self performSegueWithIdentifier:@"toMain" sender:self];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
        
    }
    

    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if (status == NotReachable) {
        //NSLog(@"NO INTERNET"); // check for internet connection first
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Error"
                       message:@"Please connect to a network before using the app"
                       delegate: nil
                       cancelButtonTitle: @"OK"
                       otherButtonTitles: nil];
        [alertDialog show];
    } else {
        //NSLog(@"Internet connection exists");
        [self getUserData];  // get all username and passwords, put into arrays
    }
    

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginToApp:(id)sender {
    //change to optimized method? use new php file?
    NSString *usernameFieldTests = self.usernameField.text;
    NSString *passwordFieldTests = self.passwordField.text;
    NSString *lowercaseUserNameTests = [usernameFieldTests lowercaseString];
    NSUserDefaults *settings = [NSUserDefaults new];
    
    foundUsername = NO;
    passwordCorrect = NO;
    fieldsAreEmpty = NO;
    
    [self checkIfFieldsAreEmpty]; // check if fields are empty
    
    if ([self checkIfUsernameExists:lowercaseUserNameTests sender:nil]) //check if username exists
    {
        foundUsername = YES;
    
        if ([passwordFieldTests isEqualToString:passWords[j]])
        {
            passwordCorrect = YES;
        }
    }
    
    //NSLog(@"Username: %d Password: %d fieldsEmpty %d", foundUsername, passwordCorrect, fieldsAreEmpty);
    
    if (foundUsername == NO && fieldsAreEmpty == NO)
    {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Try Again"
                       message:@"Username does not exist, please register first."
                       delegate: nil
                       cancelButtonTitle: @"OK"
                       otherButtonTitles: nil];
        [alertDialog show];
    }
    else if (foundUsername == YES && passwordCorrect == NO) //correct username but incorrect password
    {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Try Again"
                       message:@"Password is incorrect, please try again."
                       delegate: nil
                       cancelButtonTitle: @"OK"
                       otherButtonTitles: nil];
        [alertDialog show];
    }
    else if (foundUsername == YES && passwordCorrect == YES && fieldsAreEmpty == NO) // username and password are correct
    {
     /*   UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Success!"
                       message:@"Logged in successfully"
                       delegate: nil
                       cancelButtonTitle: @"OK"
                       otherButtonTitles: nil];
        [alertDialog show];*/
        
        [settings setObject:lowercaseUserNameTests forKey:kcurrentUser];
        [settings setObject:@"0" forKey:ksegueFromMain];
        [settings setObject:@"1" forKey:kaddedOrRemovedFriend]; // to always load when logging in
        [settings synchronize];
        
        [self performSegueWithIdentifier:@"toMain" sender:self];
    }
    
}

- (IBAction)registerNewAccount:(id)sender {
    
    [self performSegueWithIdentifier:@"toRegister" sender:self];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (IBAction)goToAboutPage:(id)sender {
    [self performSegueWithIdentifier:@"goToAboutPage" sender:self];
}

/*
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error { // if error
    UIAlertView *alertDialog;
    
    alertDialog = [[UIAlertView alloc]
                   initWithTitle: @"Error Loading"
                   message: error.localizedDescription
                   delegate: self
                   cancelButtonTitle: @"Ok"
                   otherButtonTitles: nil];
    [alertDialog show];
}
 */


- (void) getUserData
{
    NSError *dataError;
    
    NSData *dataPHP = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:@"http://148.166.200.55/brennerp/phptest/data/loginData.php"]];
    
    NSArray *dataJSON = [NSJSONSerialization
                         JSONObjectWithData:dataPHP
                         options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                         error:&dataError];
    
    userNames = [[NSMutableArray alloc] init];
    passWords = [[NSMutableArray alloc] init];
    userIDs = [[NSMutableArray alloc] init];
    Counter = 0;

    if (dataError)
    {
        //NSLog(@"%@", [dataError localizedDescription]);
    }
    else {
        for ( NSDictionary *theInfo in dataJSON )
        {
            userIDs[Counter] = theInfo[@"myid"];
            userNames[Counter] = theInfo[@"acc_username"]; //push data to arrays
            passWords[Counter] = theInfo[@"acc_password"];
            Counter++;
        }
    }
    
}

- (BOOL)checkIfUsernameExists:(NSString *)nameOfUser sender:(id)sender{
    
    for (j = 0; j<[userNames count]; j++) //check if username already exists
    {
        NSString* tempUsernameString = userNames[j];
        
        if ([nameOfUser isEqualToString:tempUsernameString]) //username exists
        {
            foundUsername = YES;
            return YES;
            break;
        }
    }
    
    return NO;
}

- (void) checkIfFieldsAreEmpty{
    
    if (self.usernameField.text.length == 0 || self.passwordField.text.length == 0) // if did not enter anything
    {
        fieldsAreEmpty = YES; // set bool to yes for check at end
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Enter login info!"
                       message:@"Please enter a username and password before hitting the button"
                       delegate: nil
                       cancelButtonTitle: @"OK"
                       otherButtonTitles: nil];
        [alertDialog show];
    }
}

@end
