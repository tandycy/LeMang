//
//  OrganizationTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-19.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "OrganizationTableViewController.h"
#import "SelectTableViewController.h"
#import "Constants.h"
#import "MJRefresh.h"
#import "SearchTableViewController.h"

@interface OrganizationTableViewController ()
{
    //OrganizationViewCell *cell;
}

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
    [self setupRefresh];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self refreshOrganizationData];//refresh here
    
    //[self.navigationController.navigationBar setBackgroundColor:defaultMainColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.searchButton addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [UserManager RefreshGroupData];
    [UserManager RefreshTagData];
}

-(IBAction)searchClick:(id)sender
{
    SearchTableViewController *searchView = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchTableViewController"];
    [searchView SetSearchOrganization];
    [self.navigationController pushViewController:searchView animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.localTabelView addHeaderWithTarget:self action:@selector(headerRereshing)];
//#warning 自动刷新(一进入程序就下拉刷新)
    [self.localTabelView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.localTabelView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.localTabelView.headerPullToRefreshText = @"下拉刷新";
    self.localTabelView.headerReleaseToRefreshText = @"释放刷新";
    self.localTabelView.headerRefreshingText = @"数据刷新中...";
    
    self.localTabelView.footerPullToRefreshText = @"上拉可以加载更多数据";
    self.localTabelView.footerReleaseToRefreshText = @"松开马上加载更多数据";
    self.localTabelView.footerRefreshingText = @"数据加载中...";
}

- (void)headerRereshing
{
    // 1.添加数据
    [self refreshOrganizationData];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.localTabelView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.localTabelView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    // 1.添加数据
    [self appendOrganizationData];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.localTabelView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.localTabelView footerEndRefreshing];
    });
}

- (void) refreshOrganizationData
{
    //
    currentPage = 0;
    nextPage = 1;
    pageSize = 10;
    
    if (organizationArray == nil)
        organizationArray = [[NSMutableArray alloc]init];
    [organizationArray removeAllObjects];
    [self appendOrganizationData];
}

- (void) appendOrganizationData
{
    if (currentPage == nextPage)
    {
        NSLog(@"organization at final page: %d, refresh cancel", currentPage);
        return;
    }
    NSLog(@"append organization data for page: %d", nextPage);
    
    NSString* URLString = @"http://e.taoware.com:8080/quickstart/api/v1/association/q?page=";
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
            [organizationArray addObject:item];
        }
        
        [_localTabelView reloadData];
    }
    else
    {
        //
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
    return organizationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"OrganizationTableCell";
    
    OrganizationViewCell *cell = [_localTabelView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...s
    if (cell == nil)
    {
        cell = [_localTabelView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    
    NSDictionary* orgData = organizationArray[indexPath.row];
    
    [cell updateData:orgData];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrganizationDetailTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrganizationDetailView"];
    viewController.navigationItem.title = @"社群详细页面";
    
    static NSString *cellIdentifier = @"OrganizationTableCell";
    OrganizationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...s
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    
    [cell updateData:organizationArray[indexPath.row]];
    
    //[viewController SetOrgnizationData:[cell getLocalData]];
    [viewController SetOrgnizationId:[cell getOrgId]];
    //NSLog(@"%@",cell);
    
    [self.navigationController pushViewController:viewController animated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController.tabBar setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar setBarTintColor:defaultMainColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //[activitySearchBar setHidden:NO];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.localTabelView reloadData];
    [self.localTabelView headerEndRefreshing];
}


-(void)popover:(id)sender
{
    //the controller we want to present as a popover
    SelectTableViewController *controller = [[SelectTableViewController alloc] initWithStyle:UITableViewStylePlain];
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller];

    controller.title = @"请选择您需要筛选的关键字";
    [controller SetAsOrganization:self :popover];
    
    //popover.arrowDirection = FPPopoverArrowDirectionAny;
    popover.tint = FPPopoverYellowTinit;
    popover.contentSize = CGSizeMake(200, 400);
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    //sender is the UIButton view
    [popover presentPopoverFromView:sender];
}


- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController
{
    [visiblePopoverController dismissPopoverAnimated:YES];
}

-(IBAction)topLeft:(id)sender
{
    [self popover:sender];
    NSLog(@"popover");
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

- (void) OnCreateDone
{
    [UserManager RefreshGroupData];
    [self refreshOrganizationData];
}

- (IBAction)OnCreateOrganization:(id)sender {
    
    if (![UserManager IsInitSuccess])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户未登录" message:@"登陆后才能执行该操作。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        return;
    }
    
    if (![UserManager IsUserAuthen])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户未认证" message:@"只有认证用户才能创建社群。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        return;
    }
    
    CreateOrganizationTableViewController *createOrgVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateOrganizationTableViewController"];
    [createOrgVC SetOwner:self];
    [self.navigationController pushViewController:createOrgVC animated:YES];
}
@end
