//
//  ActivityDetailTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-11.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "ActivityDetailTableViewController.h"
#import "ActivityCommentTableViewController.h"

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
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    titleLabel.text = activity.title;
    amount.text = [NSString stringWithFormat:@"%@/%@",activity.member,activity.memberUpper];
    hot.text = activity.fav.stringValue;
    titleImgView.image = activity.cachedImg;
    address.text = activity.title;
    time.text = activity.date;
    _people.text = activity.limit;
    activityDescription.text = @"";
    
    _commentContent.text = @"";
    _commentTittle.text = @"";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self refreshActivityDetail];
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self RefreshCommentList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)RefreshCommentList
{
    NSString* URLString = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/api/v1/activity/%@", activity.activityId];
    URLString = [URLString stringByAppendingString:@"/comment"];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:URL];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error)
    {
        NSData* commentData = [request responseData];
        localCommentData = [NSJSONSerialization JSONObjectWithData:commentData options:NSJSONReadingAllowFragments error:nil][@"content"];
        NSArray* rateIconList = [[NSArray alloc] initWithObjects:_rateIcon1, _rateIcon2, _rateIcon3, _rateIcon4, _rateIcon5, nil];
       
        NSUInteger commentNumber = localCommentData.count;
        
        _totalCommentNumber.text = [NSString stringWithFormat:@"(%d)",commentNumber];
        if (commentNumber > 0)
        {
            NSDictionary* commentItem = localCommentData[0];
            
            _commentTittle.text = commentItem[@"title"];
            _commentContent.text = commentItem[@"content"];
            
            // images
            //int rating
            
            NSNumber* rate = commentItem[@"rating"];
            for (int i = 0; i < rateIconList.count; i++)
            {
                if ( i+1 > rate.integerValue)
                    [rateIconList[i] setImage: [UIImage imageNamed:@"rate_star_off"]];
                else
                    [rateIconList[i] setImage: [UIImage imageNamed:@"rate_star_whole"]];
            }
        }
        else
        {
            _commentTittle.text = @"";
            _commentContent.text = @"";
            for (int i = 0; i < rateIconList.count; i++)
            {
                [rateIconList[i] setImage: [UIImage imageNamed:@"rate_star_off"]];
            }
        }
    }
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
        
        //NSLog(@"%@", activityData);
        
        NSString* detailInfo = @"";//activityData[@"description"];
        detailInfo = [detailInfo stringByAppendingFormat:@"%@", activityData[@"description"]];
        
        _detailContent.text = detailInfo;
        
        NSMutableArray* memberArray = [[NSMutableArray alloc]init];
        
        NSDictionary* memberDataAll = activityData[@"users"];

        if ([memberDataAll isKindOfClass:[NSDictionary class]])
        {
            NSEnumerator* memberEnum = [memberDataAll objectEnumerator];
            for (NSDictionary* obj in memberEnum)
            {
                [memberArray addObject:obj];
            }
        }
        
        
        NSUInteger memberNumber = memberArray.count;
        _totalMemberNum.text = [NSString stringWithFormat:@"(%d)",memberNumber];
        
        NSArray* memberIconList = [[NSArray alloc] initWithObjects:_memberIcon1,_memberIcon2,_memberIcon3,_memberIcon4, nil];
        NSArray* rateIconList = [[NSArray alloc] initWithObjects:_rateIcon1, _rateIcon2, _rateIcon3, _rateIcon4, _rateIcon5, nil];
        NSArray* rateAllList = [[NSArray alloc] initWithObjects:_rateScore1, _rateScore2, _rateScore3, _rateScore4, _rateScore5, nil];
        for (int i = 0; i < memberIconList.count; i++)
        {
            if (i >= memberNumber)
            {
                [memberIconList[i] setHidden:true];
                continue;
            }
            
            [memberIconList[i] setHidden:false];
            
            NSString* rule = memberArray[i][@"role"];
            
            NSDictionary* memberInfo = memberArray[i][@"user"][@"profile"];
            NSString* memberIconUrl = @"";
            if ([memberInfo isKindOfClass:[NSDictionary class]])
            {
                memberIconUrl = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/resources%@",memberInfo[@"iconUrl"]];
                NSURL* iconUrl = [NSURL URLWithString:memberIconUrl];
                [memberIconList[i] LoadFromUrl:iconUrl: [UserManager DefaultIcon]];
            }
            else
                [memberIconList[i] setImage:[UserManager DefaultIcon]];
            
        }
        
        
        address.text = [UserManager filtStr:activityData[@"address"]: @""];
        localCommentData = activityData[@"activityComment"];
        NSUInteger commentNumber = localCommentData.count;
        
        _totalCommentNumber.text = [NSString stringWithFormat:@"(%d)",commentNumber];
        if (commentNumber > 0)
        {
            NSDictionary* commentItem = localCommentData[0];
            
            _commentTittle.text = commentItem[@"title"];
            _commentContent.text = commentItem[@"content"];
            
            // images
            //int rating
            
            NSNumber* rate = commentItem[@"rating"];
            for (int i = 0; i < rateIconList.count; i++)
            {
                if ( i+1 > rate.integerValue)
                    [rateIconList[i] setImage: [UIImage imageNamed:@"rate_star_off"]];
                else
                    [rateIconList[i] setImage: [UIImage imageNamed:@"rate_star_whole"]];
            }
        }
        else
        {
            _commentTittle.text = @"";
            _commentContent.text = @"";
            for (int i = 0; i < rateIconList.count; i++)
            {
                [rateIconList[i] setImage: [UIImage imageNamed:@"rate_star_off"]];
            }
        }

        NSDictionary* board = activityData[@"board"];
        NSNumber* rate = activityData[@"rating"];
        for (int i = 0; i < rateAllList.count; i++)
        {
            if ( i+1 > rate.integerValue)
                [rateAllList[i]  setImage: [UIImage imageNamed:@"rate_star_off"]];
            else
                [rateAllList[i] setImage: [UIImage imageNamed:@"rate_star_whole"]];
        }
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
     //   NSLog(@"%@",indexPath.section);
        ActivityCommentTableViewController *ACTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityCommentTableViewController"];
        [ACTVC SetCommentList:localCommentData];
        [ACTVC SetActivityOwner:self];
        [self.navigationController pushViewController:ACTVC animated:YES];
    }
    else if (indexPath.section == 1){
        ActivityMemberTableViewController *AMTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityMemberTableViewController"];
        [AMTVC SetActivity:activity];
        [self.navigationController pushViewController:AMTVC animated:YES];
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
