//
//  chatAddViewController.m
//  ReelGood
//
//  Created by Paul Brenner on 9/30/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "chatAddViewController.h"

@interface chatAddViewController ()

@end

@implementation chatAddViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
        target:self
        action:@selector(closePressed:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closePressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
