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

@interface chatViewController ()

@property NSTimer* messageTimer; //polling timer to get messages
@property __block NSMutableArray* messageArray;


@end

@implementation chatViewController

-(id) init
{
    self = [super init];
    if (self)
    {
        _messageArray = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    _messageTimer = [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(refreshMessages) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_messageTimer invalidate];
    _messageTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self refreshMessages];
    
    //TODO get if chat owner is current logged in user
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshMessages {
    
    [WSHelper getMessagesForChat:@"fac21664-874e-11e5-ac84-848f69fbc154" complete:^(NSMutableArray* JSON) {
        _messageArray = JSON;
        NSLog(@"callback is %@", _messageArray);
    }];
    
    
    NSLog(@"tick ");
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
