//
//  MemberInfoTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-16.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "MemberInfoTableViewController.h"

@interface MemberInfoTableViewController ()

@end

@implementation MemberInfoTableViewController

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
    
    [self ClearDisplay];
    [self RefreshDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) ClearDisplay
{
    _departName.text = @"";
    _userNickName.text = @"";
    _phoneNumber.text = @"";
    _qqNumber.text = @"";
    _wechatId.text = @"";
    _schoolName.text = @"";
    _schoolNumber.text = @"";
    _userSign.text = @"";
    _userName.text = @"";
    
    [_userIcon setImage:[UserManager DefaultIcon]];
}

- (NSString*) filtStr:(NSString*)inputStr
{
    NSString* result = @"";
    
    result = [result stringByAppendingFormat:@"%@", inputStr];
    
    return result;
}

- (void) SetMemberId:(NSNumber*)userId
{
    memberId = userId;
}

- (void) RefreshDisplay
{
    if (memberId == nil)
        return;
    
    NSString* userUrlStr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    userUrlStr = [userUrlStr stringByAppendingFormat:@"%@", memberId];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:userUrlStr]];
    [request setUsername:@"admin"];    
    [request setPassword:@"admin"];
    
    [request startSynchronous];
    
    NSError* error = [request error];
    
    if (error)
    {
        NSLog(@"user error: %@",error);
        return;
    }
    
    int rcode = [request responseStatusCode];
    //NSLog(@"code %d",rcode);
    NSDictionary* userData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil];
    
    _userName.text = @"未认证用户";
    _schoolName.text = [self filtStr:userData[@"university"][@"name"]];
    _departName.text =[self filtStr:userData[@"department"][@"name"]];
    
    NSDictionary* profileData = userData[@"profile"];
    
    if ([profileData isKindOfClass:[NSDictionary class]])
    {
        _userName.text = [self filtStr:profileData[@"fullName"]];
        _userNickName.text = [self filtStr:profileData[@"nickName"]];
        _userSign.text = [self filtStr:profileData[@"signature"]];
        _schoolNumber.text = [self filtStr:profileData[@"code"]];
        
        NSString* urlStr = profileData[@"iconUrl"];
        urlStr = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/resources%@", urlStr];
        [_userIcon LoadFromUrl:[NSURL URLWithString:urlStr]:[UserManager DefaultIcon]];
    }
    
    NSDictionary* contactData = userData[@"contacts"];
    
    if ([contactData isKindOfClass:[NSDictionary class]])
    {
        _phoneNumber.text = [self filtStr:contactData[@"CELL"]];
        _qqNumber.text = [self filtStr:contactData[@"QQ"]];
        _wechatId.text = [self filtStr:contactData[@"WECHAT"]];
    }
}
/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
