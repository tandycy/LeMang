//
//  ActivityCommentTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-14.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "ActivityCommentTableViewController.h"
#import "ActivityDetailTableViewController.h"
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
    
    commentImageBuffer = [[NSMutableDictionary alloc]init];
    
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

- (void) SetActivityOwner:(ActivityDetailTableViewController*)_owner
{
    owner = _owner;
}

-(void)SetCommentList:(NSArray *)commentList
{
    localComments = commentList;
    [commentImageBuffer removeAllObjects];
}

-(NSMutableDictionary*)GetCommentImageBuffer
{
    return commentImageBuffer;
}

-(void)createUserData{
    
    tableData = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < localComments.count; i++)
    {
        NSDictionary* item = localComments[i];
        [tableData addObject:item];
    }
    
    cellArray = [NSMutableArray arrayWithCapacity:localComments.count];
    
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
    
    [cell SetActivityCreator:[owner GetCreatorId]];
    [cell SetComment:tableData[indexPath.row]];
    [cell SetOwner:self];
    
    return cell;
}

-(void)imageItemClick:(UIImage *)image{
    
    ActivityCommetImageDetailViewController *imgViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityCommetImageDetailViewController"];
    
    [self.navigationController pushViewController:imgViewController animated:YES];
    
    [imgViewController SetImageData:image];
    //  [self.navigationController modalViewController:viewController];
    //viewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    //viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //[self presentModalViewController:viewController animated:YES];
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

- (void) DoDeleteComment : (ActivityCommentCell*) cell
{
    UITableView* table=(UITableView*)[[cell superview] nextResponder];
    NSIndexPath* index=[table indexPathForCell:cell];
    
    NSString* delUrlStr = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/api/v1/activity/%@", [owner GetActivityId]];
    delUrlStr = [delUrlStr stringByAppendingFormat:@"/comment/%@", cell.GetCommentId];

    ASIHTTPRequest* deleteRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:delUrlStr]];
    [deleteRequest setRequestMethod:@"DELETE"];
    [deleteRequest startSynchronous];
    
    NSError* error = [deleteRequest error];
    
    if (error)
    {
        NSLog(@"Delete with error: %d - %@", error.code, error.localizedDescription);
        return;
    }
    
    NSLog(@"%d - %@", [deleteRequest responseStatusCode], [deleteRequest responseStatusMessage]);
    
    [tableData removeObjectAtIndex:index.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除成功" message:@"成功删除了该条评论。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alertView show];
    
    [owner RefreshCommentList];
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

