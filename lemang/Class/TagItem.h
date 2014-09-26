//
//  TagItem.h
//  LeMang
//
//  Created by LZ on 9/26/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <Foundation/Foundation.h>

enum TagClass
{
    TagOrganization,
    TagActivity
};
enum TagDefined
{
    TagSystem,
    TagUser
};

@interface TagItem : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *tagId;
@property (nonatomic) enum TagClass tagClass;
@property (nonatomic) enum TagDefined tagDefined;

@end
