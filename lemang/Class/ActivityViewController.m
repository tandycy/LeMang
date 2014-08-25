//
//  ActivityViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-7-29.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityDetailViewController.h"

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
    NSString* URLString = @"http://e.taoware.com:8080/quickstart/api/v1/activity";
    NSURL *URL = [NSURL URLWithString:URLString];
    
    // NSString *authInfo = @"Basic user:user";
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
    
    [URLRequest setHTTPMethod:@"GET"];
    [URLRequest setValue:@"application/json;charset=UTF-8" forHTTPHeaderField: @"Content-Type"];
    // [URLRequest setValue:authInfo forHTTPHeaderField:@"Authorization"];
    
    
    NSURLResponse * response;
    NSError * error;
    
    if (error) {
        NSLog(@"a connection could not be created or request fails.");
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    //[req addValue:0 forHTTPHeaderField:@"Content-Length"];
    
    NSURLResponse * response;
    NSError * error;
    
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
    activityData = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingAllowFragments error:nil][@"content"];
    
    
    UIImage* businessIcon = [UIImage imageNamed:@"buisness_icon.png"];
    UIImage* schoolIcon = [UIImage imageNamed:@"school_icon.png"];
    UIImage* groupIcon = [UIImage imageNamed:@"group_icon.png"];
    UIImage* privateIcon = [UIImage imageNamed:@"private_icon.png"];
    
    //NSDictionary* dicContent = activityData[@"content"];
    NSMutableArray* newActivityArray = [NSMutableArray arrayWithCapacity:50];
    

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
        
        NSString* tittle = temp[@"title"];
        NSData* peopleLimit = temp[@"peopleLimit"];
        long tempId = temp[@"id"];
        
        UIImage* iconImg;
        
        if ([group isEqualToString:@"Association"])
            iconImg = groupIcon;
        
        [newActivityArray addObject:[Activity
                  activityOfCategory:@"All"
                                 img:[UIImage imageNamed:@"group1.png"]
                               title:temp[@"title"]
                                date:createDate
                               limit:@"限上海大学学生"
                                icon:schoolIcon
                              member:[NSString stringWithFormat:@"%d",memberNum]
                         memberUpper:@"50"
                                 fav:@"325"
                               state:0
                           activitiId:tempId]];
    }
    activityArray = newActivityArray;
    self.filteredActivityArray = [NSMutableArray arrayWithCapacity:[activityArray count]];
    [activityList reloadData];
    /*
    NSString *results = [[NSString alloc]
                         initWithBytes:[receivedData bytes]
                         length:[receivedData length]
                         encoding:NSUTF8StringEncoding];
    NSLog(@"results=%@",results);
     */
}

- (void)viewDidLoad
{
    NSLog(@"load");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    //activitySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(50.0f,0.0f,200.0f,44.0f)];
    //[activitySearchBar setPlaceholder:@"search"];
    // [activitySearchBar setShowsCancelButton:YES];
    // activitySearchBar.delegate = self;
    // [self.navigationController.navigationBar addSubview:activitySearchBar];
    
    
    /*
    UIImage* businessIcon = [UIImage imageNamed:@"buisness_icon.png"];
    UIImage* schoolIcon = [UIImage imageNamed:@"school_icon.png"];
    UIImage* groupIcon = [UIImage imageNamed:@"group_icon.png"];
    UIImage* privateIcon = [UIImage imageNamed:@"private_icon.png"];
    
    
    
    // initialize activity list
    
    
    activityArray = [NSArray arrayWithObjects:
                     [Activity activityOfCategory:@"All" img:[UIImage imageNamed:@"group1.png"]
                                            title:@"上大一日游"
                                             date:@"7月25日 周五 10:00--8月10日 周日 18:00"
                                            limit:@"限上海大学学生"
                                             icon:schoolIcon
                                           member:@"47"
                                      memberUpper:@"50"
                                              fav:@"325"
                                            state:0],
                     [Activity activityOfCategory:@"All" img:[UIImage imageNamed:@"group1.png"]
                                            title:@"南翔垂钓活动"
                                             date:@"7月25日 周五 10:00--8月10日 周日 18:00"
                                            limit:@"限上海交大垂钓社"
                                             icon:groupIcon
                                           member:@"40"
                                      memberUpper:@"120"
                                              fav:@"500"
                                            state:1],
                     [Activity activityOfCategory:@"All" img:[UIImage imageNamed:@"group1.png"]
                                            title:@"南京骑行三日游"
                                             date:@"7月25日 周五 10:00--8月10日 周日 18:00"
                                            limit:@"不限人员"
                                             icon:privateIcon
                                           member:@"77"
                                      memberUpper:@"250"
                                              fav:@"1000"
                                            state:0],
                     [Activity activityOfCategory:@"All" img:[UIImage imageNamed:@"group1.png"]
                                            title:@"上海电信充值100送100"
                                             date:@"7月25日 周五 10:00--8月10日 周日 18:00"
                                            limit:@"所有在校大一新生"
                                             icon:businessIcon
                                           member:@"100"
                                      memberUpper:@"100"
                                              fav:@"100"
                                            state:1],
                     [Activity activityOfCategory:@"All" img:[UIImage imageNamed:@"group1.png"]
                                            title:@"同济十大歌手预选赛"
                                             date:@"7月25日 周五 10:00--8月10日 周日 18:00"
                                            limit:@"限上海同济大学学生"
                                             icon:schoolIcon
                                           member:@"77"
                                      memberUpper:@"250"
                                              fav:@"1000"
                                            state:0],
                     [Activity activityOfCategory:@"All" img:[UIImage imageNamed:@"group1.png"]
                                            title:@"上海大学活动1"
                                             date:@"7月25日 周五 10:00--8月10日 周日 18:00"
                                            limit:@"限上海交大垂钓社"
                                             icon:businessIcon
                                           member:@"47"
                                      memberUpper:@"100"
                                              fav:@"20"
                                            state:1],
                     nil];
     */
    
    [self refreshActivityData];
    
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
    UITableViewCell *cell = [activityList dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    
    UIImageView *activityImg = (UIImageView *)[cell viewWithTag:ActivityImg];
    activityImg.image = activity.img;
    
    UILabel *titleLable = (UILabel *)[cell viewWithTag:ActivityTitle];
    titleLable.text = activity.title;
    
    UILabel *dateLable = (UILabel *)[cell viewWithTag:ActivityDate];
    dateLable.text = activity.date;
    
    UILabel *limitLable = (UILabel *)[cell viewWithTag:ActivityLimit];
    limitLable.text = activity.limit;
    
    UIImageView *typeIcon = (UIImageView *)[cell viewWithTag:ActivityTypeIcon];
    typeIcon.image = activity.icon;
    
    UILabel *memberLable = (UILabel *)[cell viewWithTag:ActivityMember];
    memberLable.text = [memberLable.text stringByAppendingFormat:@"%@/%@",activity.member, activity.memberUpper];
    
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
    //[self refreshActivityData];
    //[activitySearchBar setHidden:NO];
}

- (void) viewWillDisappear:(BOOL)animated
{
    //  [activitySearchBar setHidden:YES];
    
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
