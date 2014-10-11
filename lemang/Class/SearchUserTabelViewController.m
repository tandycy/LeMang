//
//  SearchUserTabelViewController.m
//  LeMang
//
//  Created by LZ on 10/9/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "SearchUserTabelViewController.h"
#import "MemberInfoTableViewController.h"
#import "AddFriendCell.h"
#import "Friend.h"

@interface SearchUserTabelViewController ()

@end

@implementation SearchUserTabelViewController
{
    NSMutableArray* resultArray;
}

- (void) SetIdArray:(NSArray *)array
{
    friendIdArray = array;
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _searchBar.delegate = self;
    resultArray = [[NSMutableArray alloc]init];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    if (resultArray)
        [resultArray removeAllObjects];
    else
        resultArray = [[NSMutableArray alloc]init];
    
    NSString* urlString = @"http://e.taoware.com:8080/quickstart/api/v1/user/q?search_LIKE_loginName=";
    urlString = [urlString stringByAppendingString:searchBar.text];
    
    NSURL* URL = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setUsername:[UserManager UserName]];
    [request setPassword:[UserManager UserPW]];
    
    [request startSynchronous];

    NSError* error = [request error];
    
    if (!error)
    {
        NSData* loginData = [request responseData];
        NSArray* userData = [NSJSONSerialization JSONObjectWithData:loginData options:NSJSONReadingAllowFragments error:nil][@"content"];
        
        for (int i = 0; i < userData.count; i++)
        {
            NSDictionary* item = userData[i];
            
            NSString* name = item[@"loginName"];
            
            if ([name isEqualToString:@"user"] || [name isEqualToString:@"admin"])
                continue;
            
            NSNumber* uid = item[@"id"];
            
            if (uid.longValue != [[UserManager Instance]GetLocalUserId].longValue)
                [resultArray addObject:item];
        }
    }
    
    [self.tableView reloadData];
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
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    AddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddFriendCell"];
    
    if (cell==nil) {
        cell = [[AddFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddFriendCell"];
    }
    
    NSDictionary* udata = resultArray[indexPath.row];
    NSNumber* uid = udata[@"id"];
    bool isFriend = false;
    for (NSNumber* num in friendIdArray)
    {
        if (num.longValue == uid.longValue)
        {
            isFriend = true;
            break;
        }
    }
    
    [cell SetOwner:self];
    [cell SetData:udata isFriend:isFriend];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MemberInfoTableViewController *MemberInfoTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MemberInfoTableViewController"];
    
    NSDictionary* item = resultArray[indexPath.row];
    NSNumber* fId = item[@"id"];
    
    MemberInfoTVC.navigationItem.title = @"用户信息";
    [MemberInfoTVC SetMemberId:fId];
    [self.navigationController pushViewController:MemberInfoTVC animated:YES];
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
