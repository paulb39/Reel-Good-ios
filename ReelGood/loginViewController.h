//
//  loginViewController.h
//  ReelGood
//
//  Created by Paul Brenner on 6/14/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <GoogleSignIn/GIDSignInButton.h>
#import "MBProgressHUD.h"


@interface loginViewController : UIViewController <FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate>

@end
