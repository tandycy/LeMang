//
//  SchoolItem.h
//  lemang
//
//  Created by LiZheng on 9/9/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface SchoolItem : NSObject
{
    NSString* localName;
    NSNumber* localId;
    
    NSDictionary* areaList;
    NSDictionary* departList;
}

- (void) InitSchool:(NSString*)name:(NSNumber*)schoolId;

@end
