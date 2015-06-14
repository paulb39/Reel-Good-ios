//
//  ViewController.h
//  ReelGood
//
//  Created by Paul Brenner on 11/13/14.
//  Copyright (c) 2014 reelGoodApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
static BOOL foundUsername = NO;
static BOOL passwordCorrect = NO;
static BOOL usernameAlreadyExists = NO;
static BOOL fieldsAreEmpty = NO;
NSData *receivedData;
NSMutableArray* userNames;
NSMutableArray* passWords;
NSMutableArray* userIDs;
static int Counter;
static int j;// number of users

#define kcurrentUser @""
#define ksegueFromMain @"0" // for auto login
#define kmovieID @"kmovieid"
#define kmovieTitle @"kmovietitle"
#define kmoviePoster @"lmovieposter"
#define kInstructions @"NO"
#define kaddedOrRemovedFriend @"0"

@interface ViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end
