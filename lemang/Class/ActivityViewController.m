//
//  ActivityViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-7-29.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityDetailViewController.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

@synthesize activityArray;
@synthesize activitySearchBar;
@synthesize activityList;
@synthesize filteredActivityArray;

NSString *navTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    activityArray = [NSArray arrayWithObjects:[Activity activityOfCategory:@"All" name:@"上海大学活动1" icon:[UIImage imageNamed:@"appicon152.png"]],
                  [Activity activityOfCategory:@"Sports" name:@"上海大学活动2" icon:[UIImage imageNamed:@"appicon152.png"]],
                  [Activity activityOfCategory:@"Sports" name:@"上海大学活动3" icon:[UIImage imageNamed:@"appicon152.png"]],
                  [Activity activityOfCategory:@"Music" name:@"交通大学活动1" icon:[UIImage imageNamed:@"appicon152.png"]],
                  [Activity activityOfCategory:@"Music" name:@"交通大学活动2" icon:[UIImage imageNamed:@"appicon152.png"]],
                  [Activity activityOfCategory:@"Business" name:@"同济大学活动1" icon:[UIImage imageNamed:@"appicon152.png"]],
                  [Activity activityOfCategory:@"Business" name:@"同济大学活动2" icon:[UIImage imageNamed:@"appicon152.png"]],
                  [Activity activityOfCategory:@"Others" name:@"同济大学活动3" icon:[UIImage imageNamed:@"appicon152.png"]],
                  [Activity activityOfCategory:@"Others" name:@"复旦大学活动1" icon:[UIImage imageNamed:@"appicon152.png"]],
                  [Activity activityOfCategory:@"Others" name:@"复旦大学活动2" icon:[UIImage imageNamed:@"appicon152.png"]], nil];
    
    
    self.filteredActivityArray = [NSMutableArray arrayWithCapacity:[activityArray count]];
    
    [activityList reloadData];
    
   // [activitySearchBar setHidden:true];
    
   // activitySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, 320, 41)];
    
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    
   // CGRect newBounds = activityList.bounds;
  //  newBounds.origin.y = newBounds.origin.y + activitySearchBar.bounds.size.height;
   // activityList.bounds = newBounds;
}


#pragma mark - Table view data source

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ActivityTableCell";
    UITableViewCell *cell = [activityList
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Activity *activity = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
       cell = [activityList dequeueReusableCellWithIdentifier:CellIdentifier];
        activity = [self.filteredActivityArray objectAtIndex:indexPath.row];
    }
    else
    {
        activity = [self.activityArray objectAtIndex:indexPath.row];
    }
    
    UILabel *titleLable = (UILabel *)[cell viewWithTag:101];
    titleLable.text = activity.name;
    
    UIImageView *activityIcon = (UIImageView *)[cell viewWithTag:100];
    activityIcon.image = activity.icon;
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    NSArray *tempArray = [activityArray filteredArrayUsingPredicate:predicate];
    if (![scope isEqualToString:@"All"])
    {
        NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.category contains[c] %@",scope];
        tempArray = [tempArray filteredArrayUsingPredicate:scopePredicate];
    }
    filteredActivityArray = [NSMutableArray arrayWithArray:tempArray];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
    ActivityDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailViewController"];
    viewController.navigationItem.title = @"活动详细页面";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    activitySearchBar.showsCancelButton = YES;
}

-(IBAction)goToSearch:(id)sender
{
    [activitySearchBar becomeFirstResponder];
//    [activitySearchBar setHidden:false];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];

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
