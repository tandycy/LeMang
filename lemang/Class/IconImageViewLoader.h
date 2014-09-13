//
//  IconImageViewLoader.h
//  LeMang
//
//  Created by LZ on 8/28/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface IconImageViewLoader : UIImageView
{
    NSURLConnection* connection;
    NSMutableData* imgData;
    NSURLResponse* _response;
}

- (void)LoadFromUrl : (NSURL*)URL;
- (void)LoadFromUrl : (NSURL*)URL : (UIImage*)defaultImg;
@end
