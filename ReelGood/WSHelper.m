//
//  WSHelper.m
//  ReelGood
//
//  Created by Paul Brenner on 6/14/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "WSHelper.h"

@implementation WSHelper

+ (NSUserDefaults*) getDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

+ (NSString*) getCurrentUser
{
    NSString* result = [[self getDefaults] objectForKey:PREFERENCE_KEY_USERNAME];
    
    return (result!=nil) ? result : nil;
}

+ (NSString*) getUserNameFromServer:(NSString*) FB_ID
{
    NSString* userName = @"username";
    
    NSString* urlString=[NSString stringWithFormat:
                         @"http://148.166.200.55/brennerp/phptest/data/checkFBID?FBID=%@"
                         ,FB_ID];
    
    NSLog(@"urlString is %@", urlString);
    
    NSError *error;
    
    NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:urlString]];
    
    NSArray* dataJSON = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                         error:&error];
    
    
    NSLog(@"dataJSON is %@", dataJSON);
    
    
    if (!error) {
        if (![dataJSON count]) {
            // NSLog(@"USERNAME IS NIL, DO SEGUE TO CREATE USERNAME");
            return nil;
        } else {
            @try {
                for (NSDictionary* dicTmp in dataJSON) {
                    userName = [dicTmp objectForKey:@"acc_username"];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"JSON ERROR %@", exception.description); // change to alert view
            }
            
        }
    } else {
        NSLog(@"ERROR getting username %@", error.description); // change to alert view
    }
    
    
    return userName;
}


+ (void) setUserName:(NSString*) userName
{
    [[self getDefaults] setObject:userName forKey:PREFERENCE_KEY_USERNAME];
    [[self getDefaults] synchronize];
}

@end
