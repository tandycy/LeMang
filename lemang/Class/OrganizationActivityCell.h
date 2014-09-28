//
//  OrganizationActivityCell.h
//  LeMang
//
//  Created by LZ on 9/28/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrganizationActivityCell : UITableViewCell
{
    NSDictionary* localData;
}

- (void) SetData:(NSDictionary*)data;

@end
