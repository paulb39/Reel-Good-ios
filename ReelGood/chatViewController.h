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

@protocol ChatDelegate <NSObject>
-(void) chatViewControllerDismissed:(NSIndexPath*)cellPosition;
@end


@interface chatViewController : JSQMessagesViewController
{
    __weak id chatDelegate;
}

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (strong, nonatomic) chatMainObj* chatInfo;
@property (strong, nonatomic) NSMutableArray* peopleInChat;
@property (strong, nonatomic) NSIndexPath* chatIndex; // prob could have put in chatMainObj?

@property (nonatomic, weak) id<ChatDelegate> chatDelegate;

@end
