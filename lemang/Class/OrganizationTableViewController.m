//
//  OrganizationTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-19.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "OrganizationTableViewController.h"
#import "Constants.h"

@interface OrganizationTableViewController ()

@end

@implementation OrganizationTableViewController

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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self refreshOrganizationData];//refresh here
    
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

- (void) refreshOrganizationData
{
    NSString* URLString = @"http://e.taoware.com:8080/quickstart/api/v1/association";
    NSURL *URL = [NSURL URLWithString:URLString];
    
    // NSString *authInfo = @"Basic user:user";
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
    
    [URLRequest setHTTPMethod:@"GET"];
    [URLRequest setValue:@"application/json;charset=UTF-8" forHTTPHeaderField: @"Content-Type"];
    // [URLRequest setValue:authInfo forHTTPHeaderField:@"Authorization"];
    
    NSError * error;
    NSURLResponse * response;
    NSData * returnData = [NSURLConnection sendSynchronousRequest:URLRequest returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"a connection could not be created or request fails.");
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    //[req addValue:0 forHTTPHeaderField:@"Content-Length"];
    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:URLRequest delegate:self];
    
    receivedData=[[NSMutableData alloc] initWithData:nil];
    
    if (connection) {
        receivedData = [NSMutableData new];
        NSLog(@"rdm%@",receivedData);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential;
        newCredential=[NSURLCredential credentialWithUser:@"user" password:@"user"                                              persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

#pragma mark- NSURLConnection 回调方法
- (void)connection:(NSURLConnection *)aConn didReceiveResponse:(NSURLResponse *)response

{
    // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        //NSLog(@"[email=dictionary=%@]dictionary=%@",[dictionary[/email] description]);        
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}
-(void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {
    NSLog(@"%@",[error localizedDescription]);
}
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    NSLog(@"请求完成…");
    organizationData = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingAllowFragments error:nil][@"content"];
    
    for (int i = 0; i < organizationData.count; i++)
    {
        NSArray* data = organizationData[i];
    }
}

#pragma mark - Table view data source

/*
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
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"OrganizationTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...s
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    
    
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"org_back.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"org_back_down.png"]];
    
    
    UILabel *memberNumberBack = [[UILabel alloc]initWithFrame:CGRectMake(11, 62, 70, 15)];
    UIImageView *memberNumberBackImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"like_number_back.png"]];
    [memberNumberBack addSubview:memberNumberBackImg];
    [cell addSubview:memberNumberBack];
    
    UILabel *memberNumber = [[UILabel alloc]initWithFrame:CGRectMake(36, 63, 45, 14)];
    memberNumber.text = @"100";
    memberNumber.font = [UIFont fontWithName:defaultFont size:13];
    memberNumber.textColor = [UIColor whiteColor];
    [cell addSubview:memberNumber];
    
    UILabel *memberIcon = [[UILabel alloc]initWithFrame:CGRectMake(18, 63, 10, 10)];
    UIImageView *memberIconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"member_number.png"]];
    [memberIcon addSubview:memberIconImg];
    [cell addSubview:memberIcon];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
 */

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController.tabBar setUserInteractionEnabled:YES];
    //[activitySearchBar setHidden:NO];
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
