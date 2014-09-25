//
//  MyActivityCell.h
//  lemang
//
//  Created by LiZheng on 9/25/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActivityCell : UITableViewCell
{
    NSDictionary* localData;
    id owner;
}
@property (strong, nonatomic) IBOutlet UILabel *actTitle;
@property (strong, nonatomic) IBOutlet UILabel *actMember;
@property (strong, nonatomic) IBOutlet UIButton *buttonEdit;
@property (strong, nonatomic) IBOutlet UIButton *buttonInvite;
-(IBAction)DoActEdit:(id)sender;
-(IBAction)DoActInvite:(id)sender;

- (void)SetData:(NSDictionary*)data : (id)_owner;
- (void)SetAdmin;
- (void)SetJoin;
- (void)SetBookmark;

@end
