//
//  profileCustomCell.h
//  ReelGood
//
//  Created by Paul Brenner on 2/24/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface profileCustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileStar;

@end
