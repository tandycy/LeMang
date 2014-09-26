//
//  ActivityViewCell.m
//  LeMang
//
//  Created by LZ on 8/25/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "ActivityViewCell.h"

@implementation ActivityViewCell
@synthesize activityIconImg;
@synthesize linkedActivity;

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

- (void) SetIconImgUrl:(NSURL *)url
{    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:@"admin"];
    [request setPassword:@"admin"];
    [request setDelegate:self];
    
    [activityIconImg setImage:[UIImage imageNamed:@"default_Icon"]];
    linkedActivity.cachedImg = activityIconImg.image;
    imgData = [[NSMutableData alloc] init];
    
    localRequest = request;
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest*)request
{
    imgData = [request responseData];
    
    UIImage *img=[UIImage imageWithData:imgData];
    [activityIconImg setImage:img];
    linkedActivity.cachedImg = img;
    localRequest = nil;
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
    NSError* error = [request error];
    NSLog(@"Download activity image fail: %d",error.code);
    localRequest = nil;
}

-(void) dealloc
{
    if (localRequest != nil)
    {
        [localRequest clearDelegatesAndCancel];
        NSLog(@"Request canceled by dealloc.");
    }
}

@end
