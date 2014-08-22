//
//  OrganizationDetailTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-19.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "OrganizationDetailTableViewController.h"
#import "Constants.h"
#import "ActivityDetailViewController.h"
#import "Activity.h"

typedef enum {
	ActivityMember = 100,
	ActivityTitle = 101,
	ActivityState = 102,
} OrgActivityListTags;



@interface OrganizationDetailTableViewController ()

@end

@implementation OrganizationDetailTableViewController

@synthesize activityArray;
@synthesize orgDetailTitleView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        activityArray = [[NSArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createActivityData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIImageView *orgLocationBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"oranization_add_bar.png"]];
    UIImageView *orgTempBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"oranization_add_bar.png"]];
    UILabel *orgLocation = [[UILabel alloc]initWithFrame:CGRectMake(0, 137, 320, 33)];
    UILabel *orgtemp = [[UILabel alloc]initWithFrame:CGRectMake(0, 169, 320, 33)];
    [orgLocation addSubview:orgLocationBg];
    [orgtemp addSubview:orgTempBg];
    
    UILabel *orgLocationTitle = [[UILabel alloc]initWithFrame:CGRectMake(13, 10, 65, 13)];
    orgLocationTitle.text = @"商家地点：";
    orgLocationTitle.font = [UIFont fontWithName:defaultBoldFont size:13];
    [orgLocation addSubview:orgLocationTitle];
    
    UILabel *orgTempTitle = [[UILabel alloc]initWithFrame:CGRectMake(13, 10, 65, 13)];
    orgTempTitle.text = @"商户信息：";
    orgTempTitle.font = [UIFont fontWithName:defaultBoldFont size:13];
    [orgtemp addSubview:orgTempTitle];
    
    [orgDetailTitleView addSubview:orgLocation];
    [orgDetailTitleView addSubview:orgtemp];
    
}

- (void)createActivityData
{
    UIImage *businessIcon = [UIImage imageNamed:@"buisness_icon.png"];
    UIImage *schoolIcon = [UIImage imageNamed:@"school_icon.png"];
    UIImage *groupIcon = [UIImage imageNamed:@"group_icon.png"];
    UIImage *privateIcon = [UIImage imageNamed:@"private_icon.png"];
    
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return activityArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *orgDetailCell = @"orgDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orgDetailCell forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (cell==nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:orgDetailCell forIndexPath:indexPath];
    }

    UIImageView *bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"activity_bar.png"]];
    [cell addSubview:bg];
    
    Activity *activity = nil;
    activity = [self.activityArray objectAtIndex:indexPath.row];
    
    UILabel *activityMember = (UILabel*)[cell viewWithTag:ActivityMember];
    activityMember.text = activity.member;
    
    UILabel *activityTitle = (UILabel*)[cell viewWithTag:ActivityTitle];
    activityTitle.text = activity.title;
    
    UIImageView *activityState = (UIImageView*)[cell viewWithTag:ActivityState];
    UIImage *on = [UIImage imageNamed:@"activity_state_on.png"];
    UIImage *off = [UIImage imageNamed:@"activity_state_off.png"];
    if (activity.state) {
        activityState.image = on;
    }
    else activityState.image = off;
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"org_actlist_title_back.png"]];
    [view addSubview:bgView];
    //[view setBackgroundColor:[UIColor colorWithRed:0.95294117647059 green:0.95294117647059 blue:0.95294117647059 alpha:1]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
    label.textColor = [UIColor colorWithRed:0.94117647 green:0.42352941 blue:0.11764706 alpha:1];
    label.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:13];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"开展的活动";
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ActivityDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailViewController"];
    viewController.navigationItem.title = @"活动详细页面";
    
    viewController.activity = [self.activityArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:viewController animated:YES];
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
