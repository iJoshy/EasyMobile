//
//  StoreListCell.m
//  EasyMobile
//
//  Created by Joshua Balogun on 9/1/14.
//  Copyright (c) 2014 Etisalat Nigeria. All rights reserved.
//
//

#import "StoreListCell.h"

@implementation StoreListCell

@synthesize titleLabel, locationLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
