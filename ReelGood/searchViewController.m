//
//  searchViewController.m
//  ReelGood
//
//  Created by Paul Brenner on 11/13/14.
//  Copyright (c) 2014 reelGoodApps. All rights reserved.
//

#import "searchViewController.h"
#import "ViewController.h"
#import "searchCell.h"
#import <ILMovieDBClient.h>

@interface searchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *movieTableView;

- (IBAction)searchButton:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)goBackToMain:(id)sender;


@property (strong, nonatomic) NSMutableDictionary *dataItems;
- (IBAction)gotoMyProfile:(id)sender;
@property (strong, nonatomic) NSArray *keys;

@property (strong, nonatomic) NSMutableArray *testArray;

@end

@implementation searchViewController

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
    
    [ILMovieDBClient sharedClient].apiKey = @"beea29b97e50a0194d538ddace065f95";
    
    self.dataItems = nil; // not needed?
    self.dataItems = [NSMutableDictionary new];
    self.keys = self.dataItems.allKeys;
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
    return [movieTitles count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* UITableViewCell *cell = [self.movieTableView dequeueReusableCellWithIdentifier:@"movieProto"];
    
    cell.textLabel.text = [movieTitles objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [releaseDates objectAtIndex:indexPath.row];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[moviePosters objectAtIndex:indexPath.row]]]]; // put posters in tableview
  
    cell.imageView.image=image;
    cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"Gradient.png"]];*/
    
    searchCell *cell = [self.movieTableView dequeueReusableCellWithIdentifier:@"movieProto"];
    
    cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"Gradient.png"]];
    
    cell.movieTitleLabel .adjustsFontSizeToFitWidth = YES;
    cell.movieTitleLabel.minimumScaleFactor = 0.6;
    
    cell.movieTitleLabel.text = [movieTitles objectAtIndex:indexPath.row];
    cell.dateLabel.text = [releaseDates objectAtIndex:indexPath.row];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[moviePosters objectAtIndex:indexPath.row]]]]; // put posters in tableview
    
    cell.imageView.image=image;
    
    CGSize itemSize = CGSizeMake(154, 154); // make poster images bigger
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale); //UIGraphicsBeginImageContext
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *itemName = [releaseDates objectAtIndex:indexPath.row];
    NSUserDefaults *settings = [NSUserDefaults new];
    NSString *testTest = @"test";
    
    for (int l = 0; l< [releaseDates count]; l++) // get right location in array for movie info
    {
        if ([itemName isEqualToString:releaseDates[l]])
        {
            [settings setObject:movieTitles[l] forKey:kmovieTitle];
            [settings setObject:releaseDates[l] forKey:kreleaseDate];
            [settings setObject:movieIDs[l] forKey:kmovieID];
            [settings setObject:moviePosters[l] forKey:kmoviePoster];
            
            NSLog(@"title isL %@ release date is %@ movieId is %@",movieTitles[l], releaseDates[l], movieIDs[l]);
   
            [settings synchronize];
            break;
        }
    }
    
    testTest = [settings stringForKey:kreleaseDate];
    
    NSLog(@"releasei is %@ title is %@ movieId is %@",[settings stringForKey:kreleaseDate], [settings stringForKey:kmovieTitle], [settings stringForKey:kmovieID]);
    
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]
                   initWithTitle: @"Rate or View Info"
                   message:@"What do you want to do?"
                   delegate: self
                   cancelButtonTitle: @"Cancel"
                   otherButtonTitles: @"View Movie info", @"Rate Movie", nil];
    [alertDialog show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    NSString *buttonTitle=[alertView buttonTitleAtIndex:buttonIndex];
	
    if ([buttonTitle isEqualToString:@"View Movie info"]) {
        [self performSegueWithIdentifier:@"toInfo" sender:self];
    } else if ([buttonTitle isEqualToString:@"Rate Movie"]) {
		[self performSegueWithIdentifier:@"toSearchRate" sender:self];
    }
    else {
        //cancel was clicked
    }
}


- (IBAction)searchButton:(id)sender {

    movieIDs = [[NSMutableArray alloc] init];
    movieTitles = [[NSMutableArray alloc] init];
    releaseDates = [[NSMutableArray alloc] init];
    moviePosters = [[NSMutableArray alloc] init];
    
    [self hideKeyboard:nil];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // show loading screen
    hud.labelText = @"Updating...";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self getMovieInfo]; // get info and update tableview, when selected move data to other view controller
        //[self.movieTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void) getMovieInfo{
    NSString *searchString = self.searchField.text;
    movieCounter=0;
    moviePosters[movieCounter] = @"test";
    
    NSDictionary *params = @{@"query": searchString};
    
    [[ILMovieDBClient sharedClient] GET:kILMovieDBSearchMovie parameters:params block:^(id responseObject, NSError *error){
        if (!error) {
            NSArray *resultDictionary = responseObject[@"results"];
           
            NSLog(@"result is: %@",resultDictionary);
            
            for ( NSDictionary *movieTest in resultDictionary) // if empty, say no info, otherwise add info to arrays
            {
                if (movieTest[@"id"] != NULL){
                    movieIDs[movieCounter] = movieTest[@"id"];
                }
                else{
                    movieIDs[movieCounter] = @"No Data in DB";
                }
                
                if ([movieTest[@"title"] isEqualToString:@""]){
                    movieTitles[movieCounter] = @"No Data in DB";
                }
                else{
                    movieTitles[movieCounter] = movieTest[@"title"];
                }
                
                if ([movieTest[@"release_date"] isEqualToString:@""]){
                    releaseDates[movieCounter] = @"No Data in DB";
                }
                else{
                    releaseDates[movieCounter] = movieTest[@"release_date"];
                }
                
                if (movieTest[@"poster_path"] == (id)[NSNull null]){
                    moviePosters[movieCounter] = @"https://d3a8mw37cqal2z.cloudfront.net/assets/f996aa2014d2ffddfda8463c479898a3/images/no-poster-w185.jpg"; // set to default poster
                }
                else{
                    NSString* tempPosterAddress = movieTest[@"poster_path"];
                    NSString* tempPoster = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w154%@",tempPosterAddress];
                    moviePosters[movieCounter] = tempPoster;
                }
                
                [self.dataItems setObject:movieTitles[movieCounter] forKey:releaseDates[movieCounter]]; // may not be needed
                self.keys = self.dataItems.allKeys;
                
                NSLog(@"movie test is %@", movieTest[@"poster_path"]);
                
                movieCounter++;
            }
        }
        else
        {
            NSLog(@"ERROR %@", error); // do as alert view
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // show loading screen
        hud.labelText = @"Updating...";
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.movieTableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
    
}


- (IBAction)hideKeyboard:(id)sender {
    [self.searchField resignFirstResponder];
}

- (IBAction)goBackToMain:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil]; // go back to main screen
   //[self performSegueWithIdentifier:@"toFriend" sender:self];
}

@end
