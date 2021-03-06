//
//  ActivityViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-7-29.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityDetailViewController.h"
#import "ActivityViewCell.h"
#import "MJRefresh.h"
#import "CreateActivityTableViewController.h"
#import "SelectTableViewController.h"
#import "SearchTableViewController.h"
#import "Constants.h"
#import "IconImageButtonLoader.h"

#define _AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES_

typedef enum {
	ActivityImg = 100,
	ActivityTitle = 101,
	ActivityDate = 102,
	ActivityLimit = 103,
	ActivityTypeIcon = 104,
	ActivityMember = 105,
    ActivityFav = 106
} ActivityListTags;

@interface ActivityViewController ()
{
    UIView *loadingView;
    bool initUpdate;
    
    int currentPage;
    int nextPage;
    int pageSize;
    int maxPage;
    
    NSMutableArray* topAds;
    NSMutableArray* topAdItems;
}

@end

@implementation ActivityViewController

@synthesize activityArray;
@synthesize activitySearchBar;
@synthesize activityList;
@synthesize filteredActivityArray;
@synthesize pageControl;
@synthesize scrollView;

NSString *navTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        activityList.delegate = self;
    }
    return self;
}

- (void)refreshActivityData
{
    currentPage = 0;
    nextPage = 1;
    pageSize = 10;
    
    if (activityArray == nil)
        activityArray = [[NSMutableArray alloc]init];
    [activityArray removeAllObjects];
    [self appendActivityData];
    
    [self refreshTopAds];
}

- (void) appendActivityData
{
    if (currentPage == nextPage)
    {
        NSLog(@"activity at final page: %d, refresh cancel", currentPage);
        return;
    }
    NSLog(@"append activity data for page: %d", nextPage);
    
    NSString* URLString = @"http://e.taoware.com:8080/quickstart/api/v1/activity?page=";
    URLString = [URLString stringByAppendingFormat:@"%d&page.size=%d&sortType=auto", nextPage, pageSize];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    // NSString *authInfo = @"Basic user:user";
    
 //    [URLRequest setValue:@"application/json;charset=UTF-8" forHTTPHeaderField: @"Content-Type"];
    
    ASIHTTPRequest *URLRequest = [ASIHTTPRequest requestWithURL:URL];
    [URLRequest setUsername:@"admin"];
    [URLRequest setPassword:@"admin"];
    
    [URLRequest startSynchronous];
    
    NSError *error = [URLRequest error];
    
    if (!error)
    {
        NSDictionary* returnData = [NSJSONSerialization JSONObjectWithData:[URLRequest responseData] options:NSJSONReadingAllowFragments error:nil];
        
        NSArray* activityData = returnData[@"content"];
        
        // Update data list info
        NSNumber* totalPage = returnData[@"totalPages"];
        maxPage = totalPage.longValue;
        
        currentPage = nextPage;
        if (currentPage == maxPage)
            nextPage = maxPage;
        else
            nextPage = currentPage+1;
        
        for (int i = 0; i < activityData.count; i++)
        {
            NSDictionary* temp = activityData[i];
            
            NSDictionary* creator = temp[@"createdBy"];
            NSNumber* creatorId = creator[@"id"];
            NSString* group = temp[@"activityGroup"];
            NSString* type = temp[@"activityType"];
            
            NSString* beginTime = [UserManager filtStr:temp[@"beginTime"] : @""];
            NSString* endTime = [UserManager filtStr:temp[@"endTime"] : @""];
            
            NSString* beginDate = [self stringFromDate:[self dateFromString:beginTime]];
            NSString* endDate = [self stringFromDate:[self dateFromString:endTime]];
            
            NSString* dateData = [beginDate stringByAppendingFormat:@" ~ %@", endDate];
            
            NSDictionary* members = temp[@"users"];
            int memberNum = 0;
            if ([members isKindOfClass:[NSDictionary class]])
            {
                memberNum = members.count;
            }
            
            //NSString* tittle = temp[@"title"];
            NSString* peopleLimit = [UserManager filtStr:temp[@"peopleLimit"] : @"0"];
            NSString* regionLimit = [UserManager filtStr:temp[@"regionLimit"] : @""];
            UIImage* iconImg;
            
            if ([group isEqualToString:@"Association"])
            {
                iconImg = groupIcon;
            }
            else if ([group isEqualToString:@"Company"])
            {
                iconImg = bussinessIcon;
            }
            else if ([group isEqualToString:@"Department"])
            {
                iconImg = collegeIcon;
            }
            else if ([group isEqualToString:@"University"])
            {
                iconImg = schoolIcon;
            }
            else if ([group isEqualToString:@"Private"])
            {
                iconImg = privateIcon;
            }
            
            NSString* imgUrlString = [UserManager filtStr:temp[@"iconUrl"] :@""];
            
            if (imgUrlString.length > 0)
            {
                NSString* tempstr = @"http://e.taoware.com:8080/quickstart/resources";
                //tempstr = [tempstr stringByAppendingFormat:@"/a/%@/", temp[@"id"]];
                tempstr = [tempstr stringByAppendingString:imgUrlString];
                imgUrlString = tempstr;
            }
            NSURL* imgUrl = [NSURL URLWithString:imgUrlString];
            
            NSDictionary* board = temp[@"board"];
            NSNumber* favNum = [NSNumber numberWithInt:0];
            if ([board isKindOfClass:[NSDictionary class]])
            {
                NSNumber* fav = board[@"bookmarkCount"];
                
                if ([fav isKindOfClass:[NSDictionary class]])
                    favNum = fav;
            }
            
            Activity* newAct = [Activity
                                activityOfCategory:@"All"
                                imgUrlStr:imgUrl
                                title:temp[@"title"]
                                date:dateData
                                limit:regionLimit
                                icon:iconImg
                                member:[NSString stringWithFormat:@"%d",memberNum]
                                memberUpper:peopleLimit
                                fav:favNum
                                state:0
                                activitiId:temp[@"id"]
                                creatorId:creatorId
                                ];
            [newAct SetActivityData:temp];
            [activityArray addObject: newAct];
        }
        self.filteredActivityArray = [NSMutableArray arrayWithCapacity:[activityArray count]];
        [activityList reloadData];
    }
    else
    {
        // TODO
    }
}

