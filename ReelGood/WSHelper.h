//
//  WSHelper.h
//  ReelGood
//
//  Created by Paul Brenner on 6/14/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* PREFERENCE_KEY_USERNAME = @"username";

@interface WSHelper : NSObject

+ (NSString*) getUserNameFromServer:(NSString*) FB_ID;

+ (NSString*) getCurrentUser;

+ (NSUserDefaults*) getDefaults;

+ (void) setUserName:(NSString*) userName;

@end


