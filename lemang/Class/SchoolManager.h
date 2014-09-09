//
//  SchoolManager.h
//  LeMang
//
//  Created by LZ on 9/7/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AsiHttpRequest/Classes/ASIHTTPRequest.h"
#import "SchoolItem.h"

@interface SchoolManager : NSObject
{
    NSArray* schoolList;
    NSMutableData* receivedData;
    bool isInited;
    
    NSMutableDictionary* schoolDic;
}

- (void) RefreshSchoolList;
+ (SchoolItem*) GetSchoolItem:(NSString*)SchoolName;
+ (NSNumber*) GetSchoolId:(NSString*)SchoolName;
+ (SchoolManager*) Instance;
+ (void) InitSchoolList;
+ (NSArray*) GetSchoolNameList;
+ (bool) IsInited;
@end