-(void) refreshTopAds
{
    if (topAds)
        [topAds removeAllObjects];
    else
        topAds = [[NSMutableArray alloc]init];
    
    NSString* URLString = @"http://e.taoware.com:8080/quickstart/api/v1/activity/q?sortType=topOrder";
    
    NSURL *URL = [NSURL URLWithString:URLString];
    ASIHTTPRequest *URLRequest = [ASIHTTPRequest requestWithURL:URL];
    [URLRequest setUsername:@"admin"];
    [URLRequest setPassword:@"admin"];
    
    [URLRequest startSynchronous];
    
    NSError *error = [URLRequest error];
    
    if (!error)
    {
        NSDictionary* returnData = [NSJSONSerialization JSONObjectWithData:[URLRequest responseData] options:NSJSONReadingAllowFragments error:nil];
        
        NSArray* itemArray = returnData[@"content"];
        
        int maxItems = itemArray.count;
        if (maxItems > 8)
            maxItems = 8;
        
        for (int i = 0; i < maxItems; i++)
        {
            NSDictionary* item = itemArray[i];
            NSString* iconStr = [UserManager filtStr:item[@"iconUrl"] :@""];
            
            if (iconStr.length > 0)
            {
                [topAds addObject:item];
            }
        }
        
        topAdItems = [[NSMutableArray alloc]init];
        
        for (IconImageButtonLoader* button in topAdItems)
        {
            [button removeFromSuperview];
        }
        [topAdItems removeAllObjects];
        
        int pages = topAds.count;
        
        for (int i = 0; i < topAds.count; i++)
        {
            IconImageButtonLoader* button = [[IconImageButtonLoader alloc]initWithFrame:CGRectMake(320*i, 0, 320, 128)];
            [button addTarget:self action:@selector(OnScrollItemClick:) forControlEvents:UIControlEventTouchUpInside];
            
            NSDictionary* item = topAds[i];
 
            NSString* iconStr = [UserManager filtStr:item[@"iconUrl"] :@""];
            
            NSString* ext = [iconStr pathExtension];
            NSString* extCut = [iconStr substringToIndex:(iconStr.length - ext.length - 1)];
            //iconStr = [extCut stringByAppendingFormat:@"_large.%@",ext];
                
            iconStr = [extCut stringByAppendingFormat:@"_large.%@",@"jpg"];
            NSString* tempstr = @"http://e.taoware.com:8080/quickstart/resources";
            tempstr = [tempstr stringByAppendingString:iconStr];
                
            NSURL* iconUrl = [NSURL URLWithString:tempstr];
            [button LoadFromUrl:iconUrl :[UserManager DefaultIcon]];
                
            [scrollView addSubview:button];
            [topAdItems addObject:button];
        }
        pageControl.numberOfPages = pages;
        [pageControl setFrame:CGRectMake(-140+pages*6, 100, 320, 30)];
        [pageControl setBounds:CGRectMake(0,0,16*(pages-1)+16,16)];
        [scrollView setContentSize:CGSizeMake(320*pages, 128)];
    }
}

