//
//  chatAddViewController.h
//  ReelGood
//
//  Created by Paul Brenner on 9/30/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chatMainObj.h"

@interface chatAddViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray* lstFriends;

@property (strong, nonatomic) chatMainObj* chatObjID;

@property (strong, nonatomic) NSMutableArray* alreadyInChat;

@end
