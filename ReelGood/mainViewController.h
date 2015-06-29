//
//  mainViewController.h
//  ReelGood
//
//  Created by Paul Brenner on 1/19/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <iAd/iAd.h>

NSMutableArray* friendMovieTitles;
NSMutableArray* friendMovieRating;
NSMutableArray* friendFriend;
NSMutableArray* friendMovieComments;
NSMutableArray* friendMovieIDs;
NSMutableArray* friendMoviePosters;

NSString* firstUserLoad;
NSString* userCurrent;

NSString *tempMovie;
NSString *tempID;
NSString *tempPosters;

NSString* tempPosterTest;

UIImage* image;

int posterCount;
int mainCounter;
bool didFirstLoad = NO;

#define kNewUserr @""


@interface mainViewController : UIViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate, ADBannerViewDelegate>

@end
