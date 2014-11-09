//
//  HomeViewCell.m
//  LeMang
//
//  Created by LZ on 11/9/14.
//  Copyright (c) 2014 gxcm. All rights reserved.
//

#import "HomeViewCell.h"

@implementation HomeViewCell

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

-(void)SetNews:(NSDictionary *)data
{
    localData = data;
    
    _newsTitle.text = localData[@"title"];
    _newsDesc.text = localData[@"description"];
    _newsDate.text = localData[@"createdDate"];
    
    NSString* iconStr = localData[@"iconUrl"];
    iconStr = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/resources%@", iconStr];
        
    NSURL* url = [NSURL URLWithString:iconStr];
    
    [_newsIcon LoadFromUrl:url :[UserManager DefaultIcon]];
}

@end
