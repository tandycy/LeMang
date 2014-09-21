//
//  MyMessageCell.m
//  LeMang
//
//  Created by LZ on 9/21/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "MyMessageCell.h"

@implementation MyMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)OnClickDel:(id)sender {
}

- (void)SetMessageData:(NSDictionary *)data owner:(id)owner
{
    localData = data;
    messageTable = owner;
}

- (void)OnRead
{
    //
}

@end
