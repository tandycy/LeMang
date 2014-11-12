//
//  HomeTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14/10/28.
//  Copyright (c) 2014年 gxcm. All rights reserved.
//

#import "HomeTableViewController.h"
#import "Constants.h"
#import "HomeDetailViewController.h"
#import "FPPopoverController.h"
#import "MJRefresh.h"
#import "HomeViewCell.h"
#import "InitViewController.h"

@interface HomeTableViewController ()

@end

@implementation HomeTableViewController
{
    int currentPage;
    int nextPage;
    int pageSize;
    int maxPage;
    
    BOOL firstOpen;
    UIScrollView *scrollView;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        firstOpen = true;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UserManager Instance] LogInCheck];
    
 //   if (firstOpen) {

  //      firstOpen = false;
  //  }
 //   else [scrollView removeFromSuperview];
    InitViewController *firstView = [[InitViewController alloc]init];
    
    [self presentModalViewController:firstView animated:NO];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self RefreshNewList];
}

- (void)headerRereshing
{
    // 1.添加数据
    [self RefreshNewList];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

- (void)InitFooterHeader
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerReleaseToRefreshText = @"释放刷新";
    self.tableView.headerRefreshingText = @"数据刷新中...";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据";
    self.tableView.footerRefreshingText = @"数据加载中...";
}

- (void)footerRereshing
{
    // 1.添加数据
    [self AppendNewsData];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}

- (void)RefreshNewList
{
    currentPage = 0;
    nextPage = 1;
    pageSize = 10;
    
    if (newsDataArray == nil)
        newsDataArray = [[NSMutableArray alloc]init];
    [newsDataArray removeAllObjects];
    
    [self AppendNewsData];
}

- (void)AppendNewsData
{
    if (currentPage == nextPage)
    {
        NSLog(@"news at final page: %d, refresh cancel", currentPage);
        return;
    }
    NSLog(@"append news data for page: %d", nextPage);
    
    NSString* URLString = @"http://e.taoware.com:8080/quickstart/api/v1/system/news?page=";
    URLString = [URLString stringByAppendingFormat:@"%d&page.size=%d&sortType=auto", nextPage, pageSize];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:URL];
    [request setUsername:@"admin"];
    [request setPassword:@"admin"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    int returnCode = [request responseStatusCode];
    
    if (!error)
    {
        NSDictionary* returnData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil];
        NSArray* orgArray = returnData[@"content"];
        
        NSNumber* totalPage = returnData[@"totalPages"];
        maxPage = totalPage.integerValue;
        
        currentPage = nextPage;
        if (currentPage == maxPage)
            nextPage = maxPage;
        else
            nextPage = currentPage+1;
        
        for (NSDictionary* item in orgArray)
        {
            [newsDataArray addObject:item];
        }
        
        [self.tableView reloadData];
    }
    else
    {
        //
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return newsDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell==nil) {
        cell = [[HomeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeCell"];
    }
    
    [cell SetNews:newsDataArray[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeDetailViewController *HDVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeDetailViewController"];
    [self.navigationController pushViewController:HDVC animated:YES];
    
    //[HDVC setTitle:newsDataArray[indexPath.row][@"title"]];
    [HDVC setTitle:@"资讯详情"];
    
    [HDVC SetNewsData:newsDataArray[indexPath.row]];
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

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController.tabBar setUserInteractionEnabled:YES];
    [self.tabBarController.tabBar setTintColor:defaultMainColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIFont fontWithName:defaultBoldFont size:20.0], UITextAttributeFont,
                                                                     nil]];
    [self.navigationController.navigationBar setBarTintColor:defaultMainColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

@end
