//
//  ActivityDetailTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-11.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "ActivityDetailTableViewController.h"

@interface ActivityDetailTableViewController ()

@end

@implementation ActivityDetailTableViewController

@synthesize activity;
@synthesize titleLabel,activityDescription;
@synthesize amount, hot, joinState,address,time;
@synthesize titleImgView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        memberIconList = [[NSArray alloc] initWithObjects:_memberIcon1,_memberIcon2,_memberIcon3,_memberIcon4, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    titleLabel.text = activity.title;
    amount.text = [NSString stringWithFormat:@"%@/%@",activity.member,activity.memberUpper];
    hot.text = activity.fav;
    titleImgView.image = activity.cachedImg;
    address.text = activity.title;
    time.text = activity.date;
    _people.text = activity.limit;
    activityDescription.text = @"中国工商银行（全称：中国工商银行股份有限公司）成立于1984年，是中国五大银行之首，世界五百强企业之一，拥有中国最大的客户群，是中国最大的商业银行。 中国工商银行是中国最大的国有独资商业银行，基本任务是依据国家的法律和法规，通过国内外开展融资活动筹集社会资金，加强信贷资金管理，支持企业生产和技术改造，为我国经济建设服务。";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self refreshActivityDetail];
}

- (void)didReceiveMemoryWarning
{    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshActivityDetail
{
    if (activity == nil)
        return;
    
    NSString* URLString = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/api/v1/activity/%@", activity.activityId];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:URL];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error)
    {
        receivedData = [request responseData];
        activityData = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingAllowFragments error:nil];
        
        NSString* detailInfo = @"";//activityData[@"description"];
        detailInfo = [detailInfo stringByAppendingFormat:@"%@", activityData[@"description"]];
        
        _detailContent.text = detailInfo;
        
        NSArray* memberArray = activityData[@"activityMember"];
        NSUInteger memberNumber = memberArray.count;
        
        _totalMemberNum.text = [NSString stringWithFormat:@"(%d)",memberNumber];
        
        for (int i = 0; i < memberIconList.count; i++)
        {
            if (i >= memberNumber)
            {
                [memberIconList[i] setHidden:true];
                continue;
            }
            
            [memberIconList[i] setHidden:false];
            
            NSDictionary* memberInfo = memberArray[i];
            NSString* memberIconUrl = memberInfo[@""];
            NSURL* iconUrl = [NSURL URLWithString:memberIconUrl];
            
            // [UIImage imageNamed:@"user_icon_de.png"];
            [memberIconList[i] LoadFromUrl:iconUrl: [UserManager DefaultIcon]];
        }
        
        NSArray* commentArray = activityData[@"activityComment"];
        NSUInteger commentNumber = commentArray.count;
        
        _totalCommentNumber.text = [NSString stringWithFormat:@"(%d)",commentNumber];
        if (commentNumber > 0)
        {
            //
        }
    }
    
}
/*

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
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
