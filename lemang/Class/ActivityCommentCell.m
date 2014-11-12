//
//  ActivityCommentCell.m
//  lemang
//
//  Created by LiZheng on 9/14/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "ActivityCommentCell.h"
#import "ActivityCommentTableViewController.h"

@implementation ActivityCommentCell
{
    NSMutableArray* localImages;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)SetComment:(NSDictionary *)commentData
{
    localData = commentData;
    
    [self UpdateCommentDisplay];
}

- (NSNumber*) GetCommentId
{
    return localId;
}

- (void) SetOwner:(id)_owner
{
    owner = _owner;    
}

- (void)UpdateCommentDisplay
{
    if (localData == nil)
        return;
    
    NSMutableDictionary* imgBuffer;
    if ([owner isKindOfClass:[ActivityCommentTableViewController class]])
    {
        imgBuffer = [(ActivityCommentTableViewController*)owner GetCommentImageBuffer];
    }
    
    _commentTittle.text = localData[@"title"];
    _commentContent.text = localData[@"content"];
    
    localId = localData[@"id"];
    
    NSArray* commentImgData = localData[@"images"];
    
    NSDictionary* creator = localData[@"createdBy"];
    creatorId = creator[@"id"];
    
    NSDictionary* profileData = creator[@"profile"];
    NSString* nick = @"";
    NSString* iconStr = @"";
    if ([profileData isKindOfClass:[NSDictionary class]])
    {
        nick = [UserManager filtStr:profileData[@"nickName"]:@""];
        NSString* urlStr = profileData[@"iconUrl"];
        iconStr = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/resources%@", urlStr];
    }
    
    if (_commentTittle.text.length == 0)
    {
        if (nick.length > 0)
            _commentTittle.text = nick;
        else
            _commentTittle.text = creator[@"name"];
    }
    
    [_creatorIcon LoadFromUrl:[NSURL URLWithString:iconStr] :[UserManager DefaultIcon] :imgBuffer];
    
    if ([UserManager IsInitSuccess])
    {
        NSNumber* uid = [[UserManager Instance] GetLocalUserId];
        
        if (uid.longValue == creatorId.longValue) // comment owner
        {
            isEnableRemove = true;
        }
        else if (uid.longValue == activityCreator.longValue) // activity owner
        {
            isEnableRemove = true;
        }
    }
    else
        isEnableRemove = false;
    
    NSArray* rateIconList = [[NSArray alloc] initWithObjects:_rateIcon1, _rateIcon2, _rateIcon3, _rateIcon4, _rateIcon5, nil];
    NSNumber*rate = localData[@"rating"];
    
    for (int i = 0; i < rateIconList.count; i++)
    {
        if ( i+1 > rate.integerValue)
            [rateIconList[i] setImage: [UIImage imageNamed:@"rate_star_off"]];
        else
            [rateIconList[i] setImage: [UIImage imageNamed:@"rate_star_whole"]];
    }
    
    
    _commentTittle.textColor = [UIColor colorWithRed:0.17647059 green:0.17647059 blue:0.17647059 alpha:1];
    _commentTittle.font = [UIFont fontWithName:defaultBoldFont size:15];
    
    _commentContent.textColor = [UIColor colorWithRed:0.41176471 green:0.41176471 blue:0.41176471 alpha:1];
    _commentContent.font = [UIFont fontWithName:defaultFont size:13];
    CGSize labelSize = {0, 0};
    labelSize = [_commentContent.text sizeWithFont:_commentContent.font
                               constrainedToSize:CGSizeMake(240.0, 5000)
                                   lineBreakMode:UILineBreakModeWordWrap];
    _commentContent.numberOfLines = 0;
    _commentContent.lineBreakMode = UILineBreakModeWordWrap;
    _commentContent.frame = CGRectMake(_commentContent.frame.origin.x, _commentContent.frame.origin.y, labelSize.width, labelSize.height);
    [_commentContent sizeToFit];
    

    
    UIButton *dc = [self viewWithTag:209];
    if (dc) {
        [dc removeFromSuperview];
    }
    
    UIButton *deleteComment;
    if (commentImgData.count == 0) {
        deleteComment  = [[UIButton alloc]initWithFrame:CGRectMake(290, _commentContent.frame.origin.y+_commentContent.frame.size.height+15, 28, 30)];
    }
    else deleteComment = [[UIButton alloc]initWithFrame:CGRectMake(290, _commentContent.frame.origin.y+_commentContent.frame.size.height+65, 28, 30)];
    [deleteComment setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [deleteComment setBackgroundImage:[UIImage imageNamed:@"delete_down.png"] forState:UIControlStateSelected];
    [deleteComment addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    deleteComment.tag = 209;
    [self addSubview:deleteComment];
    
    [deleteComment setHidden:!isEnableRemove];
    
    UILabel *cd = [self viewWithTag:208];
    if (cd) {
        [cd removeFromSuperview];
    }
    UILabel *commentDate;
    if (commentImgData.count == 0) {
        commentDate = [[UILabel alloc]initWithFrame:CGRectMake(70, _commentContent.frame.origin.y+_commentContent.frame.size.height+20, 63, 12)];
    }
    else commentDate = [[UILabel alloc]initWithFrame:CGRectMake(70, _commentContent.frame.origin.y+_commentContent.frame.size.height+70, 63, 12)];
    commentDate.text = @"8-4 14:04";
    commentDate.textColor = [UIColor colorWithRed:0.41176471 green:0.41176471 blue:0.41176471 alpha:1];
    commentDate.font = [UIFont fontWithName:defaultFont size:11];
    commentDate.tag = 208;
    [self addSubview:commentDate];

    
    for (int i = 0; i < 6; i++)
    {
        IconImageButtonLoader *cib = [self viewWithTag:(210+i)];
        if (cib) {
            [cib removeFromSuperview];
        }
    }
    
    for (int i = 0; i < commentImgData.count; i++)
    {
        NSDictionary* item = commentImgData[i];
        
        NSString* fileUrl = @"http://e.taoware.com:8080/quickstart/resources";
        fileUrl = [fileUrl stringByAppendingFormat:@"%@", item[@"imageUrl"]];
        
        IconImageButtonLoader *commentImgButton = [[IconImageButtonLoader alloc]initWithFrame:CGRectMake( 70+60*i, _commentContent.frame.origin.y + _commentContent.frame.size.height+10, 50, 50)];
        
        commentImgButton.tag = (210+i);
        
        [commentImgButton LoadFromUrl:[NSURL URLWithString:fileUrl] :[UIImage imageNamed:@"default_Icon"] : imgBuffer];
        
        [commentImgButton addTarget:self action:@selector(imageItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:commentImgButton];
        
    }
}

-(IBAction)imageItemClick:(id)sender
{
    IconImageButtonLoader* senderButton = (IconImageButtonLoader*)sender;
    
    // ActivityCommetImageDetailViewController
    
    UIImage* img = [senderButton LocalImageData];
    
    if ([owner isKindOfClass:[ActivityCommentTableViewController class]])
    {
        [(ActivityCommentTableViewController*)owner imageItemClick:img];
    }
}

-(IBAction)deleteButtonClicked:(id)sender{
    
    if ([owner isKindOfClass:[ActivityCommentTableViewController class]])
        [owner DoDeleteComment:self];
}

-(void)SetActivityCreator: (NSNumber*)creator
{
    activityCreator = creator;
}

- (IBAction)OnIconClick:(id)sender
{
    ActivityCommentTableViewController* VC = nil;
    
    if ([owner isKindOfClass:[ActivityCommentTableViewController class]])
        VC = (ActivityCommentTableViewController*)owner;
    else
        return;
    
    MemberInfoTableViewController *memberInfoTVC = [VC.storyboard instantiateViewControllerWithIdentifier:@"MemberInfoTableViewController"];
    NSDictionary* creator = localData[@"createdBy"];
    [memberInfoTVC SetMemberId:creator[@"id"]];
    
    NSString* name = creator[@"name"];
    NSDictionary* profileData = creator[@"profile"];
    if ([profileData isKindOfClass:[NSDictionary class]])
    {
        NSString* nick = [UserManager filtStr:profileData[@"nickName"]:@""];
        if (nick.length > 0)
            name = nick;
    }
    memberInfoTVC.navigationItem.title = [NSString stringWithFormat:@"%@的账户",name];
    
    [VC.navigationController pushViewController:memberInfoTVC animated:YES];
}

@end
