//
//  CustomCell.m
//  ThanksNatureBusTimer
//
//  Created by Kashima Takumi on 2014/04/07.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_label release];
    [super dealloc];
}
@end
