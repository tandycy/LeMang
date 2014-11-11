//
//  MyAcitivityTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "MyAcitivityTableViewController.h"
#import "ActivityDetailViewController.h"
#import "Constants.h"

@interface MyAcitivityTableViewController ()
{
    NSMutableArray *titleArray;
}

@end

@implementation MyAcitivityTableViewController

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
    titleArray = [[NSMutableArray alloc] initWithObjects:@"管理的活动", @"参加的活动", @"收藏的活动", nil];
    
    [self ClearDataArray];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self RefreshActivityList];
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

- (void)ClearDataArray
{
    adminActivity = [[NSMutableArray alloc]init];
    joinedActivity = [[NSMutableArray alloc]init];
    bookmarkActivity = [[NSMutableArray alloc]init];
}

- (void)RefreshActivityList
{
    NSNumber* uid = [[UserManager Instance]GetLocalUserId];
    
    NSString* URLString = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    URLString = [URLString stringByAppendingFormat:@"%@/activities", uid];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    ASIHTTPRequest *URLRequest = [ASIHTTPRequest requestWithURL:URL];
    [URLRequest setUsername:@"admin"];
    [URLRequest setPassword:@"admin"];
    
    [URLRequest startSynchronous];
    
    NSError *error = [URLRequest error];
    
    if (!error)
    {
        NSArray* returnData = [NSJSONSerialization JSONObjectWithData:[URLRequest responseData] options:NSJSONReadingAllowFragments error:nil][@"content"];
        
        for (int i = 0; i < returnData.count; i++)
        {
            NSDictionary* item = returnData[i];
            NSDictionary* creator = item[@"createdBy"];
            NSNumber* cid = creator[@"id"];
            
            if (uid.longValue == cid.longValue)
            {
                [adminActivity addObject:item];
            }
            else
            {
                [joinedActivity addObject:item];
            }
        }
    }
    else
    {
        // TODO
    }
    
    NSString* bookmarkStr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    bookmarkStr = [bookmarkStr stringByAppendingFormat:@"%@/bookmark/activity", uid];
    NSURL *bookmarkUrl = [NSURL URLWithString:bookmarkStr];
    
    ASIHTTPRequest *bookmarkRequest = [ASIHTTPRequest requestWithURL:bookmarkUrl];
    [bookmarkRequest setUsername:@"admin"];
    [bookmarkRequest setPassword:@"admin"];
    
    [bookmarkRequest startSynchronous];
    
    error = [bookmarkRequest error];
    
    if (!error)
    {
        NSArray* returnData = [NSJSONSerialization JSONObjectWithData:[bookmarkRequest responseData] options:NSJSONReadingAllowFragments error:nil][@"content"];
        
        for (int i = 0; i < returnData.count; i++)
        {
            NSDictionary* data = returnData[i];
            NSDictionary* item = data[@"value"];
            [bookmarkActivity addObject:item];
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {
        if(adminActivity.count==0)
        {
            return 1;
        }
        else
            return adminActivity.count;
    }
    if (section == 1)
    {
        if(joinedActivity.count==0)
        {
            return 1;
        }
        else
            return joinedActivity.count;
    }
    if (section == 2)
    {
        if(bookmarkActivity.count==0)
        {
            return 1;
        }
        else
            return bookmarkActivity.count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyActivityCell" forIndexPath:indexPath];
    
    if (cell==nil) {
        cell = [[MyActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyActivityCell"];
    }
    
    // Configure the cell...
    int section = indexPath.section;
    NSDictionary* actData = nil;
    
    UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    
    textLable.textColor = defaultDarkGray137;
    textLable.font = [UIFont fontWithName:defaultBoldFont size:13];
    textLable.backgroundColor = [UIColor whiteColor];
    textLable.textAlignment = NSTextAlignmentCenter;
    textLable.userInteractionEnabled = NO;
    
    if (section == 0)
    {
        if(adminActivity.count==0)
        {
            [cell setUserInteractionEnabled:NO];
            textLable.text = @"暂无管理的活动";
            [cell addSubview:textLable];
        }
        else
        {
            actData = adminActivity[indexPath.row];
            [cell SetAdmin];
        }
    }
    else if (section == 1)
    {
        if(joinedActivity.count==0)
        {
            [cell setUserInteractionEnabled:NO];
            textLable.text = @"暂无参加的活动";
            [cell addSubview:textLable];
        }
        else
        {
            actData = joinedActivity[indexPath.row];
            [cell SetJoin];
        }
    }
    else if (section == 2)
    {
        if(bookmarkActivity.count==0)
        {
            [cell setUserInteractionEnabled:NO];
            textLable.text = @"暂无收藏的活动";
            [cell addSubview:textLable];
        }
        else
        {
        actData = bookmarkActivity[indexPath.row];
        
        NSNumber* aid = actData[@"id"];
        bool isjoined = false;
        
        for (NSDictionary* item in adminActivity)
        {
            NSNumber* actid = item[@"id"];
            if (actid.longValue == aid.longValue)
            {
                isjoined = true;
                break;
            }
        }
        
        if (!isjoined)
        {
            for (NSDictionary* item in joinedActivity)
            {
                NSNumber* actid = item[@"id"];
                if (actid.longValue == aid.longValue)
                {
                    isjoined = true;
                    break;
                }
            }
        }
        
        if (isjoined)
            [cell SetBookmarkJoined];
        else
            [cell SetBookmark];
        }
    }
    
    [cell SetData:actData :self];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ActivityDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailViewController"];
    viewController.navigationItem.title = @"活动详细页面";
    
    NSDictionary* actData = nil;
    
    if (indexPath.section == 0)
    {
        actData = adminActivity[indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        actData = joinedActivity[indexPath.row];
    }
    else if (indexPath.section == 2)
    {
        actData = bookmarkActivity[indexPath.row];
    }
    
    [viewController SetData:actData];    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
    [self initNavBar];
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

@end
