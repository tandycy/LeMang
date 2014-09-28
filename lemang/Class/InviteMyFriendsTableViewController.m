//
//  InviteMyFriendsTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-25.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "InviteMyFriendsTableViewController.h"
#import "InviteFriendCell.h"
#import "MemberInfoTableViewController.h"
#import "Friend.h"

@interface InviteMyFriendsTableViewController ()
{
    NSMutableArray *friendArray;
    NSMutableArray *filteredFriendArray;
}
@end

@implementation InviteMyFriendsTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self dataInit];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) SetInviteActivity:(NSNumber *)aid
{
    inviteType = Activity;
    inviteId = aid;
}

- (void) SetInviteGroup:(NSNumber *)gid
{
    inviteType = Group;
    inviteId = gid;
}

-(void)dataInit
{
    filteredFriendArray = [NSMutableArray arrayWithCapacity:[friendArray count]];
    
    friendArray = [[NSMutableArray alloc]init];
    
    if (![UserManager IsInitSuccess])
        return;
    
    int uid = [[UserManager Instance]GetLocalUserId];
    
    NSString* friendStr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    friendStr = [friendStr stringByAppendingFormat:@"%d/friend", uid];
    
    ASIHTTPRequest* friendRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:friendStr]];
    [friendRequest startSynchronous];
    
    NSError* error = [friendRequest error];
    
    if (error)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"获取好友列表失败" message:@"网络连接错误" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    NSArray* respData = [NSJSONSerialization JSONObjectWithData:[friendRequest responseData] options:NSJSONReadingAllowFragments error:nil][@"content"];
    
    for (int i = 0; i < respData.count; i++)
    {
        NSDictionary* item = respData[i];
        Friend* fitem = [[Friend alloc]init];
        [fitem SetData:item];
        [friendArray addObject:fitem];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredFriendArray count];
    }
    else
    {
        return [friendArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MemberInfoTableViewController *MemberInfoTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MemberInfoTableViewController"];
    
    Friend* fitem = friendArray[indexPath.row];
    
    MemberInfoTVC.navigationItem.title = [NSString stringWithFormat:@"%@的账户",fitem.userName];
    [MemberInfoTVC SetMemberId:fitem.userId];
    [self.navigationController pushViewController:MemberInfoTVC animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InviteFriendCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"InviteFriendCell"];
    // Configure the cell...
    
    Friend *friend = nil;
    
    if (cell==nil) {
        cell = [[InviteFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InviteFriendCell"];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        friend = [filteredFriendArray objectAtIndex:indexPath.row];
    }
    else
    {
        friend = [friendArray objectAtIndex:indexPath.row];
    }
    
    [cell SetItem:friend];
    [cell SetOwner:self];
    
    return cell;
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [filteredFriendArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.userName contains[c] %@",searchText];
    filteredFriendArray = [NSMutableArray arrayWithArray:[friendArray filteredArrayUsingPredicate:predicate]];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchString:(NSString *)searchString {
    [self.searchDisplayController.searchResultsTableView setRowHeight:70];
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self.searchDisplayController.searchResultsTableView setRowHeight:70]; //set searchResultTable Row Height
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
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

- (void) DoInviteFriend:(Friend *)friendItem
{
    NSString* urlStr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    int localId = [[UserManager Instance]GetLocalUserId];
    urlStr = [urlStr stringByAppendingFormat:@"%d/invite/%@", localId, friendItem.userId];
    
    if (inviteType == Activity)
    {
        urlStr = [urlStr stringByAppendingFormat:@"/activity/%@", inviteId];
    }
    else  if (inviteType == Group)
    {
        urlStr = [urlStr stringByAppendingFormat:@"/association/%@", inviteId];
    }
    else
        return;
    
    ASIHTTPRequest *inviteRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [inviteRequest addRequestHeader:@"Content-Type" value:@"application/json;charset=UTF-8"];
    [inviteRequest setRequestMethod:@"POST"];
    [inviteRequest setUsername:[UserManager UserName]];
    [inviteRequest setPassword:[UserManager UserPW]];
    [inviteRequest startSynchronous];
    
    NSError *error = [inviteRequest error];
    
    if (!error)
    {
        int returnCode = [inviteRequest responseStatusCode];
        
        if (returnCode == 200)
        {
            NSString* content = [NSString stringWithFormat:@"已向好友<%@>发送邀请。",friendItem.userName];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功邀请" message:content delegate:nil cancelButtonTitle:@"完成" otherButtonTitles: nil];
            [alertView show];
        }
        else
            NSLog(@"Invite failed: %d", returnCode);
    }
}

@end
