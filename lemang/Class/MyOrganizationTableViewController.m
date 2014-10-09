//
//  MyOrganizationTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "MyOrganizationTableViewController.h"
#import "OrganizationDetailTableViewController.h"

@interface MyOrganizationTableViewController ()

@end

@implementation MyOrganizationTableViewController
{
    NSMutableArray* titleArray;
}

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
    
    
    titleArray = [[NSMutableArray alloc] initWithObjects:@"管理的组织", @"参加的组织", @"收藏的组织", nil];
    
    [self ClearDataArray];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self RefreshOrganizationList];
}

- (void)ClearDataArray
{
    orgAdminList = [[NSMutableArray alloc]init];
    orgBookmarkList = [[NSMutableArray alloc]init];
    orgJoinList = [[NSMutableArray alloc]init];
}

- (void)RefreshOrganizationList
{
    int uid = [[UserManager Instance]GetLocalUserId];
    
    NSString* URLString = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    URLString = [URLString stringByAppendingFormat:@"%d/associations", uid];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    ASIHTTPRequest *URLRequest = [ASIHTTPRequest requestWithURL:URL];
    [URLRequest setUsername:@"admin"];
    [URLRequest setPassword:@"admin"];
    
    [URLRequest startSynchronous];
    
    NSError *error = [URLRequest error];
    
    if (!error)
    {
        NSArray* returnData = [NSJSONSerialization JSONObjectWithData:[URLRequest responseData] options:NSJSONReadingAllowFragments error:nil][@"content"];
        
        for (int i = 0; i < returnData.count; i++)
        {
            NSDictionary* item = returnData[i];
            NSDictionary* creator = item[@"createdBy"];
            NSNumber* cid = creator[@"id"];
            
            if (uid == cid.integerValue)
            {
                [orgAdminList addObject:item];
            }
            else
            {
                [orgJoinList addObject:item];
            }
        }
    }
    else
    {
        // TODO
    }
    
    NSString* bookmarkStr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    bookmarkStr = [bookmarkStr stringByAppendingFormat:@"%d/bookmark/group", uid];
    NSURL *bookmarkUrl = [NSURL URLWithString:URLString];
    
    ASIHTTPRequest *bookmarkRequest = [ASIHTTPRequest requestWithURL:bookmarkUrl];
    [bookmarkRequest setUsername:@"admin"];
    [bookmarkRequest setPassword:@"admin"];
    
    [URLRequest startSynchronous];
    
    error = [URLRequest error];
    
    if (!error)
    {
        NSArray* returnData = [NSJSONSerialization JSONObjectWithData:[URLRequest responseData] options:NSJSONReadingAllowFragments error:nil][@"content"];
        
        for (int i = 0; i < returnData.count; i++)
        {
            NSDictionary* item = returnData[i];
            [orgBookmarkList addObject:item];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (section == 0)
        return orgAdminList.count;
    
    if (section == 1)
        return orgJoinList.count;
    
    if (section == 2)
        return orgBookmarkList.count;
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrgCell" forIndexPath:indexPath];
    
    if (cell==nil) {
        cell = [[MyOrgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyOrgCell"];
    }
    
    // Configure the cell...
    int section = indexPath.section;
    NSDictionary* actData = nil;
    
    if (section == 0)
    {
        actData = orgAdminList[indexPath.row];
        [cell SetAdmin];
    }
    else if (section == 1)
    {
        actData = orgJoinList[indexPath.row];
        [cell SetJoin];
    }
    else if (section == 2)
    {
        actData = orgBookmarkList[indexPath.row];
        [cell SetBookmark];
    }
    
    [cell SetData:actData :self];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrganizationDetailTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrganizationDetailView"];
    viewController.navigationItem.title = @"组织详细页面";

    
    NSDictionary* actData = nil;
    
    if (indexPath.section == 0)
    {
        actData = orgAdminList[indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        actData = orgJoinList[indexPath.row];
    }
    else if (indexPath.section == 2)
    {
        actData = orgBookmarkList[indexPath.row];
    }
    
    [viewController SetOrgnizationData:actData];    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    [view setBackgroundColor:[UIColor colorWithRed:0.95294117647059 green:0.95294117647059 blue:0.95294117647059 alpha:1]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
    
    label.textColor = [UIColor colorWithRed:0.94117647 green:0.42352941 blue:0.11764706 alpha:1];
    
    label.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:13];
    
    label.backgroundColor = [UIColor clearColor];
    
    label.text = [titleArray objectAtIndex:section];
    
    [view addSubview:label];
    
    return view;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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
