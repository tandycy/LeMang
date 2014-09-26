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

- (UIImage*) LocalImageData
{
    return localImg;
}

- (void)LoadFromUrl : (NSURL*)URL
{
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:URL];
    [request setUsername:@"admin"];
    [request setPassword:@"admin"];
    [request setDelegate:self];
    
    localUrl = [NSString stringWithFormat:@"%@", URL];
    
    imgData = [[NSMutableData alloc] init];
    
    localRequest = request;
    
    [request startAsynchronous];
}

- (void)LoadFromUrl:(NSURL *)URL : (UIImage*) defaultImg
{
    [self setBackgroundImage:defaultImg forState:UIControlStateNormal];
    localImg = defaultImg;
    [self LoadFromUrl:URL];
}

- (void)LoadFromUrl:(NSURL *)URL :(UIImage *)defaultImg :(NSMutableDictionary *)outputBuffer
{
    buffer = outputBuffer;
    
    localUrl = [NSString stringWithFormat:@"%@", URL];
    
    if (outputBuffer != Nil)
    {
        UIImage* buffImg = outputBuffer[localUrl];
        if (buffImg != nil)
        {
            [self setBackgroundImage:buffImg forState:UIControlStateNormal];
            localImg = buffImg;
            return;
        }
    }
    
    [self LoadFromUrl:URL :defaultImg];
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
    localImg = img;
    
    if (buffer)
    {
        [buffer setObject:localImg forKey:localUrl];
    }
    localRequest = nil;
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
    NSError* error = [request error];
    localRequest = nil;
    
    if (error.code == 6)
        return;
    
    NSLog(@"Download image fail: %d",error.code);
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
