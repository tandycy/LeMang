//
//  SearchResultItem.h
//  LeMang
//
//  Created by LZ on 9/29/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <Foundation/Foundation.h>

enum SearchResultType
{
    Result_Other,
    Result_Organization,
    Result_Activity,
    Result_User,
};

@interface SearchResultItem : NSObject
{

}
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSNumber* itemId;
@property (nonatomic, copy) NSDictionary* localData;
@property (nonatomic) enum SearchResultType itemType;

@end
