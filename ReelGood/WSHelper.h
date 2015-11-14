//
//  WSHelper.h
//  ReelGood
//
//  Created by Paul Brenner on 6/14/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

static NSString* PREFERENCE_KEY_USERNAME = @"username";

typedef void (^WSHelperDataBlock)(NSMutableArray* JSON); //make more generic?

@interface WSHelper : NSObject

+ (NSString*) getUserNameFromServer:(NSString*) FB_ID;

+ (NSString*) getCurrentUser;

+ (NSUserDefaults*) getDefaults;

+ (void) setUserName:(NSString*) userName;

+ (BOOL) hasNetworkConnection;

+ (NSString*) getChatID:(NSString*) _username _friend:(NSString*)_friend _movieID:(NSString*)_movieID;

+ (NSString*) createChat:(NSString*) _username _friend:(NSString*)_friend _movieID:(NSString*)_movieID;

+ (void) sendMessage:(NSString*) _username _chatID:(NSString*)_chatID _comment:(NSString*)_comment;

+ (void) setReadState:(NSString*) _username _chatID:(NSString*)_chatID _readState:(int)_readState;

//+ (NSMutableArray*) getMessagesForChat:(NSString*) _chatID; //not async
+ (void)getMessagesForChat:(NSString*) _chatID complete:(WSHelperDataBlock)complete; //async with completion block attemp

+ (void) addFriendToChat:(NSString*) _username _friend:(NSString*)_friend _chatID:(NSString*)_chatID movieID:(NSString*)movieID;

//add friend - add message to chat as well. 



@end


