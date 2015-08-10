//
//  rateViewController.m
//  ReelGood
//
//  Created by Paul Brenner on 1/31/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "rateViewController.h"
#import "ViewController.h"
#import "searchViewController.h"
#import "WSHelper.h"

@interface rateViewController ()
- (IBAction)saveButton:(id)sender;
- (IBAction)starRatingOne:(id)sender;
- (IBAction)starRatingTwo:(id)sender;
- (IBAction)starRatingThree:(id)sender;
- (IBAction)starRatingFour:(id)sender;
- (IBAction)starRatingFive:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)fbShareTap:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *ratingCommentsBox;
@property (weak, nonatomic) IBOutlet UIButton *starOne;
@property (weak, nonatomic) IBOutlet UIButton *starThree;
@property (weak, nonatomic) IBOutlet UIButton *starFour;
@property (weak, nonatomic) IBOutlet UIButton *starFive;
@property (weak, nonatomic) IBOutlet UIButton *starTwo;
@property (weak, nonatomic) IBOutlet UIWebView *friendInfoWebView;
@property (weak, nonatomic) IBOutlet UIWebView *modifyWebView;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;
@property (weak, nonatomic) IBOutlet UILabel *lblRating;
@property (weak, nonatomic) IBOutlet UILabel *lblFBShare;
@property (weak, nonatomic) IBOutlet UIButton *fbShareOutlet;

@end

@implementation rateViewController

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
    
    NSUserDefaults *settings = [NSUserDefaults new]; // get info from userDefaults
    
    self.lblFBShare.hidden = YES;
    self.fbShareOutlet.hidden = YES;
    
    title_of_movie = [settings stringForKey:kmovieTitle];
    ID_of_movie = [settings stringForKey:kmovieID];
    currentUser = [settings stringForKey:kcurrentUser];
    
   [self checkIfAlreadyRated]; // check if user has already rated the movie

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

- (IBAction)saveButton:(id)sender {
    
    [self pushMovieInfo]; // if movie is not in database, add it
    
    //NSLog(@"rating is %@", userRating);
    
    //ADD IF fields are empty
    if (alreadyRatedMovie == NO){
        [self pushRatingInfo]; //insert user's rating
    }
    else {
        [self pushRatingInfoModify]; // modify user's rating
    }
    
}

- (IBAction)starRatingOne:(id)sender {
    [self setRatingToOne];
}

- (IBAction)starRatingTwo:(id)sender {
    [self setRatingToTwo];
}

- (IBAction)starRatingThree:(id)sender {
    [self setRatingToThree];
}

- (IBAction)starRatingFour:(id)sender {
    [self setRatingToFour];
}

- (IBAction)starRatingFive:(id)sender {
    [self setRatingToFive];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.ratingCommentsBox resignFirstResponder];
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)fbShareTap:(id)sender {
    NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
    
    NSString* poster_of_movie = [settings stringForKey:kmoviePoster];
    NSString* contentInfo = [[NSString alloc] initWithFormat:@"%@ %@ stars!", self.ratingCommentsBox.text, userRating];
    NSString* contentTitle = [[NSString alloc] initWithFormat:@"%@ Review",title_of_movie];
    
    NSURL* urlTest = [[NSURL alloc] initWithString:poster_of_movie];
    
    FBSDKShareLinkContent *shareContent = [[FBSDKShareLinkContent alloc] init];
    shareContent.contentTitle = contentTitle;
    shareContent.contentDescription = contentInfo;
    shareContent.contentURL = urlTest;
    
     FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
     dialog.fromViewController = self;
     dialog.shareContent = shareContent;
     dialog.mode = FBSDKShareDialogModeAutomatic;
     [dialog show];
}

