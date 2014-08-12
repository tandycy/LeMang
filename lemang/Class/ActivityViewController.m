//
//  ActivityViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-7-29.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityDetailViewController.h"

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

- (void)viewDidLoad
{
    NSLog(@"load");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"load2");
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    //activitySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(50.0f,0.0f,200.0f,44.0f)];
    //[activitySearchBar setPlaceholder:@"search"];
   // [activitySearchBar setShowsCancelButton:YES];
   // activitySearchBar.delegate = self;
   // [self.navigationController.navigationBar addSubview:activitySearchBar];

    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor colorWithRed:0.94117647 green:0.42352941 blue:0.11764706 alpha:1]];
    
    // initialize activity list
    UIImage *businessIcon = [UIImage imageNamed:@"buisness_icon.png"];
    UIImage *schoolIcon = [UIImage imageNamed:@"school_icon.png"];
    UIImage *groupIcon = [UIImage imageNamed:@"group_icon.png"];
    UIImage *privateIcon = [UIImage imageNamed:@"private_icon.png"];
    
    activityArray = [NSArray arrayWithObjects:
                    [Activity activityOfCategory:@"All" img:[UIImage imageNamed:@"group1.png"]
                                                        title:@"上海大学活动1"
                                                        date:@"7月25日 周五 10:00--8月10日 周日 18:00"
                                                        limit:@"限上海交大垂钓社"
                                                        icon:businessIcon
                                                        member:@"47/50"
                                                        fav:@"325"],
                     [Activity activityOfCategory:@"All" img:[UIImage imageNamed:@"group1.png"]
                                            title:@"上海大学活动2"
                                             date:@"7月25日 周五 10：00--8月10日 周日 18：00"
                                            limit:@"限上海交大垂钓社"
                                             icon:schoolIcon
                                           member:@"47/50"
                                              fav:@"325"],
                     [Activity activityOfCategory:@"All" img:[UIImage imageNamed:@"group1.png"]
                                            title:@"上海大学活动3"
                                             date:@"7月25日 周五 10：00--8月10日 周日 18：00"
                                            limit:@"限上海交大垂钓社"
                                             icon:groupIcon
                                           member:@"47/50"
                                              fav:@"325"],
                     [Activity activityOfCategory:@"All" img:[UIImage imageNamed:@"group1.png"]
                                            title:@"上海交通大学活动1"
                                             date:@"7月25日 周五 10：00--8月10日 周日 18：00"
                                            limit:@"限上海交大垂钓社"
                                             icon:privateIcon
                                             member:@"47/50"
                                              fav:@"325"],
                     [Activity activityOfCategory:@"All" img:[UIImage imageNamed:@"group1.png"]
                                            title:@"上海交通大学活动2"
                                             date:@"7月25日 周五 10：00--8月10日 周日 18：00"
                                            limit:@"限上海交大垂钓社"
                                             icon:[UIImage imageNamed:@"group1.png"]
                                           member:@"47/50"
                                              fav:@"325"],
                     [Activity activityOfCategory:@"All" img:[UIImage imageNamed:@"group1.png"]
                                            title:@"上海交通大学活动3"
                                             date:@"7月25日 周五 10：00--8月10日 周日 18：00"
                                            limit:@"限上海交大垂钓社"
                                             icon:[UIImage imageNamed:@"group1.png"]
                                           member:@"47/50"
                                              fav:@"325"],
                     [Activity activityOfCategory:@"All" img:[UIImage imageNamed:@"group1.png"]
                                            title:@"上海同济大学活动1"
                                             date:@"7月25日 周五 10：00--8月10日 周日 18：00"
                                            limit:@"限上海交大垂钓社"
                                             icon:[UIImage imageNamed:@"group1.png"]
                                           member:@"47/50"
                                              fav:@"325"],
                     [Activity activityOfCategory:@"All" img:[UIImage imageNamed:@"group1.png"]
                                            title:@"上海同济大学活动2"
                                             date:@"7月25日 周五 10：00--8月10日 周日 18：00"
                                            limit:@"限上海交大垂钓社"
                                             icon:[UIImage imageNamed:@"group1.png"]
                                           member:@"47/50"
                                              fav:@"325"],nil
                     ];
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
    memberLable.text = activity.member;
    
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
