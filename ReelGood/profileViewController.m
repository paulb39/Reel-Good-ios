//
//  profileViewController.m
//  ReelGood
//
//  Created by Paul Brenner on 1/14/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "profileViewController.h"
#import "ViewController.h"
#import "searchViewController.h"
#import "profileCustomCell.h"
#import "WSHelper.h"

@interface profileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *profileWebView;
- (IBAction)profileGoBack:(id)sender;
- (IBAction)enableEditing:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *profileDataView;
@property (weak, nonatomic) IBOutlet UILabel *lblProfileTitle;

@end

@implementation profileViewController

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
    
    if (didProfileFirstLoad == YES){
        //[self getProfileInfo];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Updating...";
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self getProfileInfo];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString* userTitle = [NSString stringWithFormat:@"%@'s Profile", [WSHelper getCurrentUser]];
    self.lblProfileTitle.text = userTitle;
    self.lblProfileTitle.textColor = [UIColor whiteColor];
    
    self.profileWebView.allowsMultipleSelectionDuringEditing = NO; // for deleting from tableview
    NSUserDefaults *settings = [NSUserDefaults new]; // get info from userDefaults
    
    theCurrentUser = [settings stringForKey:kcurrentUser];
    
    profileMovieIDs = [[NSMutableArray alloc] init];
    profileMovieTitles = [[NSMutableArray alloc] init];
    profileMovieRating = [[NSMutableArray alloc] init];
    profileMoviePosters = [[NSMutableArray alloc] init];
    friendMoviePostersImage = [[NSMutableArray alloc] init];
    
    if (didProfileFirstLoad == NO){
       // [self getProfileInfo];
        didProfileFirstLoad = YES;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Updating...";
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self getProfileInfo];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
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
    return [profileMoviePosters count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteMovie:[profileMovieIDs objectAtIndex:indexPath.row] sender:nil];
        [profileMovieIDs removeObjectAtIndex:indexPath.row]; // remove from arrays
        [profileMoviePosters removeObjectAtIndex:indexPath.row];
        [self.profileWebView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    profileCustomCell *cell = [self.profileWebView dequeueReusableCellWithIdentifier:@"profileProto"];
    
    cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"Gradient.png"]];
    
    cell.titleLabel.adjustsFontSizeToFitWidth = YES;
    cell.titleLabel.minimumScaleFactor = 0.6;
    
    cell.titleLabel.text = [profileMovieTitles objectAtIndex:indexPath.row];
    cell.ratingLabel.text = [profileMovieRating objectAtIndex:indexPath.row];
 
    //image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[profileMoviePosters objectAtIndex:indexPath.row]]]]; // put posters in tableview
    cell.posterView.image = [friendMoviePostersImage objectAtIndex:indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tempTitle = [profileMovieTitles objectAtIndex:indexPath.row];
    NSString *tempID = [profileMovieIDs objectAtIndex:indexPath.row];
    NSString *tempPoster = [profileMoviePosters objectAtIndex:indexPath.row];
    
    NSUserDefaults *settings = [NSUserDefaults new];
    [settings setObject:tempTitle forKey:kmovieTitle];
    [settings setObject:tempID forKey:kmovieID];
    [settings setObject:tempPoster forKey:kmoviePoster];
    [settings synchronize];
    
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]
                   initWithTitle: @"Rate or View Info"
                   message:@"What do you want to do?"
                   delegate: self
                   cancelButtonTitle: @"Cancel"
                   otherButtonTitles: @"View Movie info", @"Update Rating", nil];
    [alertDialog show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    NSString *buttonTitle=[alertView buttonTitleAtIndex:buttonIndex];
	
    if ([buttonTitle isEqualToString:@"View Movie info"]) {
        [self performSegueWithIdentifier:@"toInfoFromProfile" sender:self];
    } else if ([buttonTitle isEqualToString:@"Update Rating"]) {
		[self performSegueWithIdentifier:@"toUpdateRating" sender:self];
    }
    else {
        //cancel was clicked
    }
}




