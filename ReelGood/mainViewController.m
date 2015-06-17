//
//  mainViewController.m
//  ReelGood
//
//  Created by Paul Brenner on 1/19/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "mainViewController.h"
#import "ViewController.h"
#import "CustomCell.h"
#import <ILMovieDBClient.h>
#import "WSHelper.h"

@interface mainViewController ()
- (IBAction)logOutButton:(id)sender;
- (IBAction)goToMyProfile:(id)sender;
- (IBAction)addFriendButton:(id)sender;
- (IBAction)goToSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *mainWebView;
- (IBAction)GoToAbout:(id)sender;


@end

@implementation mainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [ILMovieDBClient sharedClient].apiKey = @"beea29b97e50a0194d538ddace065f95";
    
    NSUserDefaults *settings = [NSUserDefaults new];
    NSString* addedOrRemovedFriend = [settings stringForKey:kaddedOrRemovedFriend]; //Using a NSNOTIFICATION is a much better idea!
    
    
    //if userdefaults username is nil
    //get username for facebook ID,
    //if returned username is nil. do segue to create username
    // else facebook account has a username, set username in userdefaults
    
    if ([WSHelper getCurrentUser] == nil) {
        NSString* userNameForID = [WSHelper getUserNameFromServer:@"9asdaadsad"];
        NSLog(@"usernameforid is %@", userNameForID);
        
        if (userNameForID == nil) {
            NSLog(@"DOING THE SEGUE TO CREATE A USERNAME"); // will set userdefaults there
            [self performSegueWithIdentifier: @"toCreateUsername" sender: self];
        } else {
            [WSHelper setUserName:userNameForID];
        }
    }
    //
    
    
    if (didFirstLoad == YES){
        
        if (addedOrRemovedFriend == NULL || [addedOrRemovedFriend isEqualToString:@"1"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Updating...";
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self getFriendInfo];
                [self getPosterPaths];
                [self.mainWebView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
            [self.mainWebView scrollRectToVisible:CGRectMake(0, self.mainWebView.contentSize.height - self.mainWebView.bounds.size.height, self.mainWebView.bounds.size.width, self.mainWebView.bounds.size.height) animated:YES]; // scroll to bottom
            [self.mainWebView setContentOffset:CGPointZero animated:YES]; // scroll to top - scrolling is neeed to update posters
            [settings setObject:@"0" forKey:kaddedOrRemovedFriend]; // reset if need to reload tableview
            [settings synchronize];
        }

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    didFirstLoad = NO;
    
    NSUserDefaults *settings = [NSUserDefaults new]; // get info from userDefaults
    
    userCurrent = [settings stringForKey:kcurrentUser];
    
    friendMovieTitles = [[NSMutableArray alloc] init];
    friendMovieRating = [[NSMutableArray alloc] init];
    friendFriend = [[NSMutableArray alloc] init];
    friendMovieComments = [[NSMutableArray alloc] init];
    friendMovieIDs = [[NSMutableArray alloc] init];
    
    friendMoviePosters = [[NSMutableArray alloc] init];
    
    image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://d3a8mw37cqal2z.cloudfront.net/assets/f996aa2014d2ffddfda8463c479898a3/images/no-poster-w185.jpg"]]]; // default poster
    
    //firstUserLoad = [settings stringForKey:kNewUserr];
    //NSLog(@"knewuser is %@", firstUserLoad);
    
    firstUserLoad = [settings stringForKey:kInstructions];
    NSLog(@"first instructions are %@", firstUserLoad);
    
    /* not needed, done in dismiss view controller via a block
    if (firstUserLoad == NULL && [WSHelper getCurrentUser] != nil){ // tell user how to use app
        NSString* firstLoadMessage = @"Welcome to reelGood! \nOnce you add a friend a list of movies your friend's rated will be shown here\nYou can rate moves by clicking the search button\nA list of movies you rated is listed in your profile\nAdd a friend to get started!";
        
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Welcome!"
                       message:firstLoadMessage
                       delegate: nil
                       cancelButtonTitle: @"OK"
                       otherButtonTitles: nil];
        [alertDialog show];
        
        [settings setObject:@"YES" forKey:kInstructions];
        [settings synchronize];
    } */
    
    NSLog(@"did first load is %d", didFirstLoad);
    
    if (didFirstLoad == NO){
        didFirstLoad = YES;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // show loading screen
        hud.labelText = @"Updating...";
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self getFriendInfo];
            [self getPosterPaths];
            [self.mainWebView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        NSLog(@"did first load2 is %d", didFirstLoad);
        
    }
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
    return [friendMoviePosters count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [self.mainWebView dequeueReusableCellWithIdentifier:@"mainProto"];
    
    
    cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"Gradient.png"]];
    
    cell.friendMovieLabel.adjustsFontSizeToFitWidth = YES;
    cell.friendMovieLabel.minimumScaleFactor = 0.6;
    cell.friendNameLabel.adjustsFontSizeToFitWidth = YES;
    cell.friendNameLabel.minimumScaleFactor = 0.6;
    cell.friendScore.adjustsFontSizeToFitWidth = YES;
    cell.friendScore.minimumScaleFactor = 0.6;
    
    
    cell.friendMovieLabel.text = [friendMovieTitles objectAtIndex:indexPath.row];
    cell.friendNameLabel.text = [friendFriend objectAtIndex:indexPath.row];
    cell.friendScore.text = [friendMovieRating objectAtIndex:indexPath.row];
    
    
    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[friendMoviePosters objectAtIndex:indexPath.row]]]]; // put posters in tableview
    cell.posterCellImage.image = image;
    
    //NSLog(@"cell posters are %@", friendMoviePosters);
   
    return cell;
    
}

