//
//  IconImageButtonLoader.h
//  LeMang
//
//  Created by LZ on 9/16/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "UIImageButton.h"
#import "ASIHTTPRequest.h"

@interface IconImageButtonLoader : UIImageButton
{
    NSData* imgData;
}

- (void)LoadFromUrl : (NSURL*)URL;
- (void)LoadFromUrl : (NSURL*)URL : (UIImage*)defaultImg;
@end
