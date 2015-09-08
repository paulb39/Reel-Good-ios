//
//  FBUsersViewController.h
//  ReelGood
//
//  Created by Paul Brenner on 9/4/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@protocol SecondDelegate <NSObject>
-(void) secondViewControllerDismissed:(NSString *)stringForFirst;
@end

@interface FBUsersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
   __weak id myDelegate;
}
@property (nonatomic, weak) id<SecondDelegate> myDelegate;

@end
