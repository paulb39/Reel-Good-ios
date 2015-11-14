//
//  WSHelper.m
//  ReelGood
//
//  Created by Paul Brenner on 6/14/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "WSHelper.h"
#import "chatMessageObj.h"

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
                         @"http://www.brennerbrothersbrewery.com/phpdata/reelgood/checkFBID.php?FBID=%@"
                         ,FB_ID];
    
    //NSLog(@"urlString is %@", urlString);
    
    NSError *error;
    
    NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:urlString]];
    
    NSArray* dataJSON = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                         error:&error];
    
    
    //NSLog(@"dataJSON is %@", dataJSON);
    
    
    if (!error) {
        if (![dataJSON count]) {
            // //NSLog(@"USERNAME IS NIL, DO SEGUE TO CREATE USERNAME");
            return nil;
        } else {
            @try {
                for (NSDictionary* dicTmp in dataJSON) {
                    userName = [dicTmp objectForKey:@"acc_username"];
                }
            }
            @catch (NSException *exception) {
                //NSLog(@"JSON ERROR %@", exception.description); // change to alert view
            }
            
        }
    } else {
        //NSLog(@"ERROR getting username %@", error.description); // change to alert view
    }
    
    
    return userName;
}


+ (void) setUserName:(NSString*) userName
{
    [[self getDefaults] setObject:userName forKey:PREFERENCE_KEY_USERNAME];
    [[self getDefaults] synchronize];
}

+ (BOOL) hasNetworkConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if (status == NotReachable) {
        return NO;
    }
    
    return YES;
}

+ (NSString*) getChatID:(NSString*) _username _friend:(NSString*)_friend _movieID:(NSString*)_movieID {
    //TODO: FIX THE DAMN KNOWN BUG WITH MULTIPLE FOUND CHAT IDS
    NSString* _url = [NSString stringWithFormat:@"http://www.brennerbrothersbrewery.com/phpdata/reelgood/getChatID.php?username=%@&friend=%@&movieid=%@", _username, _friend, _movieID];
    
    //NSURLSession* session; //async?
    
    NSError *error;
    NSString* _chatID;
    
    NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:_url]];
    NSArray* dataJSON = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                         error:&error];
    
    if (!error) {
        if (![dataJSON count]) {
            return nil; //chat does not exist
        } else {
            @try {
                for (NSDictionary* dicTmp in dataJSON) {
                    _chatID = [dicTmp objectForKey:@"chat_ID"];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"CHATID ERROR %@", exception.description); // change to alert view
            }
            
        }
    } else {
        NSLog(@"ERROR getting CHATID %@", error.description); // change to alert view
    }
    
    return _chatID; //return array for known bug??
}

+ (NSString*) createChat:(NSString*) _username _friend:(NSString*)_friend _movieID:(NSString*)_movieID {
    NSString* _url = [NSString stringWithFormat:@"http://www.brennerbrothersbrewery.com/phpdata/reelgood/createChat.php?chatowner=%@&participant=%@&movieid=%@", _username, _friend, _movieID];
    
    //NSError* error;
    
    NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:_url]];
    /*NSArray* dataJSON = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                         error:&error];*/
    NSString* _chatID = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return _chatID; //BAD ERROR HANDLING - WILL RETURN ERROR INSTEAD OF CHATID IF PROBLEM OCCURS
}

+ (void) sendMessage:(NSString*) _username _chatID:(NSString*)_chatID _comment:(NSString*)_comment {
    //testing async, just need to send request to server, dont need to wait for response
    NSString* _url = [NSString stringWithFormat:@"http://www.brennerbrothersbrewery.com/phpdata/reelgood/sendMessage.php?chatID=%@&chatmessage=%@&sender=%@", _chatID, _comment, _username];
    _url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL* url = [[NSURL alloc] initWithString:_url];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    __block NSString* result;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
        result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        } else {
            NSLog(@"there was an error: %@", connectionError);
        }
    }];
    
   //_url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   // NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:_url]];
   // NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"The result is %@", result);
}

+ (void) setReadState:(NSString*) _username _chatID:(NSString*)_chatID _readState:(int)_readState{
    //set to async?
    NSString* _url = [NSString stringWithFormat:@"http://www.brennerbrothersbrewery.com/phpdata/reelgood/setReadState.php?username=%@&chatID=%@&read=%d", _username, _chatID, _readState]; //1 for read
    
    NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:_url]];
    
    NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"The result is %@", result); //error handleing?
}

