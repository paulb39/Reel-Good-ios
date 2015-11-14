//
//  chatMessageObj.h
//  ReelGood
//
//  Created by Paul Brenner on 9/29/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chatMessageObj : NSObject

@property NSNumber* ID; // needed?
@property NSString* chat_ID; //string?
@property NSString* message; // nsdictionary or array for list??
@property NSString* sender; // needed?
@property NSString* createdDate; // NSDATE for sort? // format?

@end
