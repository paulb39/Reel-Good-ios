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

NSMutableArray* friendMovieTitles;
NSMutableArray* friendMovieRating;
NSMutableArray* friendFriend;
NSMutableArray* friendMovieComments;
NSMutableArray* friendMovieIDs;
NSMutableArray* friendMoviePosters;
NSMutableArray* chatObjArray;


NSString* chatButton;
NSString* firstUserLoad;
NSString* userCurrent;

NSString *tempMovie;
NSString *tempID;
NSString *tempPosters;

NSString* tempPosterTest;

UIImage* image;
NSMutableArray* friendMoviePostersImage;

int posterCount;
int mainCounter;
bool didFirstLoad = NO;

#define kNewUserr @""


@interface mainViewController : UIViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@end
