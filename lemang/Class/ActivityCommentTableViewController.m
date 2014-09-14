//
//  ActivityCommentTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-14.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "ActivityCommentTableViewController.h"
#import "ActivityComment.h"
#import "ActivityCommetImageDetailViewController.h"
#import "Constants.h"

@interface ActivityCommentTableViewController ()
{
    NSMutableArray *tableData;
    ActivityCommetImageDetailViewController *viewController;
}

@end

@implementation ActivityCommentTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUserData];
    
    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityCommetImageDetailViewController"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return tableData.count;
}

-(void)SetCommentList:(NSArray *)commentList
{
    localComments = commentList;
}

-(void)createUserData{
    
    tableData = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < localComments.count; i++)
    {
        NSDictionary* item = localComments[i];
        [tableData addObject:item];
    }
    
    cellArray = [NSMutableArray arrayWithCapacity:localComments.count];
    
    /*
    NSMutableArray *imgs = [[NSMutableArray alloc]init];
    imgs[0] = [UIImage imageNamed:@"doge.jpg"];
    imgs[1] = [UIImage imageNamed:@"head.jpg"];
    imgs[2] = [UIImage imageNamed:@"活动成员.png"];
    
    ActivityComment *comment1 = [[ActivityComment alloc]init];
    comment1 = [ActivityComment commentsOfCategory:@"comment1" commentName:@"我是楼主" commentIcon:[UIImage imageNamed:@"doge.jpg"] commentTitle:@"好看的电影" commentDetail:@"今天看了超好看的电影，我真是这辈子都无憾了！" commentImg:imgs];
    
    ActivityComment *comment2 = [[ActivityComment alloc]init];
    comment2 = [ActivityComment commentsOfCategory:@"comment1" commentName:@"我是二楼" commentIcon:[UIImage imageNamed:@"doge.jpg"] commentTitle:@"好看的电影" commentDetail:@"今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！" commentImg:NULL
                ];
    ActivityComment *comment3 = [[ActivityComment alloc]init];
    comment3 = [ActivityComment commentsOfCategory:@"comment1" commentName:@"我是三楼" commentIcon:[UIImage imageNamed:@"doge.jpg"] commentTitle:@"好看的电影" commentDetail:@"今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！" commentImg:imgs];
    ActivityComment *comment4 = [[ActivityComment alloc]init];
    comment4 = [ActivityComment commentsOfCategory:@"comment1" commentName:@"我是四楼" commentIcon:[UIImage imageNamed:@"doge.jpg"] commentTitle:@"好看的电影" commentDetail:@"今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！" commentImg:imgs];
    ActivityComment *comment5 = [[ActivityComment alloc]init];
    comment5 = [ActivityComment commentsOfCategory:@"comment1" commentName:@"我是五楼" commentIcon:[UIImage imageNamed:@"doge.jpg"] commentTitle:@"好看的电影" commentDetail:@"今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！" commentImg:imgs];
    ActivityComment *comment6 = [[ActivityComment alloc]init];
    comment6 = [ActivityComment commentsOfCategory:@"comment1" commentName:@"我是六楼" commentIcon:[UIImage imageNamed:@"doge.jpg"] commentTitle:@"好看的电影" commentDetail:@"今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！" commentImg:NULL];
    
    tableData[0] = comment1;
    tableData[1] = comment2;
    tableData[2] = comment3;
    tableData[3] = comment4;
    tableData[4] = comment5;
    tableData[5] = comment6;
    // NSLog(@"%lu",(unsigned long)tableData.count);
     */
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentCell";
    //自定义cell类
    ActivityCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[ActivityCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row & 0x1){
        cell.backgroundColor = [UIColor colorWithRed:0.95294118 green:0.95294118 blue:0.95294118 alpha:1];
    }
    else cell.backgroundColor = [UIColor whiteColor];
    
    cell.selectedBackgroundView = [[UIView alloc] init];
    
    [cell SetComment:tableData[indexPath.row]];
    
    // TODO refacotr these UI layout code into comment cell class
    /*
    ActivityComment *comment = [tableData objectAtIndex:indexPath.row];
    UILabel *commentName = (UILabel*)[cell viewWithTag:201];
    UIImageView *commentIcon = (UIImageView*)[cell viewWithTag:200];
    UILabel *commentDetail = (UILabel*)[cell viewWithTag:202];
    
    commentName.text = comment.commentName;
    commentName.textColor = [UIColor colorWithRed:0.17647059 green:0.17647059 blue:0.17647059 alpha:1];
    commentName.font = [UIFont fontWithName:defaultBoldFont size:15];
    commentIcon.image = comment.commentIcon;
     
    
    commentDetail.text = comment.commentDetail;
    
    commentDetail.textColor = [UIColor colorWithRed:0.41176471 green:0.41176471 blue:0.41176471 alpha:1];
    commentDetail.font = [UIFont fontWithName:defaultFont size:13];
    CGSize labelSize = {0, 0};
    labelSize = [commentDetail.text sizeWithFont:commentDetail.font
                               constrainedToSize:CGSizeMake(240.0, 5000)
                                   lineBreakMode:UILineBreakModeWordWrap];
    commentDetail.numberOfLines = 0;
    commentDetail.lineBreakMode = UILineBreakModeWordWrap;
    commentDetail.frame = CGRectMake(commentDetail.frame.origin.x, commentDetail.frame.origin.y, commentDetail.frame.size.width, labelSize.height);
    [commentDetail sizeToFit];
    
    
    for (int i=0; i<3; i++) {
        UIButton *cimg = [cell viewWithTag:(210+i)];
        if (cimg) {
            [cimg removeFromSuperview];
        }
        if (comment.commentImg != NULL){
            UIImageView *commentImg = [[UIImageView alloc]initWithFrame:CGRectMake( 0, 0, 50, 50)];
            commentImg.image = comment.commentImg[i];
            UIButton *commentImgButton = [[UIButton alloc]initWithFrame:CGRectMake( 70+60*i, commentDetail.frame.origin.y + commentDetail.frame.size.height+10, 50, 50)];
            //  commentImg.backgroundColor = [[UIColor alloc]initWithPatternImage:comment.commentImg[i]];
            [commentImgButton addSubview:commentImg];
            commentImgButton.tag = (210+i);
            [commentImgButton addTarget:self action:@selector(imageItemClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImage *temp = comment.commentImg[i];
            viewController.img = temp;
            
            [cell addSubview:commentImgButton];
        }
    }
    
    UIButton *dc = [cell viewWithTag:209];
    if (dc) {
        [dc removeFromSuperview];
    }
    UIButton *deleteComment;
    if (comment.commentImg == NULL) {
        deleteComment  = [[UIButton alloc]initWithFrame:CGRectMake(290, commentDetail.frame.origin.y+commentDetail.frame.size.height+15, 28, 30)];
    }
    else deleteComment = [[UIButton alloc]initWithFrame:CGRectMake(290, commentDetail.frame.origin.y+commentDetail.frame.size.height+65, 28, 30)];
    [deleteComment setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [deleteComment setBackgroundImage:[UIImage imageNamed:@"delete_down.png"] forState:UIControlStateSelected];
    [deleteComment addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    deleteComment.tag = 209;
    [cell addSubview:deleteComment];
    
    UILabel *cd = [cell viewWithTag:208];
    if (cd) {
        [cd removeFromSuperview];
    }
    UILabel *commentDate;
    if (comment.commentImg==NULL) {
        commentDate = [[UILabel alloc]initWithFrame:CGRectMake(70, commentDetail.frame.origin.y+commentDetail.frame.size.height+20, 63, 12)];
    }
    else commentDate = [[UILabel alloc]initWithFrame:CGRectMake(70, commentDetail.frame.origin.y+commentDetail.frame.size.height+70, 63, 12)];
    commentDate.text = @"8-4 14:04";
    commentDate.textColor = [UIColor colorWithRed:0.41176471 green:0.41176471 blue:0.41176471 alpha:1];
    commentDate.font = [UIFont fontWithName:defaultFont size:11];
    commentDate.tag = 208;
    [cell addSubview:commentDate];
    
    NSLog(@"%@",comment.commentImg);
    */
    
    
    return cell;
}

