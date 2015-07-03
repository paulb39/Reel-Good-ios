//
//  infoViewController.m
//  ReelGood
//
//  Created by Paul Brenner on 1/10/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "infoViewController.h"
#import "searchViewController.h"
#import "ViewController.h"
#import "WSHelper.h"
#import <ILMovieDBClient.h>

@interface infoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseLabel;
@property (weak, nonatomic) IBOutlet UITextView *overviewBox;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;
@property (weak, nonatomic) IBOutlet UIWebView *ratingWebView;
@property (weak, nonatomic) IBOutlet UITableView *friendInfoWebView;
@property (weak, nonatomic) IBOutlet UIWebView *modifyWebView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
- (IBAction)goBackButton:(id)sender;
- (IBAction)saveRating:(id)sender;
- (IBAction)hideKey:(id)sender;


@end

@implementation infoViewController

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
    
    [ILMovieDBClient sharedClient].apiKey = @"beea29b97e50a0194d538ddace065f95"; // view did apear instead?
    
    NSUserDefaults *settings = [NSUserDefaults new]; // get info from userDefaults
    
    title_of_movie = [settings stringForKey:kmovieTitle];
    ID_of_movie = [settings stringForKey:kmovieID];
    currentUser = [settings stringForKey:kcurrentUser];
    poster_of_movie = [settings stringForKey:kmoviePoster];
    
    //NSLog(@"poster is %@", poster_of_movie);
    
    
    friendInfoFriend = [[NSMutableArray alloc] init];
    friendInfoMovieRating = [[NSMutableArray alloc] init];
    friendInfoMovieTitle = [[NSMutableArray alloc] init];
    friendInfoComments = [[NSMutableArray alloc] init];
    friendInfoMovieID = [[NSMutableArray alloc] init];
    
    self.titleLabel.text = title_of_movie;
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:poster_of_movie]]]; // put posters in iamgeview
    
    self.posterImageView.image=image;
    
    /*UIBezierPath * imgRect = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 100)];
    self.overviewBox.textContainer.exclusionPaths = @[imgRect]; //wrap text?*/
    ////NSLog(@"test %@ %@ %@ %@", title_of_movie, releasedate_of_movie, ID_of_movie, currentUser);
    //releasedate_of_movie = [settings stringForKey:kreleaseDate]; // not neeed, keeping just in case
    //self.releaseLabel.text = releasedate_of_movie;
    
    [self getMovieDescription]; // and release date
    [self getFriendMovieInfo];
    
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
    return [friendInfoMovieTitle count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.friendInfoWebView dequeueReusableCellWithIdentifier:@"friendRatingProto"];
    
    cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"Gradient.png"]];
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.6;
    //cell.detailTextLabel.minimumScaleFactor = 0.6;
    //cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    //[cell.detailTextLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    
    cell.textLabel.text = [friendInfoFriend objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [friendInfoMovieRating objectAtIndex:indexPath.row];
    
    UIImage* image = [UIImage imageNamed:@"StarPressed.png"]; // set star image to right side
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[image stretchableImageWithLeftCapWidth:1.0 topCapHeight:1.0]];
    [imageView setContentMode: UIViewContentModeScaleAspectFit];
    [imageView setFrame:CGRectMake(0.0, 0.0, 60, 44)];
    cell.accessoryView = imageView;

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tempComments = [friendInfoComments objectAtIndex:indexPath.row];
    NSString *tempUser = [friendInfoFriend objectAtIndex:indexPath.row];
    NSString *tempMovie = [friendInfoMovieTitle objectAtIndex:indexPath.row];
    
    NSString* alertString =[NSString stringWithFormat:
                            @"%@'s comments for the movie %@"
                            ,tempUser, tempMovie];
    
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]
                   initWithTitle: alertString
                   message:tempComments
                   delegate: nil
                   cancelButtonTitle: @"OK"
                   otherButtonTitles: nil];
    [alertDialog show];
}


