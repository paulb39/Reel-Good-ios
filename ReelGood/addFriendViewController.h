//
//  addFriendViewController.h
//  ReelGood
//
//  Created by Paul Brenner on 1/14/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

NSString* currentLoggedInUser;
NSString* friendUserName;
NSMutableArray* arrayOfFriends;
bool fieldIsEmpty;
bool friendExists;

int friendCounter = 0;


@interface addFriendViewController : UIViewController <UIWebViewDelegate, MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate>
@end
