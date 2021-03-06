//
//  MyFriendsTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "MyFriendsTableViewController.h"
#import "MemberInfoTableViewController.h"
#import "Friend.h"
#import "SearchUserTabelViewController.h"
#import "Constants.h"

@interface MyFriendsTableViewController ()
{
    NSMutableArray *friendArray;
    NSMutableArray *filteredFriendArray;
    
    NSMutableArray *friendIdArray;
}

@end

@implementation MyFriendsTableViewController

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
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]init];
    rightButton.image = [UIImage imageNamed:@"add"];
    [rightButton setTintColor:defaultMainColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    rightButton.target = self;
    rightButton.action = @selector(ToAddFriendPage:);
    
    [self RefreshData];
    [self setTableFooterView:self.tableView];
}

- (void)setTableFooterView:(UITableView *)tb {
    if (!tb) {
        return;
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [tb setTableFooterView:view];
}

-(IBAction)ToAddFriendPage:(id)sender
{
    SearchUserTabelViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchUserTabelViewController"];
    searchVC.navigationItem.title = @"查找和添加好友";
    [searchVC SetIdArray:friendIdArray];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)RefreshData
{
    filteredFriendArray = [NSMutableArray arrayWithCapacity:[friendArray count]];
    
    friendArray = [[NSMutableArray alloc]init];
    friendIdArray = [[NSMutableArray alloc]init];
    
    if (![UserManager IsInitSuccess])
        return;
    
    NSNumber* uid = [[UserManager Instance]GetLocalUserId];
    
    NSString* friendStr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    friendStr = [friendStr stringByAppendingFormat:@"%@/friend/q", uid];
    
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
        
        [friendIdArray addObject:fitem.userId];
    }
    
    
    [self.tableView reloadData];
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
    MyFriendCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyFriendCell"];
    // Configure the cell...
    
    Friend *friend = nil;
    
    if (cell==nil) {
        cell = [[MyFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyFriendCell"];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        friend = [filteredFriendArray objectAtIndex:indexPath.row];
    }
    else
    {
        friend = [friendArray objectAtIndex:indexPath.row];
    }
    
    [cell SetItem:friend :self];
   
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

- (void) DoRemoveFriend:(MyFriendCell*)linkedCell
{
    NSNumber* fid = [linkedCell GetFriendId];
    NSNumber* uid = [[UserManager Instance]GetLocalUserId];
    
    NSString* removeStr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    removeStr = [removeStr stringByAppendingFormat:@"%@/friend/%@", uid, fid];
    
    ASIHTTPRequest* removeRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:removeStr]];
    [removeRequest setRequestMethod:@"DELETE"];
    [removeRequest startSynchronous];
    
    NSError* error = [removeRequest error];
    
    if (!error)
    {
        int returnCode = [removeRequest responseStatusCode];
        
        if (returnCode == 200)
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"删除好友成功" message:@"成功移除好友" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            NSString* messageContent = [NSString stringWithFormat:@"服务器错误%d",returnCode];
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"删除好友失败" message:messageContent delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
            [alertView show];
        }
        
        [self RefreshData];
        
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"删除好友失败" message:@"网络连接错误" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
        [alertView show];
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
    [self initNavBar];
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

-(void)initNavBar
{
    [self setBackButton];
    [self changeToWhite];
}

-(void)setBackButton
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_back"] style:UIBarButtonItemStylePlain target:self action:@selector(navBackClick:)];
    [backButton setTintColor:defaultMainColor];
    self.navigationItem.leftBarButtonItem = backButton;
}

-(IBAction)navBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)changeToWhite
{
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     defaultMainColor, UITextAttributeTextColor,
                                                                     [UIFont fontWithName:defaultBoldFont size:20.0], UITextAttributeFont,
                                                                     nil]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

@end
