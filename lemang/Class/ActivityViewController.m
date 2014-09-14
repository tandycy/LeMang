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
        maxPage = totalPage.integerValue;
        
        currentPage = nextPage;
        if (currentPage == maxPage)
            nextPage = maxPage;
        else
            nextPage = currentPage+1;
        
        for (int i = 0; i < activityData.count; i++)
        {
            NSDictionary* temp = activityData[i];
            
            NSDictionary* creator = temp[@"createdBy"];
            NSString* group = temp[@"activityGroup"];
            NSString* type = temp[@"activityType"];
            
            NSString* createDate = temp[@"createdDate"];
            NSArray* members = temp[@"activityMember"];
            
            int memberNum = 0;
            if (members != Nil) {
                memberNum = members.count;
            }
            
            //NSString* tittle = temp[@"title"];
            NSString* peopleLimit = temp[@"peopleLimit"];
            NSString* regionLimit = temp[@"regionLimit"];
            UIImage* iconImg;
            
            if ([group isEqualToString:@"Association"])
            {
                iconImg = groupIcon;
            }
            else if ([group isEqualToString:@"Company"])
            {
                iconImg = bussinessIcon;
            }
            else if ([group isEqualToString:@"University"])
            {
                iconImg = schoolIcon;
            }
            else if ([group isEqualToString:@"Department"])
            {
                iconImg = privateIcon;
            }
            
            NSString* imgUrlString = temp[@"iconUrl"];
            imgUrlString = @"http://pic13.nipic.com/20110405/4572067_232048222000_2.jpg"; // TSET URL HERE
            
            NSURL* imgUrl = [NSURL URLWithString:imgUrlString];
            
            [activityArray addObject:[Activity
                                         activityOfCategory:@"All"
                                         img:imgUrl
                                         title:temp[@"title"]
                                         date:createDate
                                         limit:regionLimit
                                         icon:schoolIcon
                                         member:[NSString stringWithFormat:@"%d",memberNum]
                                         memberUpper:peopleLimit
                                         fav:@"325"
                                         state:0
                                         activitiId:temp[@"id"]]];
        }
        self.filteredActivityArray = [NSMutableArray arrayWithCapacity:[activityArray count]];
        [activityList reloadData];
    }
}


- (void)viewDidLoad
{
    NSLog(@"load");
    [super viewDidLoad];
    
    [self setupRefresh];
    // Do any additional setup after loading the view.
    //self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    //activitySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(50.0f,0.0f,200.0f,44.0f)];
    //[activitySearchBar setPlaceholder:@"search"];
    // [activitySearchBar setShowsCancelButton:YES];
    // activitySearchBar.delegate = self;
    // [self.navigationController.navigationBar addSubview:activitySearchBar];
    
   
    // initialize activity list
    
    bussinessIcon = [UIImage imageNamed:@"buisness_icon.png"];
    schoolIcon = [UIImage imageNamed:@"school_icon.png"];
    groupIcon = [UIImage imageNamed:@"group_icon.png"];
    privateIcon = [UIImage imageNamed:@"private_icon.png"];
    
    
   // [self refreshActivityData];
    
    self.filteredActivityArray = [NSMutableArray arrayWithCapacity:[activityArray count]];
    [activityList reloadData];
    NSLog(@"load3");
    [scrollView setContentSize:CGSizeMake(960, 380)];
    scrollView.pagingEnabled=YES;
    scrollView.bounces=NO;
    [scrollView setDelegate:self];
    scrollView.showsHorizontalScrollIndicator=NO;
    [scrollView setContentSize:CGSizeMake(960, 128)];
    
    //activity scroll view
    UIImageView *imageview1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 128)];
    [imageview1 setImage:[UIImage imageNamed:@"11.jpg"]];
    UIImageView *imageview2=[[UIImageView alloc]initWithFrame:CGRectMake(320, 0, 320, 128)];
    [imageview2 setImage:[UIImage imageNamed:@"11.jpg"]];
    UIImageView *imageview3=[[UIImageView alloc]initWithFrame:CGRectMake(640, 0, 320, 128)];
    [imageview3 setImage:[UIImage imageNamed:@"11.jpg"]];
    [scrollView addSubview:imageview1];
    [scrollView addSubview:imageview2];
    [scrollView addSubview:imageview3];
    
    
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(-130, 100, 320, 30)];
    pageControl.numberOfPages=3;
    pageControl.currentPage=0;
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.94117647 green:0.42352941 blue:0.11764706 alpha:1];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.activityList addSubview:pageControl];
    
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.activityList addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
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
    [self refreshActivityData];
    
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

- (IBAction)pageTurn:(UIPageControl *)sender {
    CGSize viewsize=self.scrollView.frame.size;
    CGRect rect=CGRectMake(sender.currentPage*viewsize.width, 0, viewsize.width, viewsize.height);
    [self.scrollView scrollRectToVisible:rect animated:YES];
    
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
    
    // UIImageView *cellBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_list_back.png"]];
    // [cell setBackgroundView:cellBG];
    
    
    Activity *activity = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        activity = [self.filteredActivityArray objectAtIndex:indexPath.row];
    }
    else
    {
        activity = [self.activityArray objectAtIndex:indexPath.row];
    }
    
    cell.linkedActivity = activity;
    
    UIImageView *activityImg = (UIImageView *)[cell viewWithTag:ActivityImg];
    if (activity.img == nil)
    {
        activityImg.image = [UIImage imageNamed:@"group1.png"];
        activity.cachedImg = [UIImage imageNamed:@"group1.png"];
    }
    else
        [cell SetIconImgUrl:activity.img];
    
    UILabel *titleLable = (UILabel *)[cell viewWithTag:ActivityTitle];
    titleLable.text = activity.title;
    
    UILabel *dateLable = (UILabel *)[cell viewWithTag:ActivityDate];
    dateLable.text = activity.date;
    
    UILabel *limitLable = (UILabel *)[cell viewWithTag:ActivityLimit];
    limitLable.text = @"";
    limitLable.text = [limitLable.text stringByAppendingFormat:@"%@",activity.limit];
    
    UIImageView *typeIcon = (UIImageView *)[cell viewWithTag:ActivityTypeIcon];
    typeIcon.image = activity.icon;
    
    UILabel *memberLable = (UILabel *)[cell viewWithTag:ActivityMember];
    memberLable.text = [NSString stringWithFormat:@"%@/%@",activity.member, activity.memberUpper];
   // memberLable.text = [memberLable.text stringByAppendingFormat:@"%@/%@",activity.member, activity.memberUpper];
    
    UILabel *favLable = (UILabel *)[cell viewWithTag:ActivityFav];
    favLable.text = activity.fav;
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.filteredActivityArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",searchText];
    filteredActivityArray = [NSMutableArray arrayWithArray:[activityArray filteredArrayUsingPredicate:predicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.searchDisplayController.searchResultsTableView setRowHeight:95]; //set searchResultTable Row Height
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self.searchDisplayController.searchResultsTableView setRowHeight:95]; //set searchResultTable Row Height
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchDisplayController setActive:YES];
    activitySearchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    activitySearchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchDisplayController setActive:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController.tabBar setUserInteractionEnabled:YES];
    //[self.activityList headerEndRefreshing];
    //[self refreshActivityData];
    //[activitySearchBar setHidden:NO];
   // [self refreshActivityData];
}

- (void) viewWillDisappear:(BOOL)animated
{
    //  [activitySearchBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    
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
