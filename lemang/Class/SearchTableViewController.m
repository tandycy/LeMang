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

@interface SearchTableViewController ()
{
    NSMutableArray *filteredActivityArray;
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
    filteredActivityArray = [[NSMutableArray alloc]init];
    
    // TODO

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = 0;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        rows = [self.searchResults count];
    }
    else
    {
        rows = [historyItems count];
    }
    return rows;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
                static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        /* Configure the cell. */
        
        // TODO - cell - type?
        
        SearchResultItem *item = nil;
        item = [filteredActivityArray objectAtIndex:indexPath.row];
        cell.textLabel.text = item.title;
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        /* Configure the cell. */
        cell.textLabel.text = [self.historyItems objectAtIndex:indexPath.row];
        return cell;
    }
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSLog(@"%@",scope);
    
    // wot iz scope?
    
    self.searchResults = filteredActivityArray;
}

#pragma mark - UISearchDisplayController delegate methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]                                       objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    //[self.searchDisplayController.searchResultsTableView setRowHeight:95];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:searchOption]];
    //[self.searchDisplayController.searchResultsTableView setRowHeight:95];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO click jump
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        ActivityDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailViewController"];
        viewController.navigationItem.title = @"活动详细页面";
        
        Activity *activity = nil;
        activity = [filteredActivityArray objectAtIndex:indexPath.row];
        
        viewController.activity = activity;
        [viewController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        // done
        [self.searchDisplayController.searchBar becomeFirstResponder];
        searchDisplayController.searchBar.text = historyItems[indexPath.row];
        [self.searchBar setSearchResultsButtonSelected:NO];
    }
}

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
    // TODO after click search
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
    
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //
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
