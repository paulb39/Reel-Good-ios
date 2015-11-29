//
//  chatViewController.m
//  ReelGood
//
//  Created by Paul Brenner on 9/17/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "chatViewController.h"
#import "chatMessageObj.h"
#import "WSHelper.h"
#import "chatAddViewController.h"

@interface chatViewController ()

@property NSTimer* messageTimer; //polling timer to get messages
@property __block NSMutableArray* messageArray;
@property __block NSMutableArray* JSQMessageArray;


@end

@implementation chatViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closePressed)];
    
    if ([_chatInfo.owner isEqualToString:[WSHelper getCurrentUser]]) { //because of bug in chat logic, only allow owners of chat to add friends
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriendPressed)];
    }
    
    NSLog(@"chat object is %@", _chatInfo);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
    _messageTimer = [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(refreshMessages) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [WSHelper setReadState:[WSHelper getCurrentUser] _chatID:_chatInfo.chat_ID _readState:@"1"]; // set to read when leave chat
    //TODO need to update chat_object to show read state
    
    [_messageTimer invalidate];
    _messageTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //TODO get if chat owner is current logged in user
    
    [self setupBubbles];
    
    [self refreshMessages]; // get data and show it on screen fast, polling will continuely update it.
    
    self.title = _chatInfo.movieTitle;
    self.senderId = [WSHelper getCurrentUser];
    self.senderDisplayName = [WSHelper getCurrentUser];
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;

    self.showLoadEarlierMessagesHeader = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshMessages {
    
    [WSHelper getMessagesForChat:_chatInfo.chat_ID complete:^(NSMutableArray* JSON) {
        _messageArray = JSON; //set local message array to callback info
        NSLog(@"callback");
        _JSQMessageArray = [NSMutableArray new];
        _peopleInChat = [NSMutableArray new];
        
        for (chatMessageObj* _mObj in _messageArray) { //set JSQ message array
            JSQMessage* _tmpJSQMessage = [[JSQMessage alloc] initWithSenderId:_mObj.sender senderDisplayName:_mObj.sender date:_mObj.createdDate text:_mObj.message];
            [_JSQMessageArray addObject:_tmpJSQMessage];
            [_peopleInChat addObject:_mObj.sender]; // for filtering who already is in chata
        }
        
        //sort dates on client because I dont know how to on server
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:TRUE];
        [_JSQMessageArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

        [self finishReceivingMessageAnimated:YES];//uitableview update
        //[self scrollToBottomAnimated:YES]; // needed?
    }];
    
    NSLog(@"tick ");
}

-(void)addFriendPressed { // goto add friend view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    chatAddViewController* addFriendController = [storyboard instantiateViewControllerWithIdentifier:@"chatAddViewController"];
    [addFriendController setModalPresentationStyle:UIModalPresentationFullScreen];
    [addFriendController setChatObjID:_chatInfo];
    [addFriendController setAlreadyInChat:_peopleInChat];
    [self.navigationController pushViewController:addFriendController animated:YES];
}

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
     //[JSQSystemSoundPlayer jsq_playMessageSentSound]; //sound needed?
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    
    [_JSQMessageArray addObject:message];
    
    //TODO set read state for ALL participants 
    [WSHelper sendMessage:senderId _chatID:_chatInfo.chat_ID _comment:text];
    
    [self finishSendingMessageAnimated:YES];
}

//
#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_JSQMessageArray objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    [_JSQMessageArray removeObjectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [_JSQMessageArray objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    
    return self.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    /**
     *  Return your previously created avatar image data objects.
     *  Note: these the avatars will be sized according to these values:
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *  Override the defaults in `viewDidLoad`
     */
    return nil;
}
//

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *  Show a timestamp
     */
    
    @try {
        JSQMessage *message = [_JSQMessageArray objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    @catch (NSException *exception) {
        return nil;
    }

    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [_JSQMessageArray objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [_JSQMessageArray objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_JSQMessageArray count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *  Text colors, label text, label colors, etc.
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [_JSQMessageArray objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) { //keeping incase I want to add media capabilities later
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}

#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *  Show a timestamp for every 3rd message
     */
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [_JSQMessageArray objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [_JSQMessageArray objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void) setupBubbles {
    NSLog(@"asd");
    _messageArray = [[NSMutableArray alloc] init];
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init]; // bubble setup
    //self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    _outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
}

-(void)closePressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
