//
//  MyMessageTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "MyMessageTableViewController.h"

@interface MyMessageTableViewController ()

@end

@implementation MyMessageTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        messageList = [[NSMutableArray alloc]init];
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
    messageList = [[NSMutableArray alloc]init];
    [self RefreshMessageList];
    [self RefreshActivityEnrollmentList];
    [self RefreshOrgEnrollmentList];
}

- (void) RefreshMessageList
{
    if (![UserManager IsInitSuccess])
        return;
    
    NSString* urlString = @"http://e.taoware.com:8080/quickstart/api/v1/user/message/q?search_EQ_to.id=";
    urlString = [urlString stringByAppendingFormat:@"%d", [[UserManager Instance]GetLocalUserId]];
    NSURL* URL = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:URL];
    [request startSynchronous];
    
    NSError* error = [request error];
    if (!error)
    {
        NSArray* data = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil][@"content"];
        //messageList = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < data.count; i++)
        {
            NSDictionary* item = data[i];
            [messageList addObject:item];
        }
    }
}

- (void) RefreshActivityEnrollmentList
{
    if (![UserManager IsInitSuccess])
        return;
    
    NSString* urlString = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    urlString = [urlString stringByAppendingFormat:@"%d", [[UserManager Instance]GetLocalUserId]];
    urlString = [urlString stringByAppendingString:@"/message/activity"];
    NSURL* URL = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:URL];
    [request startSynchronous];
    
    NSError* error = [request error];
    if (!error)
    {
        NSArray* data = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil][@"content"];
        //messageList = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < data.count; i++)
        {
            NSDictionary* item = data[i];
            [messageList addObject:item];
        }
    }
}

- (void) RefreshOrgEnrollmentList
{
    if (![UserManager IsInitSuccess])
        return;
    
    NSString* urlString = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    urlString = [urlString stringByAppendingFormat:@"%d", [[UserManager Instance]GetLocalUserId]];
    urlString = [urlString stringByAppendingString:@"/message/association"];
    NSURL* URL = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:URL];
    [request startSynchronous];
    
    NSError* error = [request error];
    if (!error)
    {
        NSArray* data = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil][@"content"];
        //messageList = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < data.count; i++)
        {
            NSDictionary* item = data[i];
            [messageList addObject:item];
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return messageList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msgCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell==nil) {
        cell =  [[MyMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"msgCell"];
    }
    
    NSDictionary* messageData = messageList[indexPath.row];
    
    [cell SetMessageData:messageData owner:self];

    return cell;
}

- (void)OnMessageDelete:(MyMessageCell *)cell
{
    if (![UserManager IsInitSuccess])
        return; // should not happen
    
    // TODO: put delete request
    NSString* urlString = @"http://e.taoware.com:8080/quickstart/api/v1/user/message/";
    urlString = [urlString stringByAppendingFormat:@"%@", [cell GetMessageId]];
    
    ASIHTTPRequest* readRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [readRequest setRequestMethod:@"DELETE"];
    [readRequest startSynchronous];
    
    NSError* error = [readRequest error];
    int returncode = [readRequest responseStatusCode];
    if (error)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法删除评论" message:@"网络连接错误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        return;
    }
    else if (returncode != 200)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法删除评论" message:@"服务器内部错误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        return;
    }
    else
    {
        // refresh list
        NSIndexPath* index = [self.tableView indexPathForCell:cell];
        
        [messageList removeObjectAtIndex:index.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadData];
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyMessageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell)
    {
        // should not happen
        return;
    }
    
    [cell OnRead];
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
