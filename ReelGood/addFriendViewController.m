//
//  addFriendViewController.m
//  ReelGood
//
//  Created by Paul Brenner on 1/14/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "addFriendViewController.h"
#import "ViewController.h"

@interface addFriendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *friendTextField;
- (IBAction)friendGoBack:(id)sender;
- (IBAction)saveFriendButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *friendWebView;
@property (weak, nonatomic) IBOutlet UIWebView *otherFriendWebView;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)sendInvite:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;
@property (weak, nonatomic) IBOutlet UIWebView *removeFriendWebView;

@end

@implementation addFriendViewController

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
    self.friendsTableView.allowsMultipleSelectionDuringEditing = NO; // for deleting from tableview
    
    arrayOfFriends = [[NSMutableArray alloc] init];
    
    NSUserDefaults *settings = [NSUserDefaults new]; // get info from userDefaults
    currentLoggedInUser  = [settings stringForKey:kcurrentUser];
    
    [self getFriendInfo];
    
    NSLog(@"friend friend is %@", arrayOfFriends);
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

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
    return [arrayOfFriends count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.friendsTableView dequeueReusableCellWithIdentifier:@"friendProto"];
    
    cell.textLabel.text = [arrayOfFriends objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Gradient.png"]];
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteFriend:[arrayOfFriends objectAtIndex:indexPath.row] sender:nil];
        
        [arrayOfFriends removeObjectAtIndex:indexPath.row];
        
        [self.friendsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (IBAction)friendGoBack:(id)sender {
[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveFriendButton:(id)sender {
    fieldIsEmpty = NO;
    friendUserName = self.friendTextField.text;
    NSString *lowercaseFriend = [friendUserName lowercaseString];
    
    if (self.friendTextField.text.length == 0){ // check if field is empty
        fieldIsEmpty = YES;
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Enter a username first!"
                       message:@"Please enter a username before hitting the button"
                       delegate: nil
                       cancelButtonTitle: @"OK"
                       otherButtonTitles: nil];
        [alertDialog show];
    }
    
    if (fieldIsEmpty == NO) {
        if ([self checkForUsernameExists:lowercaseFriend sender:nil]){ //check if friend username exists
            friendExists = YES;
        }
        else{
            friendExists = NO;
            NSLog(@"NEED TO SEND EMAIL");
            
            UIAlertView *alertDialog;
            alertDialog = [[UIAlertView alloc]
                           initWithTitle: @"Invite your friend"
                           message:@"User name does not exist, you should send them a message asking them to create an account"
                           delegate: self
                           cancelButtonTitle: @"Cancel"
                           otherButtonTitles: @"Email", @"Text", nil];
            [alertDialog show];
        }
    }
    
    NSURL *friendDetailURL;
	NSString *friendDetailURLString;
    
    NSString *otherFriendDetailURLString;
    NSURL * otherFriendDetailURL;

	
	friendDetailURLString=[NSString stringWithFormat:
                     @"http://148.166.200.55/brennerp/phptest/data/pushfrienddata.php?username=%@&friend=%@"
                     ,currentLoggedInUser,lowercaseFriend];
    
	friendDetailURL=[[NSURL alloc] initWithString:friendDetailURLString];
    
    otherFriendDetailURLString=[NSString stringWithFormat:
                           @"http://148.166.200.55/brennerp/phptest/data/pushfrienddata.php?username=%@&friend=%@"
                           ,lowercaseFriend, currentLoggedInUser];
    
	otherFriendDetailURL=[[NSURL alloc] initWithString:otherFriendDetailURLString];
    
    
    NSLog(@"fieldisempty and friend exists %d, %d", fieldIsEmpty, friendExists);
   
    if (fieldIsEmpty == NO && friendExists == YES){ // if not empty and friend username exists, push to database
        NSUserDefaults* settings = [NSUserDefaults new];
        [settings setObject:@"1" forKey:kaddedOrRemovedFriend]; // only reload main page if needed
        [settings synchronize];
        
        [self.friendWebView loadRequest:[NSURLRequest requestWithURL:friendDetailURL]]; // send website to view, which will send data and add friend -person 1 is now friends with person 2
        self.friendWebView.delegate = self;
        
        [self.otherFriendWebView loadRequest:[NSURLRequest requestWithURL:otherFriendDetailURL]]; // send website to view, which will send data and add friend - person 2 -> person 1
        self.otherFriendWebView.delegate = self;
        NSLog(@"friend added");
    }
}

- (BOOL)checkForUsernameExists:(NSString *)nameOfUser sender:(id)sender{

    for (j = 0; j<[userNames count]; j++) //check if username already exists
    {
        NSString* tempUsernameString = userNames[j];
        
        if ([nameOfUser isEqualToString:tempUsernameString]) //username exists
        {
            NSLog(@"USERNAME FOUND");
            return YES;
            break;
        }
    }
    return NO;
}


- (void) getFriendInfo{
    NSError *friendDataError;
    NSString *friendDetailURLString;
    
    friendDetailURLString=[NSString stringWithFormat:
                           @"http://148.166.200.55/brennerp/phptest/data/friendData.php?username=%@"
                           ,currentLoggedInUser];
    
    NSData *friendDataPHP = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:friendDetailURLString]];
    
    NSArray *friendDataJSON = [NSJSONSerialization
                               JSONObjectWithData:friendDataPHP
                               options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                               error:&friendDataError];
    friendCounter = 0;
    
    NSLog(@"JSON  is %@", friendDataJSON);
    
    if (friendDataError)
    {
        NSLog(@"%@", [friendDataError localizedDescription]);
    }
    else {
        for ( NSDictionary *theFriendInfo in friendDataJSON )
        {
            arrayOfFriends[friendCounter] = theFriendInfo[@"fr_acc"];
            friendCounter++;
        }
    }
    
    [self.friendsTableView reloadData];
}


