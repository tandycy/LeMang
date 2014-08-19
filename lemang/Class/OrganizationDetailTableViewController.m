//
//  OrganizationDetailTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-19.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "OrganizationDetailTableViewController.h"
#import "Constants.h"

@interface OrganizationDetailTableViewController ()

@end

@implementation OrganizationDetailTableViewController

@synthesize orgDetailTitleView;

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
    return 10;
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
