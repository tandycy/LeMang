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
    
    //[self setImage:[UIImage imageNamed:@"loading.gif"]];
    imgData = [[NSMutableData alloc] init];
    
    [request startAsynchronous];
    localRequest = request;
}

- (void)LoadFromUrl:(NSURL *)URL : (UIImage*) defaultImg
{
    [self setImage:defaultImg];
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
    [self setImage:img];
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
