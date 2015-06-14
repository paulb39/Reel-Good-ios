//
//  profileCustomCell.m
//  ReelGood
//
//  Created by Paul Brenner on 2/24/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "profileCustomCell.h"

@implementation profileCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.posterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 26, 24)];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
