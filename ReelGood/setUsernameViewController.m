//
//  setUsernameViewController.m
//  ReelGood
//
//  Created by Paul Brenner on 6/15/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "setUsernameViewController.h"
#import "WSHelper.h"

@interface setUsernameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

- (IBAction)saveUsername:(id)sender;

@property NSMutableData* recievedData;
@end

@implementation setUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveUsername:(id)sender {
    
    if ([self.usernameTextField.text length]) {
    
    if (![self checkIfUserNameExists]) { // username does not already exist, push it to db
        [self saveUsernameToDB];
    } else {
         UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Username already taken, try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show];
    }
    } else {
         UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please enter a username first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show];        
    }
    
}

- (BOOL)checkIfUserNameExists
{
     NSString* userName = [self.usernameTextField.text lowercaseString];
     
     NSString* urlString=[NSString stringWithFormat:
     @"http://148.166.200.55/brennerp/phptest/data/checkifuserexists?username=%@"
     ,userName];
     
     NSLog(@"urlString is %@", urlString);
     
     NSError *error;
     
     NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:urlString]];
     
     NSArray* dataJSON = [NSJSONSerialization
     JSONObjectWithData:data
     options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
     error:&error];
     
     
     NSLog(@"dataJSON is %@", dataJSON);
     
     
     if (!error) {
         if (![dataJSON count]) {
             NSLog(@"USERNAME IS NIL, try again");
             return NO;
         }
     } else {
         UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Can not connect to server, try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show];
     }
    
    return YES;
}
                                   
- (void)saveUsernameToDB
{
    NSString* strUsername = [self.usernameTextField.text lowercaseString];
    
    NSString* url=[NSString stringWithFormat:
                   @"http://148.166.200.55/brennerp/phptest/data/pushdatagettest.php?username=%@&password=PLACEHOLDER"
                   ,strUsername];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"GET";
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (conn) {
        [conn start];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Error on server! Try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _recievedData = [[NSMutableData alloc] init];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    
    NSLog(@"response code is %ld", (long)httpResponse.statusCode);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_recievedData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    NSLog(@"done");
    NSString* insideResponse =[[NSString alloc] initWithData:_recievedData encoding:NSUTF8StringEncoding];
    
    //NSString* errMsg = @"Error:";
    NSString *firstWord = [[insideResponse componentsSeparatedByString:@" "] objectAtIndex:0];
    
    NSLog(@"inside is %@", firstWord);
    
   if ([insideResponse rangeOfString:@"Error:"].location == NSNotFound) { // if error is NOT FOUND
       
       UIAlertView *alertDialog;
       alertDialog = [[UIAlertView alloc]
                      initWithTitle: @"Success!"
                      message:@"Your username has been created successfully!"
                      delegate: self
                      cancelButtonTitle: @"Ok"
                      otherButtonTitles: nil];
       [alertDialog show];
       
       NSString* usernameLowercase = [self.usernameTextField.text lowercaseString];
       [WSHelper setUserName:usernameLowercase]; //set username in userdefaults
       
    } else {
        NSLog(@"already exists");
         UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Username already taken, try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show];
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"nsurl error is %@", error.localizedDescription);
    NSString* errorMsg = error.localizedDescription;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:errorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView.title
         isEqualToString: @"Success!"]) {
        [self dismissViewControllerAnimated:YES completion:^{
        
            NSString* firstLoadMessage = @"Welcome to reelGood! \nOnce you add a friend a list of movies your friend's rated will be shown here\nYou can rate moves by clicking the search button\nA list of movies you rated is listed in your profile\nAdd a friend to get started!";
            
            UIAlertView *alertDialog;
            alertDialog = [[UIAlertView alloc]
                           initWithTitle: @"Welcome!"
                           message:firstLoadMessage
                           delegate: nil
                           cancelButtonTitle: @"OK"
                           otherButtonTitles: nil];
            [alertDialog show];
        }];
    }
}

@end
