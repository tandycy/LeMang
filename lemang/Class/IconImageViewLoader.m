//
//  IconImageViewLoader.m
//  LeMang
//
//  Created by LZ on 8/28/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "IconImageViewLoader.h"

@implementation IconImageViewLoader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)LoadFromUrl : (NSURL*)URL
{
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:URL];
    [request setUsername:@"admin"];
    [request setPassword:@"admin"];
    [request setDelegate:self];
    
    [self setImage:[UIImage imageNamed:@"loading.gif"]];
    imgData = [[NSMutableData alloc] init];
    
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest*)request
{
    imgData = [request responseData];
    
    UIImage *img=[UIImage imageWithData:imgData];
    [self setImage:img];
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
    NSError* error = [request error];
    NSLog(@"Download image fail: %d",error.code);
}

@end