-(void)imageItemClick:(UIButton *)button{
    
    NSLog(@"superview: %@",button.superview);
    NSLog(@"superview.superview: %@",button.superview.superview);
    
    //  [self.navigationController modalViewController:viewController];
    viewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:viewController animated:YES];
    //  [self.navigationController pushViewController:viewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* commentData = tableData[indexPath.row];
    NSString* contentStr = commentData[@"content"];
    
    CGSize labelSize = {0, 0};
    labelSize = [contentStr sizeWithFont:[UIFont fontWithName:defaultFont size:13]
                                 constrainedToSize:CGSizeMake(240.0, 5000)
                                     lineBreakMode:UILineBreakModeWordWrap];;
    int imageAdjust = 40;
    
    NSArray* commentImg = commentData[@"images"];
    
    if (commentImg.count > 0)
        imageAdjust = 90;
    
    return 42 + labelSize.height + imageAdjust;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)deleteButtonClicked:(UIButton *)button{
    
    UITableViewCell *cell = (UITableViewCell*)[button.superview superview];
    UITableView* table=(UITableView*)[[cell superview] nextResponder];
    NSIndexPath* index=[table indexPathForCell:cell];
    
    NSLog(@"%@",index);
    [tableData removeObjectAtIndex:index.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除成功" message:@"成功删除了该条评论。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alertView show];
    
}


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