-(void)setRatingToOne{
    userRating = @"1";
    [self.starOne setBackgroundImage:[UIImage imageNamed:@"StarPressed.png"] forState:UIControlStateNormal];
    [self.starTwo setBackgroundImage:[UIImage imageNamed:@"Star.png"] forState:UIControlStateNormal];
    [self.starThree setBackgroundImage:[UIImage imageNamed:@"Star.png"] forState:UIControlStateNormal];
    [self.starFour setBackgroundImage:[UIImage imageNamed:@"Star.png"] forState:UIControlStateNormal];
    [self.starFive setBackgroundImage:[UIImage imageNamed:@"Star.png"] forState:UIControlStateNormal];
}

-(void)setRatingToTwo{
    userRating = @"2";
    [self.starOne setBackgroundImage:[UIImage imageNamed:@"StarPressed.png"] forState:UIControlStateNormal];
    [self.starTwo setBackgroundImage:[UIImage imageNamed:@"StarPressed.png"] forState:UIControlStateNormal];
    [self.starThree setBackgroundImage:[UIImage imageNamed:@"Star.png"] forState:UIControlStateNormal];
    [self.starFour setBackgroundImage:[UIImage imageNamed:@"Star.png"] forState:UIControlStateNormal];
    [self.starFive setBackgroundImage:[UIImage imageNamed:@"Star.png"] forState:UIControlStateNormal];
}

-(void)setRatingToThree{
    userRating = @"3";
    [self.starOne setBackgroundImage:[UIImage imageNamed:@"StarPressed.png"] forState:UIControlStateNormal];
    [self.starTwo setBackgroundImage:[UIImage imageNamed:@"StarPressed.png"] forState:UIControlStateNormal];
    [self.starThree setBackgroundImage:[UIImage imageNamed:@"StarPressed.png"] forState:UIControlStateNormal];
    [self.starFour setBackgroundImage:[UIImage imageNamed:@"Star.png"] forState:UIControlStateNormal];
    [self.starFive setBackgroundImage:[UIImage imageNamed:@"Star.png"] forState:UIControlStateNormal];
}

-(void)setRatingToFour{
    userRating = @"4";
    [self.starOne setBackgroundImage:[UIImage imageNamed:@"StarPressed.png"] forState:UIControlStateNormal];
    [self.starTwo setBackgroundImage:[UIImage imageNamed:@"StarPressed.png"] forState:UIControlStateNormal];
    [self.starThree setBackgroundImage:[UIImage imageNamed:@"StarPressed.png"] forState:UIControlStateNormal];
    [self.starFour setBackgroundImage:[UIImage imageNamed:@"StarPressed.png"] forState:UIControlStateNormal];
    [self.starFive setBackgroundImage:[UIImage imageNamed:@"Star.png"] forState:UIControlStateNormal];
}

-(void)setRatingToFive{
    userRating = @"5";
    [self.starOne setBackgroundImage:[UIImage imageNamed:@"StarPressed.png"] forState:UIControlStateNormal];
    [self.starTwo setBackgroundImage:[UIImage imageNamed:@"StarPressed.png"] forState:UIControlStateNormal];
    [self.starThree setBackgroundImage:[UIImage imageNamed:@"StarPressed.png"] forState:UIControlStateNormal];
    [self.starFour setBackgroundImage:[UIImage imageNamed:@"StarPressed.png"] forState:UIControlStateNormal];
    [self.starFive setBackgroundImage:[UIImage imageNamed:@"StarPressed.png"] forState:UIControlStateNormal];
}

