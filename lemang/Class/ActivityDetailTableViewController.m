//
//  ActivityDetailTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-11.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "ActivityDetailTableViewController.h"

@interface ActivityDetailTableViewController ()

@end

@implementation ActivityDetailTableViewController

@synthesize activity;
@synthesize titleLabel,activityDescription;
@synthesize amount, hot, joinState,address,time;
@synthesize titleImgView;

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
    titleLabel.text = activity.title;
    amount.text = activity.member;
    hot.text = activity.fav;
    titleImgView.image = activity.cachedImg;
    address.text = activity.title;
    time.text = activity.date;
    activityDescription.text = @"中国工商银行（全称：中国工商银行股份有限公司）成立于1984年，是中国五大银行之首，世界五百强企业之一，拥有中国最大的客户群，是中国最大的商业银行。 中国工商银行是中国最大的国有独资商业银行，基本任务是依据国家的法律和法规，通过国内外开展融资活动筹集社会资金，加强信贷资金管理，支持企业生产和技术改造，为我国经济建设服务。";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self refreshActivityDetail];
}

- (void)didReceiveMemoryWarning
{    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshActivityDetail
{
    if (activity == nil)
        return;
    
    NSString* URLString = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/api/v1/activity/%@", activity.activityId];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    // NSString *authInfo = @"Basic user:user";
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
    
    [URLRequest setHTTPMethod:@"GET"];
    [URLRequest setValue:@"application/json;charset=UTF-8" forHTTPHeaderField: @"Content-Type"];
    // [URLRequest setValue:authInfo forHTTPHeaderField:@"Authorization"];
    
    NSError * error;
    
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
    activityData = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingAllowFragments error:nil];
    
    NSString* detailInfo = @"";//activityData[@"description"];
    detailInfo = [detailInfo stringByAppendingFormat:@"%@", activityData[@"description"]];
    
    _detailContent.text = detailInfo;
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
