//
//  ActivityCommentTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-14.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "ActivityCommentTableViewController.h"
#import "ActivityComment.h"
#import "Constants.h"

@interface ActivityCommentTableViewController ()
{
    NSMutableArray *tableData;
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

-(void)createUserData{
    
    tableData = [[NSMutableArray alloc]init];
    
    NSMutableArray *imgs = [[NSMutableArray alloc]init];
    imgs[0] = [UIImage imageNamed:@"doge.jpg"];
    imgs[1] = [UIImage imageNamed:@"head.jpg"];
    imgs[2] = [UIImage imageNamed:@"group1.png"];
    
    ActivityComment *comment1 = [[ActivityComment alloc]init];
    comment1 = [ActivityComment commentsOfCategory:@"comment1" commentName:@"追女神未果的屌丝" commentIcon:[UIImage imageNamed:@"doge.jpg"] commentTitle:@"好看的电影" commentDetail:@"今天看了超好看的电影，我真是这辈子都无憾了！" commentImg:imgs];
    
    ActivityComment *comment2 = [[ActivityComment alloc]init];
    comment2 = [ActivityComment commentsOfCategory:@"comment1" commentName:@"我是楼上的爸爸" commentIcon:[UIImage imageNamed:@"doge.jpg"] commentTitle:@"好看的电影" commentDetail:@"今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！" commentImg:imgs];
    
    ActivityComment *comment3 = [[ActivityComment alloc]init];
    comment3 = [ActivityComment commentsOfCategory:@"comment1" commentName:@"我只能抢板凳了" commentIcon:[UIImage imageNamed:@"doge.jpg"] commentTitle:@"好看的电影" commentDetail:@"今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！" commentImg:imgs];
    ActivityComment *comment4 = [[ActivityComment alloc]init];
    comment4 = [ActivityComment commentsOfCategory:@"comment1" commentName:@"有地板坐坐也不错" commentIcon:[UIImage imageNamed:@"doge.jpg"] commentTitle:@"好看的电影" commentDetail:@"今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！" commentImg:imgs];
    ActivityComment *comment5 = [[ActivityComment alloc]init];
    comment5 = [ActivityComment commentsOfCategory:@"comment1" commentName:@"你们这帮水笔" commentIcon:[UIImage imageNamed:@"doge.jpg"] commentTitle:@"好看的电影" commentDetail:@"今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！" commentImg:imgs];
    ActivityComment *comment6 = [[ActivityComment alloc]init];
    comment6 = [ActivityComment commentsOfCategory:@"comment1" commentName:@"我是版主楼上都死" commentIcon:[UIImage imageNamed:@"doge.jpg"] commentTitle:@"好看的电影" commentDetail:@"今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！今天看了超好看的电影，我真是这辈子都无憾了！" commentImg:imgs];
    
    tableData[0] = comment1;
    tableData[1] = comment2;
    tableData[2] = comment3;
    tableData[3] = comment4;
    tableData[4] = comment5;
    tableData[5] = comment6;
   // NSLog(@"%lu",(unsigned long)tableData.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentCell";
    //自定义cell类
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row & 0x1){
        cell.backgroundColor = [UIColor colorWithRed:0.95294118 green:0.95294118 blue:0.95294118 alpha:1];
    }
    else cell.backgroundColor = [UIColor whiteColor];
 
    cell.selectedBackgroundView = [[UIView alloc] init];
    
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
        UIImageView *cimg = [cell viewWithTag:(210+i)];
        if (cimg) {
            [cimg removeFromSuperview];
        }
        UIImageView *commentImg = [[UIImageView alloc]initWithFrame:CGRectMake( 70+60*i, commentDetail.frame.origin.y + commentDetail.frame.size.height+10, 50, 50)];
        commentImg.image = comment.commentImg[i];
        commentImg.tag = (210+i);
        [cell addSubview:commentImg];
    }

    UIButton *dc = [cell viewWithTag:209];
    if (dc) {
        [dc removeFromSuperview];
    }
    UIButton *deleteComment = [[UIButton alloc]initWithFrame:CGRectMake(290, commentDetail.frame.origin.y+commentDetail.frame.size.height+65, 28, 30)];
    [deleteComment setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [deleteComment setBackgroundImage:[UIImage imageNamed:@"delete_down.png"] forState:UIControlStateSelected];
    [deleteComment addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    deleteComment.tag = 209;
    [cell addSubview:deleteComment];
    
    UILabel *cd = [cell viewWithTag:208];
    if (cd) {
        [cd removeFromSuperview];
    }
    UILabel *commentDate = [[UILabel alloc]initWithFrame:CGRectMake(70, commentDetail.frame.origin.y+commentDetail.frame.size.height+70, 63, 12)];
    commentDate.text = @"8-4 14:04";
    commentDate.textColor = [UIColor colorWithRed:0.41176471 green:0.41176471 blue:0.41176471 alpha:1];
    commentDate.font = [UIFont fontWithName:defaultFont size:11];
    commentDate.tag = 208;
    [cell addSubview:commentDate];
    
    NSLog(@"%@",commentName.text);
    NSLog(@"%@",commentIcon.image);
    NSLog(@"%@",commentDetail.text);
    NSLog(@"%@",indexPath);
 
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    UILabel *commentDetail = (UILabel *)[cell viewWithTag:202];
    
    return 42 + commentDetail.frame.size.height + 90;
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

