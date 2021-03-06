//
//  SearchTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-28.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "SearchTableViewController.h"
#import "ActivityViewCell.h"
#import "ActivityDetailViewController.h"
#import "OrganizationDetailTableViewController.h"
#import "Constants.h"
#import "MJRefresh.h"

@interface SearchTableViewController ()
{
    NSMutableArray *historyArray;
    NSMutableArray *resultArray;
    
    NSString* searchStr;
    int currentPage;
    int nextPage;
    int pageSize;
}

@end

@implementation SearchTableViewController
@synthesize searchDisplayController;
@synthesize searchBar;

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
    [UserManager RefreshTagData];
    [self initView];
    [self initSearchResult];
    // Uncomment the following lineto preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller

    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    currentPage = nextPage = 0;
    
    if (keyword != Nil && keyword.length > 0)
    {
        searchBar.text = keyword;
        [self searchKeyWord:keyword];
    }
    [self setTableFooterView:self.tableView];
}

- (void)setTableFooterView:(UITableView *)tb {
    if (!tb) {
        return;
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [tb setTableFooterView:view];
}

-(void)SetSearchActivity
{
    searchType = Result_Activity;
    keyword = @"";
}

-(void)SetSearchOrganization
{
    searchType = Result_Organization;
    keyword = @"";
}

-(void)SetSearchActivityTag:(NSString *)tagstr
{
    searchType = Result_Activity_Tag;
    keyword = tagstr;
}

-(void)SetSearchOrganizationTag:(NSString *)tagstr
{
    searchType = Result_Organization_Tag;
    keyword = tagstr;
}

-(void)initView
{
    self.searchDisplayController.searchBar.placeholder = @"输入您需要搜索的关键字";
    self.tableView.scrollEnabled = YES;
    
    [self initHistory];
    [self initScope];

}

- (void) initScope
{
    [self.searchDisplayController.searchBar setShowsScopeBar:YES];// 是否显示分栏条
    
    NSMutableArray* scopeArray = [NSMutableArray arrayWithObjects:@"全部", nil];
    NSArray* tagArray = [UserManager GetTags];
    
    int maxNum = 5;
    if (tagArray.count < maxNum)
        maxNum = tagArray.count;
    for (int i = 0; i < maxNum; i++)
    {
        TagItem* item = tagArray[i];
        [scopeArray addObject:item.name];
    }
    
    [self.searchDisplayController.searchBar setScopeButtonTitles:scopeArray];

}

- (void) initHistory
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"profile" ofType:@"plist"];
    NSMutableDictionary* dict =  [ [ NSMutableDictionary alloc ] initWithContentsOfFile:plistPath];
    
    NSArray* history = dict[@"history"];
    historyArray = [NSMutableArray arrayWithArray:history];
    
    [self DoRefreshDisplay:false];
}

- (void) AddHistoryData:(NSString*)key
{
    [historyArray addObject:key];
    //[self DoRefreshDisplay:false];
    
    [self saveHistory];
}

- (void) saveHistory
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"profile" ofType:@"plist"];
    
    NSMutableDictionary* dict = [ [ NSMutableDictionary alloc ] initWithContentsOfFile:plistPath ];
    
    [dict setObject:historyArray forKey:@"history"];
    
    [dict writeToFile:plistPath atomically:YES];
}


-(void)initSearchResult
{
    if (!resultArray)
    {
        resultArray = [[NSMutableArray alloc]init];
    }
    
    if (!historyArray)
    {
        historyArray = [[NSMutableArray alloc]init];
    }

}

- (void)setupRefresh
{
    // 上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据";
    self.tableView.footerRefreshingText = @"数据加载中...";
}