- (void) getMovieDescription{
    NSDictionary *PARAMS = @{@"id": ID_of_movie}; // need to do search by ID to get overview
    [[ILMovieDBClient sharedClient] GET:kILMovieDBMovie parameters:PARAMS block:^(id ResponseObject, NSError *Error){
        if (!Error) {
            overview_of_movie = ResponseObject[@"overview"];
            releasedate_of_movie = ResponseObject[@"release_date"];
            
            self.overviewBox.text = overview_of_movie;
            
            NSString* dateString;
            NSDate* movieDate;

            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.timeStyle = NSDateFormatterNoStyle;
            [df setDateFormat:@"yyyy-MM-dd"];
            movieDate = [df dateFromString: releasedate_of_movie]; // convert string to nsdate

            dateString = [NSDateFormatter localizedStringFromDate:movieDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle]; // convert nsdate back to string in correct format
            
            self.releaseLabel.text = dateString;
            [self setFontColor];
        }
        else{
            //NSLog(@"Error: %@", Error.localizedDescription); // change to alertview?
        }
    }];
}

- (IBAction)goBackButton:(id)sender {
[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveRating:(id)sender {
    [self performSegueWithIdentifier:@"toRateMovie" sender:self]; // for star debug
    /*
    pushRatingCalled = NO; // for webviewdidfinishloading logic, not needed?
    
    [self pushMovieInfo]; // if movie is not in database, add it
    
    //ADD IF fields are empty
    if (alreadyRatedMovie == NO){
        [self pushRatingInfo]; //insert user's rating
    }
    else {
        [self pushRatingInfoModify]; // modify user's rating
    }
    */
}

- (IBAction)hideKey:(id)sender {
   // [self.ratingBox resignFirstResponder];
    //[self.commentsBox resignFirstResponder];
    //NSLog(@"test");
}

- (void) setFontColor {
    //[inkTextField setTextColor:[UIColor greenColor]];
    //inkTextField.text=@"text";
    self.overviewBox.textColor = [UIColor whiteColor];
}


- (void) getFriendMovieInfo{
    
    NSError *friendMovieDataError;
    NSString *friendMovieDetailURLString;
    
    friendMovieDetailURLString=[NSString stringWithFormat:
                           @"http://www.brennerbrothersbrewery.com/phpdata/reelgood/mainData.php?username=%@"
                           ,[WSHelper getCurrentUser]];
    
    NSData *friendMovieDataPHP = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:friendMovieDetailURLString]];
    
    NSArray *friendMovieDataJSON = [NSJSONSerialization
                               JSONObjectWithData:friendMovieDataPHP
                               options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                               error:&friendMovieDataError];
    
    friendMovieDataCounter= 0;
    
    
    if (friendMovieDataError)
    {
        //NSLog(@"%@", [friendMovieDataError localizedDescription]);
    }
    else {
        for ( NSDictionary *theFriendMovieInfo in friendMovieDataJSON )
        {
            NSString* tempString = theFriendMovieInfo[@"movie_id"];
            if ([tempString isEqualToString:ID_of_movie]){
                friendInfoMovieTitle[friendMovieDataCounter] = theFriendMovieInfo[@"title"];
                friendInfoFriend[friendMovieDataCounter] = theFriendMovieInfo[@"fr_acc"];
                friendInfoMovieRating[friendMovieDataCounter] = theFriendMovieInfo[@"rating"];
                friendInfoComments[friendMovieDataCounter] = theFriendMovieInfo[@"comments"];
            
                friendInfoMovieID[friendMovieDataCounter] = theFriendMovieInfo[@"movie_id"];
                //NSLog(@"tesst1");
                friendMovieDataCounter++;
            }

        }
    }
    
    //NSLog(@"friend is THIS %@", friendInfoMovieID);
    
    [self.friendInfoWebView reloadData];
}


@end
