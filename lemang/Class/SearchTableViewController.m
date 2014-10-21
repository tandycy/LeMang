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
@synthesize historyItems;
@synthesize searchResults;

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
    
    self.historyItems = historyArray;
    [self.tableView reloadData];
}

- (void) AddHistoryData:(NSString*)key
{
    [historyArray addObject:key];
    self.historyItems = historyArray;
    [self.tableView reloadData];
    
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
        rows = [self.searchResults count];
    }
    else
    {
        if (section==0) {
            return 1;
        }
        else if(section==2)
        {
            return 1;
        }
        else rows = [historyItems count];
    }
    return rows;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isShowResult)
    {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        SearchResultItem *item = nil;
        item = [resultArray objectAtIndex:indexPath.row];
        cell.textLabel.text = item.title;
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSLog(@"%ld",(long)indexPath.section);
        
        UILabel *clear = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 320, 30)];
        clear.textAlignment = UITextAlignmentCenter;
        clear.text = @"清除所有历史记录";
        
        if (indexPath.section==0) {
            UIButton *hotButton1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 6, 80, 30)];
            UIButton *hotButton2 = [[UIButton alloc]initWithFrame:CGRectMake(120, 6, 80, 30)];
            UIButton *hotButton3 = [[UIButton alloc]initWithFrame:CGRectMake(220, 6, 80, 30)];
            [hotButton1 setTitle:@"hot" forState:UIControlStateNormal];
            [hotButton2 setTitle:@"hot" forState:UIControlStateNormal];
            [hotButton3 setTitle:@"hot" forState:UIControlStateNormal];
            
            [hotButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [hotButton1 setBackgroundColor:defaultLightGray243];
            [hotButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [hotButton2 setBackgroundColor:defaultLightGray243];
            [hotButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [hotButton3 setBackgroundColor:defaultLightGray243];
            
            [cell addSubview:hotButton1];
            [cell addSubview:hotButton2];
            [cell addSubview:hotButton3];
        }
        else if(indexPath.section == 1)
        {
            /* Configure the cell. */
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [self.historyItems objectAtIndex:indexPath.row];
        }
        
        else if(indexPath.section == 2)
        {
            [cell addSubview:clear];
        }
        
        return cell;
    }
}


#pragma mark - UISearchDisplayController delegate methods


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
        if (indexPath.section==0) {
            return;
        }
        else if(indexPath.section==2)
        {
            //to do clear history
            return;
        }
        else
        {
            [self.searchDisplayController.searchBar becomeFirstResponder];
            searchDisplayController.searchBar.text = historyItems[indexPath.row];
            [self.searchBar setSearchResultsButtonSelected:NO];
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
    
    NSString* urlString = @"http://e.taoware.com:8080/quickstart/api/v1/";//q?search_LIKE_loginName=";
    
    if (searchType == Result_Organization)
    {
        urlString = [urlString stringByAppendingString:@"group/"];
        urlString = [urlString stringByAppendingFormat:@"q?search_LIKE_name="];
    }
    else if (searchType == Result_Activity)
    {
        urlString = [urlString stringByAppendingString:@"activity/"];
        urlString = [urlString stringByAppendingFormat:@"q?search_LIKE_title="];
    }
    
    urlString = [urlString stringByAppendingFormat:@"%@&search_LIKE_description=%@&search_LIKE_university.name=%@",_searchBar.text,_searchBar.text,_searchBar.text];
    //urlString = [urlString stringByAppendingFormat:@"%@",_searchBar.text];
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
        isShowResult = true;
        [self.tableView reloadData];
        [self.searchBar resignFirstResponder];
    }
}

/*
-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{

}
 */

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isShowResult = false;
    [self.tableView reloadData];
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
