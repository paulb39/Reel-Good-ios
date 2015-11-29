//
//  chatViewController.h
//  ReelGood
//
//  Created by Paul Brenner on 9/17/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessages.h"
#import "chatMainObj.h"


@interface chatViewController : JSQMessagesViewController

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (strong, nonatomic) chatMainObj* chatInfo;
@property (strong, nonatomic) NSMutableArray* peopleInChat;

@end