+ (void) addFriendToChat:(NSString*) _username _friend:(NSString*)_friend _chatID:(NSString*)_chatID _movieID:(NSString*)_movieID {
    //if owner = current user, can add friends <--fix //HOW?? <-- get chatInfo select from chats?
    //change to async with callback!
    //ADD FRIEND COMMENT ABOUT MOVIE -> done on server
    
    NSString* _url = [NSString stringWithFormat:@"http://www.brennerbrothersbrewery.com/phpdata/reelgood/setReadState.php?username=%@&friend=%@&chatID=%@&movieID=%@", _username, _friend, _chatID, _movieID];
    
    /*http://www.brennerbrothersbrewery.com/phpdata/reelgood/addFriendToChat.php?chatid=122c6cae-82a4-11e5-ac84-848f69fbc154&participant=paully&chatowner=jim&movieid=101 */
    
    NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:_url]];
    
    NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"The result is %@", result); //error handleing?
}

/*
+ (NSMutableArray*) getMessagesForChat:(NSString*) _chatID {
    chatMessageObj* _tmpMessageObj;
    NSMutableArray* _tmpMessageArray = [[NSMutableArray alloc] init];

    NSString* _url = [NSString stringWithFormat:@"http://www.brennerbrothersbrewery.com/phpdata/reelgood/setReadState.php?username=%@&chatID=%@&read=%@", @"asddas", _chatID, @"asdasd"]; //fix <--
    
    NSError* error;
    
    NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:_url]];
    NSArray* dataJSON = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                         error:&error];
    if (!error) {
        if (![dataJSON count]) {
            return nil; //no messages in chat
        } else {
            @try {
                for (NSDictionary* dicTmp in dataJSON) {
                    _tmpMessageObj = nil;
                    _tmpMessageObj.ID = [dicTmp objectForKey:@"ID"];
                    _tmpMessageObj.chat_ID = [dicTmp objectForKey:@"chat_id"];
                    _tmpMessageObj.message = [dicTmp objectForKey:@"message"];
                    _tmpMessageObj.sender = [dicTmp objectForKey:@"sender"];
                    _tmpMessageObj.createdDate = [dicTmp objectForKey:@"createdDate"];
                    [_tmpMessageArray addObject:_tmpMessageObj];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"CHATID ERROR %@", exception.description); // change to alert view
            }
            
        }
    } else {
        NSLog(@"ERROR getting CHATID %@", error.description); // change to alert view
    }
    
    return _tmpMessageArray;
} */ //not async

+ (void)getMessagesForChat:(NSString*) _chatID complete:(WSHelperDataBlock)complete {
    
    NSString* _url = [NSString stringWithFormat:@"http://www.brennerbrothersbrewery.com/phpdata/reelgood/getMessages.php?chatid=%@", _chatID];
    
    NSURL* url = [[NSURL alloc] initWithString:_url];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    __block NSArray* result;
    __block NSMutableArray* _tmpMessageArray;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            chatMessageObj* _tmpMessageObj;
            _tmpMessageArray = [[NSMutableArray alloc] init];
            NSError* error;
            result = [NSJSONSerialization
                      JSONObjectWithData:data
                      options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                      error:&error];

            @try {
                for (NSDictionary* dicTmp in result) {
                    _tmpMessageObj = [chatMessageObj new];
                    _tmpMessageObj.ID = [dicTmp objectForKey:@"message_ID"];
                    _tmpMessageObj.chat_ID = [dicTmp objectForKey:@"chat_ID"];
                    _tmpMessageObj.message = [dicTmp objectForKey:@"chat_message"];
                    _tmpMessageObj.sender = [dicTmp objectForKey:@"sender"];
                    _tmpMessageObj.createdDate = [dicTmp objectForKey:@"createdDate"];
                    [_tmpMessageArray addObject:_tmpMessageObj];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"CHATID ERROR %@", exception.description); // change to alert view
            }

        } else {
            NSLog(@"there was an error: %@", connectionError);
        }
        
        //NSLog(@"results array are %@", _tmpMessageArray);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(_tmpMessageArray); //CALLBACK to update tableview
        });
    }];
    
}



@end