- (void) checkIfAlreadyRated { // if movie is already rated by user, need to MODIFY the rating, instead of INSERT
    
    NSError *alreadyDataError;
    NSString *alreadyMovieDetailURLString;
    
    alreadyMovieDetailURLString=[NSString stringWithFormat:
                                 @"http://www.brennerbrothersbrewery.com/phpdata/reelgood/checkifalreadyrated.php?username=%@&movieid=%@"
                                 ,[WSHelper getCurrentUser], ID_of_movie];
    
    NSData *alreadyMovieDataPHP = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:alreadyMovieDetailURLString]];
    
    NSArray *alreadyMovieDataJSON = [NSJSONSerialization
                                     JSONObjectWithData:alreadyMovieDataPHP
                                     options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                                     error:&alreadyDataError];
    
    NSString* tempString = @"empty";
    alreadyRatedMovie = NO;
    
    
    if (alreadyDataError)
    {
        //NSLog(@"%@", [alreadyDataError localizedDescription]);
    }
    else {
        for ( NSDictionary *alreadyInfo in alreadyMovieDataJSON )
        {
            tempString = alreadyInfo[@"title"];
            userRating = alreadyInfo[@"rating"];
            userComments = alreadyInfo[@"comments"];
        }
        
        if ([tempString isEqualToString:@"empty"]){
            alreadyRatedMovie = NO;
            userRating = @"0"; // set to 0 if not ready yet, when user clicks star this will change
        }
        else{
            alreadyRatedMovie = YES;
            self.lblFBShare.hidden = NO;
            self.fbShareOutlet.hidden = NO;
            
            //self.ratingBox.text = userRating;
            
            if ([userRating isEqualToString:@"1"]) {
                [self setRatingToOne];
            }
            else if ([userRating isEqualToString:@"2"]) {
                [self setRatingToTwo];
            }
            else if ([userRating isEqualToString:@"3"]) {
                [self setRatingToThree];
            }
            else if ([userRating isEqualToString:@"4"]) {
                [self setRatingToFour];
            }
            else {
                [self setRatingToFive];
            }
                         
            self.ratingCommentsBox.text = userComments;
            /*//Crap below this does nothing apparently......
            self.ratingCommentsBox.layer.cornerRadius=8.0f;
            self.ratingCommentsBox.layer.masksToBounds=YES;
            self.ratingCommentsBox.layer.borderColor=[[UIColor redColor]CGColor];
            self.ratingCommentsBox.layer.borderWidth= 1.0f;
            // end crap*/
        }
        
        //NSLog(@"temp string is %@ bool is %d", tempString, alreadyRatedMovie);
    }
    
}


- (void) pushMovieInfo{
    NSError *movieInfoError;
    
    NSData *dataPHPInfo = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:@"http://www.brennerbrothersbrewery.com/phpdata/reelgood/movieData.php"]];
    
    NSArray *movieInfoJSON = [NSJSONSerialization
                              JSONObjectWithData:dataPHPInfo
                              options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                              error:&movieInfoError];
    
    movieIDsInSql = [[NSMutableArray alloc] init];
    IDcounter = 0;
    foundMovieID = NO;
    
    if (movieInfoError)
    {
        //NSLog(@"%@", [movieInfoError localizedDescription]); // prob should do alert view
    }
    else {
        for (NSDictionary *theIDInfo in movieInfoJSON) // get movie IDs in movie_info first
        {
            movieIDsInSql[IDcounter] = theIDInfo[@"movie_id"]; // push ID to array
            IDcounter++;
        }
    }
    
    ////NSLog(@"tempIDstring is: %@", movieIDsInSql);
    
    for (int g = 0; g<[movieIDsInSql count]; g++) //check if current movie is in database
    {
        NSString* tempIDString = movieIDsInSql[g];
        
        if ([ID_of_movie isEqualToString:tempIDString]) //movie exists in database, change to obtimized method?
        {
            foundMovieID = YES;
            break;
        }
        
    }
    
    NSURL *detailedURL;
    NSString *detailedURLString;
    
    // //NSLog(@"FOUNDMOVIEID is %d", foundMovieID); // debugging
    
    if (foundMovieID == NO){ // add to database
        
        detailedURLString=[NSString stringWithFormat:
                           @"http://www.brennerbrothersbrewery.com/phpdata/reelgood/pushmovieinfo.php?movid=%@&title=%@"
                           ,ID_of_movie, title_of_movie];
        
        detailedURLString = [detailedURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        detailedURL=[[NSURL alloc] initWithString:detailedURLString];
        
        ////NSLog(@"detailed URl is: %@", detailedURL);
        
        [self.infoWebView loadRequest:[NSURLRequest requestWithURL:detailedURL]]; // send website to view, which will create info in database
        self.infoWebView.delegate = self;
        
    }
}


