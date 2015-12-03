//
//  chatAddViewController.m
//  ReelGood
//
//  Created by Paul Brenner on 9/30/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "chatAddViewController.h"
#import "WSHelper.h"

@interface chatAddViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation chatAddViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
        target:self
        action:@selector(closePressed:)];
    
    self.title =  [NSString stringWithFormat:@"Friends who rated %@",_chatObjID.movieTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // self.tblView.backgroundColor = [UIColor lightGrayColor]; // doesnt look good?
    
    _lstFriends = [[NSMutableArray alloc] init];

    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closePressed:(UIBarButtonItem *)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getData {
    [WSHelper getFriendsAvailableForChat:_chatObjID.movieID complete:^(NSMutableArray* JSON) {
        _lstFriends = JSON;
        
        NSSet *firstSet = [NSSet setWithArray:_alreadyInChat];
        NSMutableSet *secondSet = [NSMutableSet setWithCapacity:[_lstFriends count]];
        [secondSet addObjectsFromArray:_lstFriends];
        [secondSet minusSet:firstSet]; // filter people already in chat
        
        _lstFriends = [[secondSet allObjects] mutableCopy];
        [self.tblView reloadData]; //update tableview
    }];
}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
    return [_lstFriends count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"friendCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"Gradient.png"]];
    cell.textLabel.text = [_lstFriends objectAtIndex:indexPath.row];
 
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* alertString =[NSString stringWithFormat:
                            @"Add %@ to chat?"
                            ,[_lstFriends objectAtIndex:indexPath.row]];
    
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]
                   initWithTitle: @"Add Friend?"
                   message:alertString
                   delegate: self
                   cancelButtonTitle: @"Cancel"
                   otherButtonTitles: @"Okay", nil];
    alertDialog.tag = indexPath.row; // send index via alert tag
    [alertDialog show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle=[alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Okay"]) {
        NSLog(@"test");
        @try {
            NSString* _friend = [_lstFriends objectAtIndex:alertView.tag];
            NSString* _chatid = _chatObjID.chat_ID;
            NSString *_movid = _chatObjID.movieID;
            [self SetToUnreadForAll:_chatid];
            [WSHelper AddFriendToChat:_friend _chatID:_chatid _movieID:_movid];
        }
        @catch (NSException *exception) {
            NSLog(@"Exceptio nis %@", exception.description);
        }

        [self.navigationController popViewControllerAnimated:YES]; // add friend to chat
    }
}

- (void)SetToUnreadForAll:(NSString*)_chatID{
    //[WSHelper getReadState:[WSHelper getCurrentUser] _chatID:_chatID];
    [WSHelper setReadState:_alreadyInChat _chatID:_chatID];
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
