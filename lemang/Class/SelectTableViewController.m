//
//  SelectTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-25.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "SelectTableViewController.h"
#import "SearchTableViewController.h"
#import "Constants.h"

@interface SelectTableViewController ()
{
    NSMutableArray *titleArray;
}

@end

@implementation SelectTableViewController

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
    [SchoolManager InitSchoolList];
    [self RefreshTags];
    
    titleArray = [[NSMutableArray alloc] initWithObjects:@"热门标签", @"学校", nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) RefreshTags
{
    hotArray = [[NSMutableArray alloc]init];
    schoolArray = [[NSMutableArray alloc]init];
    bookmarkArray = [[NSMutableArray alloc]init];
    
    for (TagItem* item in [UserManager GetTags])
    {
        [hotArray addObject:item.name];
    }
    
    schoolArray = [SchoolManager GetSchoolNameList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return hotArray.count;
    
    if (section == 1)
        return schoolArray.count;
    
    if (section == 2)
        return bookmarkArray.count;

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSString* tagName = @"";
    
    if (indexPath.section == 0)
        tagName = hotArray[indexPath.row];
    if (indexPath.section == 1)
        tagName = schoolArray[indexPath.row];
    if (indexPath.section == 2)
        tagName = bookmarkArray[indexPath.row];
    
    cell.textLabel.text = tagName;
    cell.textLabel.font = [UIFont fontWithName:defaultFont size:13];
    cell.textLabel.textColor = defaultTitleGray96;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [view setBackgroundColor:[UIColor colorWithRed:0.95294117647059 green:0.95294117647059 blue:0.95294117647059 alpha:1]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
    label.textColor = [UIColor colorWithRed:0.94117647 green:0.42352941 blue:0.11764706 alpha:1];
    label.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:13];
    label.backgroundColor = [UIColor clearColor];
    label.text = [titleArray objectAtIndex:section];
    [view addSubview:label];
    
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    SearchTableViewController *searchView = [owner.storyboard instantiateViewControllerWithIdentifier:@"SearchTableViewController"];

    NSString* tagName = @"";
    
    if (indexPath.section == 0)
        tagName = hotArray[indexPath.row];
    if (indexPath.section == 1)
        tagName = schoolArray[indexPath.row];
    if (indexPath.section == 2)
        tagName = bookmarkArray[indexPath.row];
    
    if (isactivity)
        [searchView SetSearchActivityTag:tagName];
    else
        [searchView SetSearchOrganizationTag:tagName];
    
    if (popoverControl)
        [popoverControl dismissPopoverAnimated:false];
    [owner.navigationController pushViewController:searchView animated:YES];
}

-(void)SetAsActivity:(UIViewController*)_owner :(FPPopoverController*)popover
{
    isactivity = true;
    owner = _owner;
    popoverControl = popover;
}

-(void)SetAsOrganization:(UIViewController*)_owner :(FPPopoverController*)popover
{
    isactivity = false;
    owner = _owner;
    popoverControl = popover;
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

@end
