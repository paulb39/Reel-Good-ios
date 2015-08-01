//
//  searchViewController.h
//  ReelGood
//
//  Created by Paul Brenner on 11/13/14.
//  Copyright (c) 2014 reelGoodApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

NSMutableArray* movieTitles;
NSMutableArray* releaseDates;
NSMutableArray* movieIDs;
NSMutableArray* moviePosters;
NSMutableArray* moviePostersImage;
int movieCounter;

//#define kmovieTitle @"kmovietitle"
#define kreleaseDate @"kreleasedate"
//#define kmovieID @"kmovieid"
//define for posters?



@interface searchViewController : UIViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@end