- (void)footerRereshing
{
    if (currentPage >= nextPage)
    {
        [self.tableView footerEndRefreshing];
        return;
    }
    
    // 1.添加数据
    [self AppendResultData];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
        return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = 0;
    if (isShowResult){
        if (section == 0)
        {
            rows = [resultArray count];
            
            if (rows == 0)
                rows = 1;
        }
    }
    else
    {
        if (section==0)
        {
            // tag sector
            int tagcount = [UserManager GetTags].count;
            
            if (tagcount == 0)
                return 0;
            
            if (tagcount > 4)
                return 2;
            
            return 1;
        }
        else if(section==2)
        {
            // clear history
            return 1;
        }
        else
            rows = [historyArray count];
    }
    return rows;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isShowResult)
    {
        NSString *CellIdentifier = @"SearchItemCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        UILabel* title = [cell viewWithTag:8088];
        
        if (resultArray.count > 0)
        {
            SearchResultItem *item = nil;
            item = [resultArray objectAtIndex:indexPath.row];
        
            title.text = item.title;
        }
        else
        {
            title.text = @"无搜索结果";
        }
        
        return cell;
    }
    else
    {
        NSString *CellIdentifier;
        UITableViewCell *cell = nil;
        
        if (indexPath.section == 0)
        {
            // tag sector
            CellIdentifier = @"SearchTagCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            NSMutableArray* tagButtons = [[NSMutableArray alloc]init];
            // specified component tag here
            for (int i = 8091; i < 8095; i++)
            {
                UIView* item = [cell viewWithTag:i];
                if ([item isKindOfClass:[UIButton class]])
                {
                    UIButton* button = (UIButton*)item;
                    [tagButtons addObject:button];
                }
            }
            
            NSArray* tagArray = [UserManager GetTags];
            int tagIndex = indexPath.row * 4;
            for (int i = 0; i < tagButtons.count; i++)
            {
                UIButton* button = tagButtons[i];
                
                if (tagIndex >= tagArray.count)
                {
                    [button setEnabled:false];
                }
                else
                {
                    TagItem* tagItem = tagArray[tagIndex];
                    [button setEnabled:true];
                    [button setTitle:tagItem.name forState:UIControlStateNormal];
                    //button.titleLabel.text = tagItem.name;
                    tagIndex++;
                    
                    [button addTarget:self action:@selector(tagItemClick:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
        else if (indexPath.section == 2)
        {
            // clear sector
            CellIdentifier = @"SearchHistoryCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            UILabel* title = [cell viewWithTag:8088];
            if (historyArray.count == 0)
                title.text = @"无搜索历史";
            else
                title.text = @"清除搜索历史";
            return cell;
        }
        else if (indexPath.section == 1)
        {
            // item sector
            CellIdentifier = @"SearchItemCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            UILabel* title = [cell viewWithTag:8088];
            title.text = historyArray[indexPath.row];
            return cell;
        }
        
        return cell;
    }
}

-(IBAction)tagItemClick:(id)sender
{
    if (![sender isKindOfClass:[UIButton class]])
        return;
    
    UIButton* button = (UIButton*)sender;
    
    NSString* tagStr = button.titleLabel.text;
    
    if (tagStr.length == 0)
        return;
    
    self.searchBar.text = tagStr;
    
    [self SetTypeTag];
    
    [self DoSearch];
}

- (void) SetTypeNromal
{
    if (searchType == Result_Organization_Tag)
        searchType = Result_Organization;
    else if (searchType == Result_Activity_Tag)
        searchType = Result_Activity;
}

- (void) SetTypeTag
{
    if (searchType == Result_Organization)
        searchType = Result_Organization_Tag;
    else if (searchType == Result_Activity)
        searchType = Result_Activity_Tag;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isShowResult && resultArray.count > 0)
    {
        SearchResultItem* item = [resultArray objectAtIndex:indexPath.row];
        
        if (item.itemType == Result_Activity)
        {
            ActivityDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailViewController"];
            viewController.navigationItem.title = @"活动详细页面";
            
            [viewController SetData:item.localData];
            [viewController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if (item.itemType == Result_Organization)
        {
            OrganizationDetailTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrganizationDetailView"];
            viewController.navigationItem.title = @"组织详细页面";
            
            [viewController SetOrgnizationData:item.localData];
            [viewController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
            
            [self.navigationController pushViewController:viewController animated:YES];
        }      
        
    }
    else
    {
        if (indexPath.section == 0)
        {
            // tags, no opeartion here
            return;
        }
        else if(indexPath.section == 2)
        {
            // clear history
            [historyArray removeAllObjects];
            [self DoRefreshDisplay:false];
            return;
        }
        else
        {
            // TODO
            //[self.searchDisplayController.searchBar becomeFirstResponder];
            //searchDisplayController.searchBar.text = historyArray[indexPath.row];
            //[self.searchBar setSearchResultsButtonSelected:NO];
            
            self.searchBar.text = historyArray[indexPath.row];
            [self DoSearch];
        }
    }
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        [view setBackgroundColor:[UIColor colorWithRed:0.95294117647059 green:0.95294117647059 blue:0.95294117647059 alpha:1]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
        label.textColor = [UIColor colorWithRed:0.94117647 green:0.42352941 blue:0.11764706 alpha:1];
        label.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:13];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"常用搜索";
        [view addSubview:label];
        return view;
    }
    else
    {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        return 30;
    }
    else return 0;
}
*/
-(void)initNavBar
{
    [self setBackButton];
    [self changeToWhite];
}

-(void)setBackButton
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_back"] style:UIBarButtonItemStylePlain target:self action:@selector(navBackClick:)];
    [backButton setTintColor:defaultMainColor];
    self.navigationItem.leftBarButtonItem = backButton;
}

-(IBAction)navBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)changeToWhite
{
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     defaultMainColor, UITextAttributeTextColor,
                                                                     [UIFont fontWithName:defaultBoldFont size:20.0], UITextAttributeFont,
                                                                     nil]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initNavBar];
    [self.tabBarController.tabBar setHidden:YES];
    
}


-(void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    NSLog(@"load results");
}

- (void)DoRefreshDisplay:(bool)showResult
{
    isShowResult = showResult;
    //[self.searchBar setShowsScopeBar:isShowResult];
    
    [self.tableView reloadData];
}

- (void)DoSearch
{
    [self searchBarSearchButtonClicked:self.searchBar];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    [self searchKeyWord:_searchBar.text];
    [_searchBar resignFirstResponder];
}

-(void)searchKeyWord:(NSString*)key
{
    bool isExist = false;
    for(NSString* item in historyArray)
    {
        if ([item isEqualToString:key])
        {
            isExist = true;
            break;
        }
    }
    if (!isExist)
        [self AddHistoryData:key];
    
    enum SORT_TYPE_ENUM sortType = SORT_AUTO;
    
    if(self.searchBar.selectedScopeButtonIndex == 0)
        sortType = SORT_DATE;
    else if(self.searchBar.selectedScopeButtonIndex == 1)
        sortType = SORT_JOINCOUNT;
    
    [self searchKeyWord:key :sortType];
}

-(void)searchKeyWord:(NSString*)key :(enum SORT_TYPE_ENUM)sortType
{
    keyword = key;
    
    NSString* urlString = @"http://e.taoware.com:8080/quickstart/api/v1/";
    
    if (searchType == Result_Organization || searchType == Result_Organization_Tag)
    {
        urlString = [urlString stringByAppendingString:@"association/"];
        
        if (searchType == Result_Organization)
            urlString = [urlString stringByAppendingFormat:@"q?search_LIKE_name="];
    }
    else if (searchType == Result_Activity || searchType == Result_Activity_Tag)
    {
        urlString = [urlString stringByAppendingString:@"activity/"];
        
        if (searchType == Result_Activity)
            urlString = [urlString stringByAppendingFormat:@"q?search_LIKE_title="];
    }
    
    if (searchType == Result_Activity_Tag || searchType == Result_Organization_Tag)
    {
        urlString = [urlString stringByAppendingFormat:@"q?search_LIKE_tags=%@",key];
    }
    else
    {
        urlString = [urlString stringByAppendingFormat:@"%@&search_LIKE_tags=%@",key,key];
        urlString = [urlString stringByAppendingFormat:@"&search_LIKE_description=%@&search_LIKE_university.name=%@",key,key];
        urlString = [urlString stringByAppendingFormat:@"&search_LIKE_area.name=%@&search_LIKE_department.name=%@",key,key];
    }
    
    if (sortType == SORT_AUTO)
    {
        urlString = [urlString stringByAppendingString:@"&sortType=auto"];
    }
    else if (sortType == SORT_DATE)
    {
        urlString = [urlString stringByAppendingString:@"&sortType=createdDate"];
    }
    else if (sortType == SORT_JOINCOUNT)
    {
        urlString = [urlString stringByAppendingString:@"&sortType=joinCount"];
    }
    
    searchStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    currentPage = 0;
    nextPage = 1;
    pageSize = 10;
    
    [resultArray removeAllObjects];
    
    [self AppendResultData];
}

- (void) AppendResultData
{
    if (currentPage >= nextPage)
    {
        NSLog(@"activity at final page: %d, refresh cancel", currentPage);
        return;
    }
    NSLog(@"append activity data for page: %d", nextPage);
    
    NSString* urlString = searchStr;
    
    urlString = [urlString stringByAppendingFormat:@"?page=%d&page.size=%d",currentPage, pageSize];
    
    NSURL* URL = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setUsername:@"user"];
    [request setPassword:@"user"];
    [request startSynchronous];
    
    NSError *error = [request error];
    int returnCode = [request responseStatusCode];
    NSLog(@"%d",returnCode);
    
    if (!error) {
        NSDictionary* returnData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil];
        NSArray* resultData = returnData[@"content"];
        
        NSNumber* totalPage = returnData[@"totalPages"];
        long maxPage = totalPage.longValue;
        
        currentPage = nextPage;
        if (currentPage >= maxPage)
            nextPage = maxPage;
        else
            nextPage = currentPage+1;
        
        for (int i = 0; i < resultData.count; i++)
        {
            NSDictionary* item = resultData[i];
            SearchResultItem* resultItem = [[SearchResultItem alloc]init];
            
            resultItem.itemType = searchType;
            
            if (resultItem.itemType == Result_Activity_Tag)
                resultItem.itemType = Result_Activity;
            else if (resultItem.itemType == Result_Organization_Tag)
                resultItem.itemType = Result_Organization;
            
            resultItem.itemId = item[@"id"];
            resultItem.localData = item;
            
            if (resultItem.itemType == Result_Activity)
                resultItem.title = item[@"title"];
            else if (resultItem.itemType == Result_Organization)
                resultItem.title = item[@"name"];
            
            [resultArray addObject:resultItem];
        }
        [self DoRefreshDisplay:true];
        //[self.searchBar resignFirstResponder];
    }

}
/*
-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{

}
 */

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [self DoRefreshDisplay:false];
}

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    if (!isShowResult)
        return;
    
    if (self.searchBar.text.length == 0)
        return;
    
    [self DoSearch];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText isEqual:@""])
    {
        [self DoRefreshDisplay:false];
    }
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
