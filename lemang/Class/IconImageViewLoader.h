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
    NSData* imgData;
    ASIHTTPRequest* localRequest;
    
    SEL afterSelector;
    id target;
}

- (void)LoadFromUrl : (NSURL*)URL;
- (void)LoadFromUrl : (NSURL*)URL : (UIImage*)defaultImg;
- (void)LoadFromUrl : (NSURL*)URL : (UIImage*)defaultImg : (SEL)afterLoad : (id)_target;

@end