- (void) pushRatingInfo{
    NSURL *aDetailedURL;
    NSString *aDetailedURLString;
    NSString *usersComments;
    
    if ([self.ratingCommentsBox.text isEqualToString:@"Add comments here if you want"]){
        usersComments = @"User did not enter comments";
    }
    else {
        usersComments = self.ratingCommentsBox.text;
    }
    
    aDetailedURLString=[NSString stringWithFormat:
                        @"http://www.brennerbrothersbrewery.com/phpdata/reelgood/pushratingdata.php?username=%@&movid=%@&rating=%@&comments=%@"
                        ,[WSHelper getCurrentUser],ID_of_movie, userRating, usersComments];
    
    aDetailedURLString = [aDetailedURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // for special characters, need to add mysql_string function to php file
    
    aDetailedURL=[[NSURL alloc] initWithString:aDetailedURLString];
    
    
    [self.friendInfoWebView loadRequest:[NSURLRequest requestWithURL:aDetailedURL]]; // send website to view, which will create info in database
    self.friendInfoWebView.delegate = self;
    
    //NSLog(@"push rating info happened");
}

- (void) pushRatingInfoModify{
    NSURL *modifyDetailedURL;
    NSString *modifyDetailedURLString;
    NSString *usersComments;
    
    if ([self.ratingCommentsBox.text isEqualToString:@"Add comments here if you want"]){
        usersComments = @"User did not enter comments";
    }
    else {
        usersComments = self.ratingCommentsBox.text;
    }
    
    modifyDetailedURLString=[NSString stringWithFormat:
                             @"http://www.brennerbrothersbrewery.com/phpdata/reelgood/pushratingdatamodify.php?username=%@&movid=%@&rating=%@&comments=%@"
                             ,[WSHelper getCurrentUser],ID_of_movie, userRating, usersComments];
    
    
    modifyDetailedURLString = [modifyDetailedURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // to allow speical characters in comments section
    
    modifyDetailedURL=[[NSURL alloc] initWithString:modifyDetailedURLString];
    
    
    [self.modifyWebView loadRequest:[NSURLRequest requestWithURL:modifyDetailedURL]]; // send website to view, which will create info in database
    self.modifyWebView.delegate = self;
  
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString* finishedSuccessfullyMessage = @"New record created successfully";
    
    if (webView == self.friendInfoWebView){ // then check if was successful
        NSString* innerWebView = [self.friendInfoWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        
        if ([innerWebView rangeOfString:finishedSuccessfullyMessage].location == NSNotFound){
            //NSLog(@"PlaceHolder"); // error message?
        }
        else{
            UIAlertView *alertDialog;
            alertDialog = [[UIAlertView alloc]
                           initWithTitle: @"Success"
                           message:@"Your rating and comments have been shared with your friends!"
                           delegate: nil
                           cancelButtonTitle: @"OK"
                           otherButtonTitles: nil];
            [alertDialog show];
            self.lblFBShare.hidden = NO;
            self.fbShareOutlet.hidden = NO;
        }
        
        //NSLog(@"inner: %@", innerWebView);
    }
    else if (webView == self.modifyWebView){
        NSString* innerWebView = [self.modifyWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        
        if ([innerWebView rangeOfString:finishedSuccessfullyMessage].location == NSNotFound){
            //NSLog(@"PlaceHolder"); //error message?
        }
        else{
            UIAlertView *alertDialog;
            alertDialog = [[UIAlertView alloc]
                           initWithTitle: @"Success"
                           message:@"Your rating and comments have been shared with your friends!"
                           delegate: nil
                           cancelButtonTitle: @"OK"
                           otherButtonTitles: nil];
            [alertDialog show];
        }
    }
    
}
   
@end
