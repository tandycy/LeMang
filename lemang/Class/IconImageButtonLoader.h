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
    NSString* localUrl;
    NSData* imgData;
    int sector;
    int row;
    int index;
    
    UIImage* localImg;
    NSMutableDictionary* buffer;
    
    ASIHTTPRequest* localRequest;
    
    SEL afterSelector;
    id target;
}

- (UIImage*) LocalImageData;

- (int)Sector;
- (int)Row;
- (int)Index;

- (void)LoadFromUrl : (NSURL*)URL;
- (void)LoadFromUrl : (NSURL*)URL : (UIImage*)defaultImg;
- (void)LoadFromUrl : (NSURL*)URL : (UIImage*)defaultImg : (NSMutableDictionary*)outputBuffer;
- (void)LoadFromUrl : (NSURL*)URL : (UIImage*)defaultImg : (SEL)afterLoad : (id)_target;

- (void)SetLocation: (int)_sector: (int)_row: (int)_index;
@end