- (void) getFriendInfo{
    [friendMoviePosters removeAllObjects];
    [friendMovieIDs removeAllObjects]; // for updating table if deleting friends
    
    //NSLog(@"updated posters are %@", friendMoviePosters);
    
    NSError *friendDataError;
    NSString *friendDetailURLString;
    
    friendDetailURLString=[NSString stringWithFormat:
                            @"http://148.166.200.55/brennerp/phptest/data/mainData.php?username=%@"
                            ,userCurrent];
    
    NSData *friendDataPHP = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:friendDetailURLString]];
    
    NSArray *friendDataJSON = [NSJSONSerialization
                                JSONObjectWithData:friendDataPHP
                                options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                                error:&friendDataError];
    mainCounter = 0;
    //posterCount = 0; // needed?
    
    
    if (friendDataError)
    {
        NSLog(@"%@", [friendDataError localizedDescription]);
    }
    else {
        for ( NSDictionary *theFriendInfo in friendDataJSON )
        {
            friendMovieTitles[mainCounter] = theFriendInfo[@"title"];
            friendFriend[mainCounter] = theFriendInfo[@"fr_acc"];
            friendMovieRating[mainCounter] = theFriendInfo[@"rating"];
            friendMovieComments[mainCounter] = theFriendInfo[@"comments"];
            friendMovieIDs[mainCounter] = theFriendInfo[@"movie_id"];
            mainCounter++;
        }
    }
    
   // NSLog(@"ID IS %@", friendMovieIDs);
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tempComments = [friendMovieComments objectAtIndex:indexPath.row];
    NSString *tempUser = [friendFriend objectAtIndex:indexPath.row];
    tempPosters = [friendMoviePosters objectAtIndex:indexPath.row];
    tempMovie = [friendMovieTitles objectAtIndex:indexPath.row];
    tempID = [friendMovieIDs objectAtIndex:indexPath.row];
    
    NSString* alertString =[NSString stringWithFormat:
                              @"%@'s comments for the movie %@"
                              ,tempUser, tempMovie];
    
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]
                   initWithTitle: alertString
                   message:tempComments
                   delegate: self
                   cancelButtonTitle: @"Cancel"
                   otherButtonTitles: @"View Movie info", @"Rate Movie", nil];
    [alertDialog show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    NSString *buttonTitle=[alertView buttonTitleAtIndex:buttonIndex];
   
    NSUserDefaults *settings = [NSUserDefaults new];
    [settings setObject:tempID forKey:kmovieID];
    [settings setObject:tempMovie forKey:kmovieTitle];
    [settings setObject:tempPosters forKey:kmoviePoster];
    [settings synchronize];
	
    if ([buttonTitle isEqualToString:@"View Movie info"]) {
        [self performSegueWithIdentifier:@"toMovieInfo" sender:self];
    } else if ([buttonTitle isEqualToString:@"Rate Movie"]) {
		[self performSegueWithIdentifier:@"ToRateMovie" sender:self];
    }
    else {
        //cancel was clicked
    }
}

- (void)getPosterPaths {
    
    NSError *dataError;
    NSString *detailURLString;
    NSString* apiKey = @"beea29b97e50a0194d538ddace065f95";
    posterCount = 0;
    
    for (int h = 0; h < [friendMovieIDs count]; h++) {
    detailURLString=[NSString stringWithFormat:
                     @"http://api.themoviedb.org/3/movie/%@?api_key=%@"
                     ,friendMovieIDs[posterCount],apiKey];
    
    
    NSData *dataAPI = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:detailURLString]];
    
    NSDictionary *apiJSON = [NSJSONSerialization
                             JSONObjectWithData:dataAPI
                             options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                             error:&dataError];

    if (dataError)
    {
        NSLog(@"%@", [dataError localizedDescription]);
    }
    else {
        if (apiJSON[@"poster_path"] == (id)[NSNull null]) {
            friendMoviePosters[posterCount] = @"https://d3a8mw37cqal2z.cloudfront.net/assets/f996aa2014d2ffddfda8463c479898a3/images/no-poster-w185.jpg"; // default poster
        }
        else {
            NSString* tempAddress = apiJSON[@"poster_path"];
            NSString* posterTemp = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w154%@",tempAddress];
            friendMoviePosters[posterCount] = posterTemp;
        }
        
        posterCount++;
    }
} // end for
  //  NSLog(@"check posters are %@", friendMoviePosters);
    //[self.mainWebView reloadData]; //update tableview // needed?
}




- (IBAction)logOutButton:(id)sender {
    NSUserDefaults *settings = [NSUserDefaults new]; // get info from userDefaults
    [settings setObject:@"1" forKey:kaddedOrRemovedFriend]; // only reload main page if needed
    [settings setObject:@"1" forKey:ksegueFromMain];
    [settings synchronize];
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    
    [[WSHelper getDefaults] setObject:nil forKey:PREFERENCE_KEY_USERNAME];
    
    [self performSegueWithIdentifier:@"toLogOut" sender:self];
}

- (IBAction)goToMyProfile:(id)sender {
    [self performSegueWithIdentifier:@"toProfile" sender:self];
}

- (IBAction)addFriendButton:(id)sender {
    [self performSegueWithIdentifier:@"toFriend" sender:self];
}

- (IBAction)goToSearch:(id)sender {
    [self performSegueWithIdentifier:@"toSearch" sender:self];
}

- (IBAction)GoToAbout:(id)sender {
    [self performSegueWithIdentifier:@"toAboutFromMain" sender:self];
}
@end