- (void)deleteFriend:(NSString *)friendToRemove sender:(id)sender{
   
    NSLog(@"friend to remove is %@", friendToRemove);
    
    NSURL *detailURL;
    NSString *detailURLString;

    detailURLString=[NSString stringWithFormat:
                     @"http://148.166.200.55/brennerp/phptest/data/removeFriend.php?username=%@&friend=%@"
                     ,currentLoggedInUser,friendToRemove];
    
    detailURL=[[NSURL alloc] initWithString:detailURLString];
    
    NSLog(@"detail url is %@", detailURL);
    
    NSUserDefaults* settings = [NSUserDefaults new];
    [settings setObject:@"1" forKey:kaddedOrRemovedFriend]; // only reload main page if needed
    [settings synchronize];
    
    [self.removeFriendWebView loadRequest:[NSURLRequest requestWithURL:detailURL]]; // send website to view, which will delete friend
    self.removeFriendWebView.delegate = self;
}


-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString* finishedSuccessfullyMessage = @"New record created successfully";
    
    NSString* removeString = [self.removeFriendWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    
    NSLog(@"remove string is %@", removeString);

    if (webView == self.friendWebView){ // then check if was successful
        NSString* innerWebView = [self.friendWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        
        if ([innerWebView rangeOfString:finishedSuccessfullyMessage].location == NSNotFound){
            UIAlertView *alertDialog;
            alertDialog = [[UIAlertView alloc]
                           initWithTitle: @"Friend"
                           message:@"That user is already your friend!"
                           delegate: nil
                           cancelButtonTitle: @"OK"
                           otherButtonTitles: nil];
            [alertDialog show];
        }
        else{
            NSLog(@"string exists, adding rating was successful"); // change to alert view?
            UIAlertView *alertDialog;
            alertDialog = [[UIAlertView alloc]
                           initWithTitle: @"Added Friend"
                           message:@"Friend was successfully added"
                           delegate: nil
                           cancelButtonTitle: @"OK"
                           otherButtonTitles: nil];
            [alertDialog show];
            [self getFriendInfo];
            //[self.friendsTableView reloadData];
        }
        
        NSLog(@"inner: %@", innerWebView);
    }
    
}

-(void)sendEmail{
    NSString* messageString =[NSString stringWithFormat:
                                @"User %@ has requested you to create an account on reelGood"
                                ,currentLoggedInUser];
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:@"reelGood Account"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@" "]];
        [mailCont setMessageBody:messageString isHTML:NO];
        
        [self presentModalViewController:mailCont animated:YES];
    }
    else{
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Add Email"
                       message:@"You do not have capabilities to send mail, set up your inbox and try again"
                       delegate: nil
                       cancelButtonTitle: @"OK"
                       otherButtonTitles: nil];
        [alertDialog show];
    }
}

-(void)sendText {
    NSString* messageString = [NSString stringWithFormat:@"User %@ has requested you to create an account on reelGood", currentLoggedInUser];
    
    if([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.body = messageString;
        messageController.messageComposeDelegate = (id)self;
        [self presentViewController:messageController animated:YES completion:nil];
    } else {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Texting"
                       message:@"You do not have capabilities to send a text, set up your phone and try again"
                       delegate: nil
                       cancelButtonTitle: @"OK"
                       otherButtonTitles: nil];
        [alertDialog show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    NSString *buttonTitle=[alertView buttonTitleAtIndex:buttonIndex];
	
    if ([buttonTitle isEqualToString:@"Email"]) {
        [self sendEmail];
    } else if ([buttonTitle isEqualToString:@"Text"]) {
		[self sendText];
    }
    else {
        //cancel was clicked
    }
}


- (IBAction)hideKeyboard:(id)sender {
    [self.friendTextField resignFirstResponder];
}

- (IBAction)sendInvite:(id)sender {
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]
                   initWithTitle: @"Invite your friend"
                   message:@"Text or email your friend"
                   delegate: self
                   cancelButtonTitle: @"Cancel"
                   otherButtonTitles: @"Email", @"Text", nil];
    [alertDialog show];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)messageController didFinishWithResult:(MessageComposeResult)result {
    
    switch (result) {
        case MessageComposeResultCancelled:
            // User cancelled the message
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case MessageComposeResultSent:
            //User sent SMS
            [[[UIAlertView alloc] initWithTitle:@"Notice" message:@"Your message has been sent" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case MessageComposeResultFailed:
            //SMS failed to send
            [[[UIAlertView alloc] initWithTitle:@"Notice" message:@"Your message failed to send, try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            break;
    }
}

@end
