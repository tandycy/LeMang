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
    
    _commentTittle.text = localData[@"title"];
    _commentContent.text = localData[@"content"];
    
    localId = localData[@"id"];
    
    NSArray* commentImgData = localData[@"images"];
    
    NSDictionary* creator = localData[@"createdBy"];
    
    if (creator.count == 0)
        return;
    
    creatorId = creator[@"id"];
    
    if (creatorId == activityCreator)
    {
        isEnableRemove = true;
    }
    else if ([UserManager IsInitSuccess])
    {
        int uid = [[UserManager Instance] GetLocalUserId];
        if (uid == creatorId.integerValue)
        {
            isEnableRemove = true;
        }
    }
    else
        isEnableRemove = false;
    
    NSString* creatorUrlStr = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/api/v1/user/%@", creatorId];
    NSURL* url = [NSURL URLWithString:creatorUrlStr];
    
    NSLog(@"%@", creatorUrlStr);
    
    
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
    _commentContent.frame = CGRectMake(_commentContent.frame.origin.x, _commentContent.frame.origin.y, _commentContent.frame.size.width, labelSize.height);
    [_commentContent sizeToFit];
    
    /*
    for (int i=0; i<3; i++) {
        UIButton *cimg = [self viewWithTag:(210+i)];
        if (cimg) {
            [cimg removeFromSuperview];
        }
        if (commentImgData.count > 0){
            UIImageView *commentImg = [[UIImageView alloc]initWithFrame:CGRectMake( 0, 0, 50, 50)];
            commentImg.image = comment.commentImg[i];
            UIButton *commentImgButton = [[UIButton alloc]initWithFrame:CGRectMake( 70+60*i, _commentContent.frame.origin.y + _commentContent.frame.size.height+10, 50, 50)];
            //  commentImg.backgroundColor = [[UIColor alloc]initWithPatternImage:comment.commentImg[i]];
            [commentImgButton addSubview:commentImg];
            commentImgButton.tag = (210+i);
            [commentImgButton addTarget:self action:@selector(imageItemClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImage *temp = comment.commentImg[i];
            viewController.img = temp;
            
            [cell addSubview:commentImgButton];
        }
    }
     */
    
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
    
    [deleteComment setHidden:isEnableRemove];
    
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
    
    [_creatorIcon setImage:[UIImage imageNamed:@"user_icon_de.png"]];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:@"admin"];
    [request setPassword:@"admin"];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(IBAction)deleteButtonClicked:(id)sender{
    
    if ([owner isKindOfClass:[ActivityCommentTableViewController class]])
        [owner DoDeleteComment:self];
}

-(void)SetActivityCreator: (NSNumber*)creator
{
    activityCreator = creator;
}

- (void)requestFinished:(ASIHTTPRequest*)request
{
    NSDictionary* returnData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil];
    
    if (returnData.count == 0)
        return;

    // Get creator data
    NSDictionary* profile = returnData[@"profile"];
    
    if (![profile isKindOfClass:[NSDictionary class]])
        return;
    
    NSString* iconUrlStr = profile[@"iconUrl"];
    if (iconUrlStr.length == 0)
        return;
    
    [_creatorIcon LoadFromUrl:[NSURL URLWithString:iconUrlStr]];
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
    NSError* error = [request error];
    NSLog(@"Get comment creator error: %d",error.code);
}

@end
