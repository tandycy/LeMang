//
//  IconImageButtonLoader.m
//  LeMang
//
//  Created by LZ on 9/16/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "IconImageButtonLoader.h"

@implementation IconImageButtonLoader

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

- (void)SetLocation:(int)_sector :(int)_row :(int)_index
{
    sector = _sector;
    row = _row;
    index = _index;
}

- (int)Sector
{
    return sector;
}

- (int)Row
{
    return row;
}

- (int)Index
{
    return index;
}

- (void)LoadFromUrl : (NSURL*)URL
{
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:URL];
    [request setUsername:@"admin"];
    [request setPassword:@"admin"];
    [request setDelegate:self];
    
    imgData = [[NSMutableData alloc] init];
    
    [request startAsynchronous];
}

- (void)LoadFromUrl:(NSURL *)URL : (UIImage*) defaultImg
{
    [self setBackgroundImage:defaultImg forState:UIControlStateNormal];
    [self LoadFromUrl:URL];
}

- (void)requestFinished:(ASIHTTPRequest*)request
{
    imgData = [request responseData];
   
    UIImage *img=[UIImage imageWithData:imgData];
    if (img == nil)
    {
        NSLog(@"invalid image data from: %@", request.url);
        NSLog(@"with response: %d\n\n", [request responseStatusCode]);
        return;
    }
    [self setBackgroundImage:img forState:UIControlStateNormal];
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
    NSError* error = [request error];
    
    if (error.code == 6)
        return;
    
    NSLog(@"Download image fail: %d",error.code);
}
@end
