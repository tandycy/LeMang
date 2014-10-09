//
//  SearchUserTabelViewController.m
//  LeMang
//
//  Created by LZ on 10/9/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "SearchUserTabelViewController.h"
#import "AddFriendCell.h"

@interface SearchUserTabelViewController ()

@end

@implementation SearchUserTabelViewController
{
    NSMutableArray* resultArray;
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
            
            NSNumber* uid = item[@"id"];
            
            if (uid.integerValue != [[UserManager Instance]GetLocalUserId])
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
    
    [cell SetData:resultArray[indexPath.row]];
    return cell;
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
