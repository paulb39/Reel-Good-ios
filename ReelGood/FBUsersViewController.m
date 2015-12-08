//
//  FBUsersViewController.m
//  ReelGood
//
//  Created by Paul Brenner on 9/4/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "FBUsersViewController.h"
#import "WSHelper.h"

@interface FBUsersViewController ()
@property NSMutableArray* friendsID;
@property NSMutableArray* friendsUsername;
@property NSMutableArray* friendsName;
@property (weak, nonatomic) IBOutlet UITableView *tblFB;
- (IBAction)goBackTap:(id)sender;

@end

@implementation FBUsersViewController

@synthesize myDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _friendsID = [NSMutableArray new];
    _friendsUsername = [[NSMutableArray alloc] init];
    _friendsName = [[NSMutableArray alloc] init];
    
    [self getFBData];
    
   // NSLog(@"USERNAME1 AND ID %@ %@", _friendsID, _friendsUsername);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_friendsUsername count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tblFB dequeueReusableCellWithIdentifier:@"friendInfoProto"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendInfoProto"];
    }
    
    cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"Gradient.png"]];
    
    cell.textLabel.text = [_friendsName objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [_friendsUsername objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.myDelegate respondsToSelector:@selector(secondViewControllerDismissed:)])
    {
        [self.myDelegate secondViewControllerDismissed:[_friendsUsername objectAtIndex:indexPath.row]];
        //NSLog(@"string passed");
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //NSLog(@"SecondViewController dismissed");
}

- (void)getFBData {
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/friends" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSArray* resutlsArray = [result objectForKey:@"data"];
                 
                 for (NSDictionary* dict in resutlsArray) {
                     [_friendsID addObject:dict[@"id"]];
                     [_friendsName addObject:dict[@"name"]];
                 }
                 
                 for (NSString* FBStr in _friendsID) { // get userName for ID
                     NSString* FBUser = [WSHelper getUserNameFromServer:FBStr];
                     [_friendsUsername addObject:FBUser];
                 }
                 
                 [self.tblFB reloadData];
                 
                 //NSLog(@"fetched user:%@", _friendsID);
             } else {
                 NSLog(@"poor mans error handling %@", error.localizedDescription);
             }
         }];
    }
    

    
   // NSLog(@"USERNAME AND ID %@ %@", _friendsID, _friendsUsername);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBackTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
