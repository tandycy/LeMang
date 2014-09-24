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
}
@property (strong, nonatomic) IBOutlet UILabel *actTitle;
@property (strong, nonatomic) IBOutlet UILabel *actMember;
- (IBAction)DoActEdit:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *DoActInvite;

- (void)SetData:(NSDictionary*)data;

@end