-(IBAction)OnScrollItemClick:(id)sender
{
    NSDictionary* item = topAds[pageControl.currentPage];
    
    ActivityDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailViewController"];
    viewController.navigationItem.title = @"活动详细页面";
    
    [viewController SetData:item];
    [viewController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)showLoadingCircle
{
    CGRect loadingFrame = CGRectMake(0, 128, activityList.frame.size.width, activityList.frame.size.height-128);
    loadingView = [[UIView alloc]initWithFrame:loadingFrame];
    [loadingView setUserInteractionEnabled:YES];
    [loadingView setBackgroundColor:[UIColor whiteColor]];
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [loading setCenter:CGPointMake(160, 140)];
    [loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [loading startAnimating];
    [loadingView addSubview:loading];
    
    UILabel *loadingText = [[UILabel alloc]initWithFrame:CGRectMake(110, 80, 150, 20)];
    loadingText.font = [UIFont fontWithName:defaultBoldFont size:15];
    [loadingText setTextColor:defaultMainColor];
    loadingText.text = @"加载中...请稍后";
    
    [loadingView addSubview:loadingText];
    
    [activityList setUserInteractionEnabled:NO];
    [activityList addSubview:loadingView];
}

-(void)deleteLoadingCircle
{
    [activityList setUserInteractionEnabled:YES];
    [loadingView removeFromSuperview];
}

- (void)viewDidLoad
{
    initUpdate = false;
    
    [super viewDidLoad];

   // [self showLoadingCircle];
    // Do any additional setup after loading the view.

    [self.searchButton addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    // initialize activity list
    
    bussinessIcon = [UIImage imageNamed:@"buisness_icon.png"];
    schoolIcon = [UIImage imageNamed:@"school_icon.png"];
    collegeIcon = [UIImage imageNamed:@"coll_icon.png"];
    groupIcon = [UIImage imageNamed:@"group_icon.png"];
    privateIcon = [UIImage imageNamed:@"private_icon.png"];
    
    
    
    // [self refreshActivityData];
    
    int pagesCount = 0;
    
    self.filteredActivityArray = [NSMutableArray arrayWithCapacity:[activityArray count]];
    [activityList reloadData];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setContentSize:CGSizeMake(320*pagesCount, 380)];
    scrollView.pagingEnabled=YES;
    scrollView.bounces=NO;
    [scrollView setDelegate:self];
    scrollView.showsHorizontalScrollIndicator=NO;
    [scrollView setContentSize:CGSizeMake(320*pagesCount, 128)];
    
    
    //activity scroll view
    /*
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    for(int i=0;i<pagesCount;i++)
    {
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(320*i, 0, 320, 128)];
        [imageview setImage:[UIImage imageNamed:@"11.jpg"]];
        [imageArray addObject:imageview];
        [scrollView addSubview:imageArray[i]];
    }
     */
    
    
    
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(-140+pagesCount*6, 100, 320, 30)];
    pageControl.numberOfPages=pagesCount;
    pageControl.currentPage=0;
    [pageControl setBounds:CGRectMake(0,0,16*(pagesCount-1)+16,16)];
    [pageControl.layer setCornerRadius:8];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.94117647 green:0.42352941 blue:0.11764706 alpha:1];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.activityList addSubview:pageControl];
    
    [UserManager RefreshGroupData];
    [self setTableFooterView:activityList];
}

