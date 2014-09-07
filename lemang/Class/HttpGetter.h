//
//  HttpGetter.h
//  LeMang
//
//  Created by LZ on 9/7/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpGetter : NSObject
{
    NSMutableData* receivedData;
}

- (void) DoGet:(NSString*)UrlStr;

@end
