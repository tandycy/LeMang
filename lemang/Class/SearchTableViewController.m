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

@interface SearchTableViewController ()
{
    NSMutableArray *historyArray;
    NSMutableArray *resultArray;
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
    [UserManager RefreshTagData];
    [self initView];
    [self initSearchResult];
    // Uncomment the following lineto preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.

    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

-(void)SetSearchActivity
{
    searchType = Result_Activity;
}

-(void)SetSearchOrganization
{
    searchType = Result_Organization;
}

-(void)SetSearchActivityTag:(NSString *)tagstr
{
    searchType = Result_Activity;
}

-(void)SetSearchOrganizationTag:(NSString *)tagstr
{
    searchType = Result_Organization;
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
            rows = [resultArray count];
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
        
        SearchResultItem *item = nil;
        item = [resultArray objectAtIndex:indexPath.row];
        
        UILabel* title = [cell viewWithTag:8088];
        title.text = item.title;
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
    [self DoSearch];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isShowResult)
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
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
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
    bool isExist = false;
    for(NSString* item in historyArray)
    {
        if ([item isEqualToString:_searchBar.text])
        {
            isExist = true;
            break;
        }
    }
    if (!isExist)
        [self AddHistoryData:_searchBar.text];
    NSLog(@"%@", _searchBar.text);
    
    [self searchKeyWord:_searchBar.text];
}

-(void)searchKeyWord:(NSString*)keyword
{
    enum SORT_TYPE_ENUM sortType = SORT_AUTO;
    
    if(self.searchBar.selectedScopeButtonIndex == 0)
        sortType = SORT_DATE;
    else if(self.searchBar.selectedScopeButtonIndex == 1)
        sortType = SORT_JOINCOUNT;
    
    [self searchKeyWord:keyword :sortType];
}

-(void)searchKeyWord:(NSString*)keyword :(enum SORT_TYPE_ENUM)sortType
{
    NSString* urlString = @"http://e.taoware.com:8080/quickstart/api/v1/";
    
    if (searchType == Result_Organization)
    {
        urlString = [urlString stringByAppendingString:@"association/"];
        urlString = [urlString stringByAppendingFormat:@"q?search_LIKE_name="];
    }
    else if (searchType == Result_Activity)
    {
        urlString = [urlString stringByAppendingString:@"activity/"];
        urlString = [urlString stringByAppendingFormat:@"q?search_LIKE_title="];
    }
    
    urlString = [urlString stringByAppendingFormat:@"%@&search_LIKE_description=%@&search_LIKE_university.name=%@",keyword,keyword,keyword];
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
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL* URL = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setUsername:@"user"];
    [request setPassword:@"user"];
    [request startSynchronous];
    
    NSError *error = [request error];
    int returnCode = [request responseStatusCode];
    if (!error) {
        NSArray* resultData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil][@"content"];
        
        [resultArray removeAllObjects];
        
        for (int i = 0; i < resultData.count; i++)
        {
            NSDictionary* item = resultData[i];
            SearchResultItem* resultItem = [[SearchResultItem alloc]init];
            
            resultItem.itemType = searchType;
            resultItem.itemId = item[@"id"];
            resultItem.localData = item;
            
            if (searchType == Result_Activity)
                resultItem.title = item[@"title"];
            else if (searchType == Result_Organization)
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
