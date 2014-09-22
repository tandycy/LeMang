//
//  MyFriendsTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "MyFriendsTableViewController.h"
#import "MyFriendCell.h"
#import "MemberInfoTableViewController.h"
#import "Friend.h"

@interface MyFriendsTableViewController ()
{
    NSMutableArray *friendArray;
    NSMutableArray *filteredFriendArray;
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
    
    [self dataInit];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dataInit
{
    filteredFriendArray = [NSMutableArray arrayWithCapacity:[friendArray count]];
    
    friendArray = [[NSMutableArray alloc]init];
    Friend *aaa1 = [Friend friendOfCategory:@"best" userId:[NSNumber numberWithInt:1] userName:@"aaa1" userSchool:@"上海交大" userCollege:@"软件工程"];
    Friend *bbb2 = [Friend friendOfCategory:@"next" userId:[NSNumber numberWithInt:2] userName:@"bbb2" userSchool:@"上海同济" userCollege:@"机械工程"];
    Friend *ccc3 = [Friend friendOfCategory:@"lower" userId:[NSNumber numberWithInt:3] userName:@"ccc3" userSchool:@"上海复旦" userCollege:@"土木工程"];
    
    friendArray[0] = aaa1;
    friendArray[1] = bbb2;
    friendArray[2] = ccc3;
    
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
    
    MemberInfoTVC.navigationItem.title = @"XX的账户";
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
    
    cell.userName.text = friend.userName;
    cell.userCollege.text = friend.userCollege;
    cell.userSchool.text = friend.userSchool;
    
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

@end
