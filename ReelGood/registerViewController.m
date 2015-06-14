//
//  registerViewController.m
//  ReelGood
//
//  Created by Paul Brenner on 2/7/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "registerViewController.h"
#import "ViewController.h"

@interface registerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIWebView *registerWebView;
- (IBAction)goBackToLogin:(id)sender;
- (IBAction)registerAccount:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainField;

@end

@implementation registerViewController

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

-(void)webViewDidFinishLoad:(UIWebView *)webView { // check if username creation was successful

    NSString *lowercaseUserName = [self.usernameField.text lowercaseString];
    
    NSString* finishedSuccessfullyMessage = @"New record created successfully";
    
    NSString* innerWebView = [self.registerWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    
    NSLog(@"Inner%@",[self.registerWebView stringByEvaluatingJavaScriptFromString:
                      @"document.documentElement.innerHTML"]);
    
    NSLog(@"inner: %@", innerWebView);
    
    NSUserDefaults* settings = [NSUserDefaults new];
    
    if ([innerWebView rangeOfString:finishedSuccessfullyMessage].location == NSNotFound) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Try Again"
                       message:@"That username already exists! Please try another."
                       delegate: nil
                       cancelButtonTitle: @"OK"
                       otherButtonTitles: nil];
        [alertDialog show];
    }
    else {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Success"
                       message:@"Account created successfully. You are now logged in"
                       delegate: nil
                       cancelButtonTitle: @"OK"
                       otherButtonTitles: nil];
        [alertDialog show];
        
        
        [settings setObject:lowercaseUserName forKey:kcurrentUser];
        [settings setObject:@"0" forKey:ksegueFromMain];
        [settings synchronize];
        
       [self performSegueWithIdentifier:@"toMainView" sender:self];
    }


    
}

- (IBAction)goBackToLogin:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerAccount:(id)sender {
    NSURL *detailURL;
    NSString *detailURLString;

    NSString *usernameFieldTest = self.usernameField.text;
    NSString *passwordFieldTest = self.passwordField.text;
    NSString *lowercaseUserNameTest = [usernameFieldTest lowercaseString];

    usernameAlreadyExists = NO;
    fieldsAreEmpty = NO;
    passwordsMatch = NO;


    detailURLString=[NSString stringWithFormat:
                 @"http://148.166.200.55/brennerp/phptest/data/pushdatagettest.php?username=%@&password=%@"
                 ,usernameFieldTest,passwordFieldTest];

    detailURL=[[NSURL alloc] initWithString:detailURLString];


    if ([self checkIfUsernameExists:lowercaseUserNameTest sender:nil]) //check if username exists
{
    usernameAlreadyExists = YES;
}
    else
{
    usernameAlreadyExists = NO;
}


    [self checkIfFieldsAreEmpty]; // check if fields are empty
    [self checkIfPasswordsMatch]; // check if passwords match


    if (usernameAlreadyExists == NO && fieldsAreEmpty == NO && passwordsMatch == YES) // create entry
{
	[self.registerWebView loadRequest:[NSURLRequest requestWithURL:detailURL]]; // send website to view, which will create username
    self.registerWebView.delegate = self;
}

}

- (IBAction)hideKeyboard:(id)sender {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.passwordAgainField resignFirstResponder];
}

- (void) checkIfPasswordsMatch{
    if ([self.passwordAgainField.text isEqualToString:self.passwordField.text]) {
        passwordsMatch = YES;
    }
    else {
        passwordsMatch = NO;
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Passwords don't match!"
                       message:@"The passwords do not match, please try again"
                       delegate: nil
                       cancelButtonTitle: @"OK"
                       otherButtonTitles: nil];
        [alertDialog show];
    }
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

- (BOOL)checkIfUsernameExists:(NSString *)nameOfUser sender:(id)sender{
    
    for (j = 0; j<[userNames count]; j++) //check if username already exists
    {
        NSString* tempUsernameString = userNames[j];
        
        if ([nameOfUser isEqualToString:tempUsernameString]) //username exists
        {
            foundUsername = YES;
            UIAlertView *alertDialog;
            alertDialog = [[UIAlertView alloc]
                           initWithTitle: @"Try again"
                           message:@"Username already exists, please try another one"
                           delegate: nil
                           cancelButtonTitle: @"OK"
                           otherButtonTitles: nil];
            [alertDialog show];
            return YES;
            break;
        }
    }
    
    return NO;
}

@end
