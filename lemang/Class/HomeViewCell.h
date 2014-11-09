//
//  HomeViewCell.h
//  LeMang
//
//  Created by LZ on 11/9/14.
//  Copyright (c) 2014 gxcm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "IconImageViewLoader.h"

@interface HomeViewCell : UITableViewCell
{
    NSDictionary* localData;
}

@property (strong, nonatomic) IBOutlet IconImageViewLoader *newsIcon;
@property (strong, nonatomic) IBOutlet UILabel *newsTitle;
@property (strong, nonatomic) IBOutlet UILabel *newsDesc;
@property (strong, nonatomic) IBOutlet UILabel *newsDate;

- (void)SetNews:(NSDictionary*) data;

@end
