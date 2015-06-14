//
//  searchCell.m
//  ReelGood
//
//  Created by Paul Brenner on 3/11/15.
//  Copyright (c) 2015 reelGoodApps. All rights reserved.
//

#import "searchCell.h"

@implementation searchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