- (void)setTableFooterView:(UITableView *)tb {
    if (!tb) {
        return;
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [tb setTableFooterView:view];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (initUpdate)
        return;
    initUpdate = true;
    
    [self setupRefresh];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.activityList addHeaderWithTarget:self action:@selector(headerRereshing)];
//#warning 自动刷新(一进入程序就下拉刷新)
    [self.activityList headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.activityList addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.activityList.headerPullToRefreshText = @"下拉刷新";
    self.activityList.headerReleaseToRefreshText = @"释放刷新";
    self.activityList.headerRefreshingText = @"数据刷新中...";
    
    self.activityList.footerPullToRefreshText = @"上拉可以加载更多数据";
    self.activityList.footerReleaseToRefreshText = @"松开马上加载更多数据";
    self.activityList.footerRefreshingText = @"数据加载中...";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    [self showLoadingCircle];
    [self refreshActivityData];
    [self deleteLoadingCircle];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.activityList reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.activityList headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    // 1.添加数据
    [self appendActivityData];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.activityList reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.activityList footerEndRefreshing];
    });
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1{
    CGPoint offset=scrollView1.contentOffset;
    CGRect bounds=scrollView1.frame;
    [self.pageControl setCurrentPage:offset.x/bounds.size.width];
}

- (IBAction)ToCreatePage:(id)sender
{
    if (![UserManager IsInitSuccess])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户未登录" message:@"登陆后才能执行该操作。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    if (![UserManager IsUserAuthen])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户未认证" message:@"只有认证用户才能创建活动。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    CreateActivityTableViewController *createActivityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateActivityTableViewController"];
    [createActivityVC SetActivity:self];
    [self.navigationController pushViewController:createActivityVC animated:YES];
}

- (IBAction)pageTurn:(UIPageControl *)sender {
    CGSize viewsize=self.scrollView.frame.size;
    CGRect rect=CGRectMake(sender.currentPage*viewsize.width, 0, viewsize.width, viewsize.height);
    [self.scrollView scrollRectToVisible:rect animated:YES];
    
}

- (void) CreateActivityDone
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建活动成功" message:@"在-我的活动-中可以编辑活动详细信息" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
    
    [self refreshActivityData];
}


#pragma mark - Table view data source

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ActivityTableCell";
    ActivityViewCell *cell = [activityList dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ( cell == nil )
    {
        cell = [[ActivityViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Activity *activity = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        activity = [self.filteredActivityArray objectAtIndex:indexPath.row];
    }
    else
    {
        activity = [self.activityArray objectAtIndex:indexPath.row];
    }
    
    
    
    [cell SetActivity:activity];
   
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredActivityArray count];
    }
    else
    {
        return [activityArray count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ActivityDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailViewController"];
    viewController.navigationItem.title = @"活动详细页面";
    
    Activity *activity = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        activity = [self.filteredActivityArray objectAtIndex:indexPath.row];
    }
    else
    {
        activity = [self.activityArray objectAtIndex:indexPath.row];
    }
    viewController.activity = activity;
    [viewController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController.tabBar setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar setBarTintColor:defaultMainColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.activityList reloadData];
    [self.activityList headerEndRefreshing];
}

-(void)popover:(id)sender
{
    //the controller we want to present as a popover
    SelectTableViewController *controller = [[SelectTableViewController alloc] initWithStyle:UITableViewStylePlain];
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller];

    controller.title = @"请选择您需要筛选的关键字";
    [controller SetAsActivity:self :popover];
    
    
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

-(IBAction)searchClick:(id)sender
{
    SearchTableViewController *searchView = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchTableViewController"];
    //searchView.modalPresentationStyle = UIModalPresentationPageSheet;
    //searchView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [searchView setTitle:@"找活动"];
    [searchView SetSearchActivity];
    [self.navigationController pushViewController:searchView animated:YES];
}

- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

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