- (void) getProfileInfo{
    
    NSError *profileDataError;
    NSString *profileDetailURLString;
    
    profileDetailURLString=[NSString stringWithFormat:
                            @"http://www.brennerbrothersbrewery.com/phpdata/reelgood/profileData.php?username=%@"
                            ,[WSHelper getCurrentUser]];
    
    NSData *profileDataPHP = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:profileDetailURLString]];
    
    NSArray *profileDataJSON = [NSJSONSerialization
                         JSONObjectWithData:profileDataPHP
                         options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                         error:&profileDataError];
    
    profileCounter = 0;
    
    if (profileDataError)
    {
        //NSLog(@"%@", [profileDataError localizedDescription]);
    }
    else {
        for ( NSDictionary *theProfileInfo in profileDataJSON )
        {
            profileMovieTitles[profileCounter] = theProfileInfo[@"title"];
            profileMovieRating[profileCounter] = theProfileInfo[@"rating"];
            profileMovieIDs[profileCounter] = theProfileInfo[@"movie_id"];
            profileCounter++;
        }
  }
    
    //NSLog(@"tesst");
    profileCounter=0;
    //NSLog(@"IDS %@", profileMovieIDs);
    
    //
     NSString* apiKey = @"beea29b97e50a0194d538ddace065f95";
    
    for (int g=0;g<[profileMovieIDs count];g++) {
       
        profileDetailURLString = [NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%@?api_key=%@",profileMovieIDs[profileCounter], apiKey];
        
        profileDataPHP = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:profileDetailURLString]];
        
        NSDictionary* profileJSON = [NSJSONSerialization JSONObjectWithData:profileDataPHP options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&profileDataError];
        
        if (profileDataError) {
            //NSLog(@"%@", [profileDataError localizedDescription]);
        }
        else {
            if (profileJSON[@"poster_path"] == (id)[NSNull null]) {
              profileMoviePosters[profileCounter] = @"https://d3a8mw37cqal2z.cloudfront.net/assets/f996aa2014d2ffddfda8463c479898a3/images/no-poster-w185.jpg"; // default poster
                UIImage* tempI = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://d3a8mw37cqal2z.cloudfront.net/assets/f996aa2014d2ffddfda8463c479898a3/images/no-poster-w185.jpg"]]];
                friendMoviePostersImage[profileCounter] = tempI;
            
            }
            else {
                NSString* tempAddress = profileJSON[@"poster_path"];
                NSString* posterTemp = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w154%@",tempAddress];
                profileMoviePosters[profileCounter] = posterTemp;
                UIImage* tempI = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:posterTemp]]];
                friendMoviePostersImage[profileCounter] = tempI;
                
            }
            profileCounter++;
        }
        
    } //end for
    
    //NSLog(@"posters %@", profileMoviePosters);
    
    [self.profileWebView reloadData];
}



- (void)deleteMovie:(NSString *)movieToRemove sender:(id)sender{
    NSString* detailedURLString;
    NSURL* detailedURL;
    
    detailedURLString=[NSString stringWithFormat:
                       @"http://www.brennerbrothersbrewery.com/phpdata/reelgood/removeMovie.php?username=%@&movieID=%@"
                       ,[WSHelper getCurrentUser], movieToRemove];
    
    
    detailedURL=[[NSURL alloc] initWithString:detailedURLString];
    
    ////NSLog(@"detailed URl is: %@", detailedURL);
    
    [self.profileDataView loadRequest:[NSURLRequest requestWithURL:detailedURL]]; // send website to view, which will create info in database
    self.profileDataView.delegate = self;
}



/*
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
 //NSLog(@"%@", [dataError localizedDescription]);
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
 
 [self.mainWebView reloadData]; //update tableview
 }
 */

- (IBAction)profileGoBack:(id)sender {
[self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)enableEditing:(id)sender {
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [self.profileWebView setEditing:NO animated:YES];
        [sender setTitle:@"Delete" forState:UIControlStateNormal];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.profileWebView setEditing:YES animated:YES];
        [sender setTitle:@"Done" forState:UIControlStateNormal];
    }

}
@end
