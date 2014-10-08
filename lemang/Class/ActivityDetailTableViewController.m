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

    activityDescription.text = @"";
    
    _commentContent.text = @"";
    _commentTittle.text = @"";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self UpdateActivityDisplay];
    //[self RefreshCommentList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self RefreshCommentList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)RefreshCommentList
{
    NSString* URLString = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/api/v1/activity/%@", localId];
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

- (void) SetActivityData:(NSDictionary *)data
{
    activityData = data;
    localId = data[@"id"];
}

- (void) SetActivityId:(NSNumber *)actid
{
    localId = actid;
}

- (void) RefreshActivityData
{
    activityData = [[NSDictionary alloc]init];
    
    if (!localId)
        return;
    
    NSString* URLString = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/api/v1/activity/%@", localId];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:URL];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error)
    {
        activityData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil];
    }
    
    [self RefreshCommentList];
}

- (NSNumber*)GetCreatorId
{
    return creatorId;
}

- (NSNumber*)GetActivityId
{
    return localId;
}

- (void) UpdateActivityDisplay
{
    if (activityData == nil)
        [self RefreshActivityData];
    
    
    NSString* beginTime = [UserManager filtStr:activityData[@"beginTime"] : @""];
    NSString* endTime = [UserManager filtStr:activityData[@"endTime"] : @""];
    time.text = [beginTime stringByAppendingFormat:@" ~ %@", endTime];
    
    NSDictionary* creator = activityData[@"createdBy"];
    creatorId = creator[@"id"];
    
    NSDictionary* members = activityData[@"users"];
    int memberNum = 0;
    if ([members isKindOfClass:[NSDictionary class]])
    {
        memberNum = members.count;
    }
    NSString* memberMax = [UserManager filtStr:activityData[@"peopleLimit"] : @""];
    amount.text = [NSString stringWithFormat:@"%d/%@",memberNum,memberMax];
    
    
    NSString* imgUrlString = [UserManager filtStr:activityData[@"iconUrl"] :@""];
    if (imgUrlString.length > 0)
    {
        NSString* tempstr = @"http://e.taoware.com:8080/quickstart/resources";
        //tempstr = [tempstr stringByAppendingFormat:@"/a/%@/", activityData[@"id"]];
        tempstr = [tempstr stringByAppendingString:imgUrlString];
        imgUrlString = tempstr;
    }
    NSURL* imgUrl = [NSURL URLWithString:imgUrlString];
    [titleImgView LoadFromUrl:imgUrl :[UIImage imageNamed:@"default_Icon"]];
    
    NSDictionary* board = activityData[@"board"];
    NSNumber* favNum = [NSNumber numberWithInt:0];
    if ([board isKindOfClass:[NSDictionary class]])
    {
        NSNumber* fav = board[@"bookmarkCount"];
        if ([fav isKindOfClass:[NSDictionary class]])
            favNum = fav;
    }    
    hot.text = [NSString stringWithFormat:@"%@", favNum];

    
    titleLabel.text = [UserManager filtStr:activityData[@"title"] :@""];
    address.text = [UserManager filtStr:activityData[@"address"] :@""];
    _people.text = [UserManager filtStr:activityData[@"regionLimit"] : @""];
    
    _detailContent.text = [UserManager filtStr:activityData[@"description"] :@""];
    
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
    
    NSNumber* bookmarkNum = board[@"bookmarkCount"];
    hot.text = [NSString stringWithFormat:@"%@",bookmarkNum];
    NSNumber* score = board[@"rating"];
    
    for (int i = 0; i < rateAllList.count; i++)
    {
        if ( i+1 > score.integerValue)
            [rateAllList[i]  setImage: [UIImage imageNamed:@"rate_star_off"]];
        else
            [rateAllList[i] setImage: [UIImage imageNamed:@"rate_star_whole"]];
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
        [AMTVC SetActivity:activityData];
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
