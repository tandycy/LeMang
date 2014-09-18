//
//  ActivityCommentCell.h
//  lemang
//
//  Created by LiZheng on 9/14/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "IconImageViewLoader.h"

@interface ActivityCommentCell : UITableViewCell
{
    NSDictionary* localData;
    NSNumber* localId;
    NSNumber* creatorId;
    NSNumber* activityCreator;
    id owner;
    bool isEnableRemove;
}
@property (weak, nonatomic) IBOutlet UILabel *commentTittle;
@property (weak, nonatomic) IBOutlet UILabel *commentContent;
@property (weak, nonatomic) IBOutlet IconImageViewLoader *creatorIcon;

- (void)SetComment :(NSDictionary*)commentData ;
- (void)SetOwner : (id) _owner;
- (void)UpdateCommentDisplay;
- (NSNumber*)GetCommentId;
- (void)SetActivityCreator : (NSNumber*)creator;

@end
