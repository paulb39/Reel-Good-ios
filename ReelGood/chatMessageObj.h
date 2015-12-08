//
//  chatMessageObj.h
//  ReelGood
//
//  Created by Paul Brenner on 9/29/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessages.h"

@interface chatMessageObj : NSObject

@property NSNumber* ID; // needed?
@property NSString* chat_ID; //string?
@property NSString* message;
@property NSString* sender;
@property NSDate* createdDate; //2015-11-14 08:08:03

@end
