//
//  MyOrgCell.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-26.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrgCell : UITableViewCell
{
    NSDictionary* localData;
    id owner;
    
    bool caninvite;
    bool canjoin;
}
@property (strong, nonatomic) IBOutlet UILabel *orgTitle;
@property (strong, nonatomic) IBOutlet UILabel *orgMember;
@property (strong, nonatomic) IBOutlet UIButton *buttonEdit;
@property (strong, nonatomic) IBOutlet UIButton *buttonInvite;
-(IBAction)DoOrgEdit:(id)sender;
-(IBAction)DoOrgInvite:(id)sender;

- (void)SetData:(NSDictionary*)data : (id)_owner;
- (void)SetAdmin;
- (void)SetJoin;
- (void)SetBookmark;

@end