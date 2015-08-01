//
//  profileViewController.h
//  ReelGood
//
//  Created by Paul Brenner on 1/14/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

NSMutableArray* profileMovieTitles;
NSMutableArray* profileMovieIDs;
NSMutableArray* profileMovieRating;
NSMutableArray* profileMoviePosters;
NSMutableArray* profileMoviePostersImage;

NSString* theCurrentUser;

UIImage *image;

int profileCounter;
bool didProfileFirstLoad;


@interface profileViewController : UIViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, MBProgressHUDDelegate>

@end
