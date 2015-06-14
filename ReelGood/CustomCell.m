//
//  CustomCell.m
//  ReelGood
//
//  Created by Paul Brenner on 1/21/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.posterCellImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 26, 24)];
        //UIImageView *cellImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next@2x.png"]];
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
