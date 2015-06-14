//
//  CustomCell.h
//  ReelGood
//
//  Created by Paul Brenner on 1/21/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendMovieLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendScore;
@property (strong, nonatomic) IBOutlet UIImageView *posterCellImage;

@end
