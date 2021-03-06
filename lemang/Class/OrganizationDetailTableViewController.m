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
#import "UMSocial.h"
#import "ActivityMemberTableViewController.h"

typedef enum {
	ActivityMember = 100,
	ActivityTitle = 101,
	ActivityState = 102,
} OrgActivityListTags;



@interface OrganizationDetailTableViewController ()

@end

@implementation OrganizationDetailTableViewController
{
    UILabel *orgLocation;
    UILabel *orgInfo;
    
    UIBarButtonItem* noticeButton;
    
    NSMutableArray* memberIconArray;
    UILabel* memberCount;
    
    UIBarButtonItem* bookmarkButton;
    UIBarButtonItem* joinButton;
}

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
    
    [self memberView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    bookmarkButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bottom_like_on"] style:UIBarButtonItemStylePlain target:self action:@selector(likeClick:)];
    joinButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bottom_sign_on"] style:UIBarButtonItemStylePlain target:self action:@selector(signClick:)];
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bottom_share_on"] style:UIBarButtonItemStylePlain target:self action:@selector(shareClick:)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *buttonArray = [NSArray arrayWithObjects:flexItem, bookmarkButton, flexItem, share, flexItem, joinButton, flexItem, nil];
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
    NSLog(@"%f",self.view.frame.size.height);
    [self.toolbar setTintColor:defaultMainColor];
    [self.toolbar setBarStyle:UIBarStyleDefault];
    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.toolbar setItems:buttonArray];
    [self.tableView addSubview:self.toolbar];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, -53.0f, 0.0f); //set tableview scroll range
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIImageView *orgLocationBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"oranization_add_bar.png"]];
    UIImageView *orgTempBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"oranization_add_bar.png"]];
    
    UILabel* orgLocationGroup = [[UILabel alloc]initWithFrame:CGRectMake(0, 137, 320, 33)];
    UILabel* orgInfoGroup = [[UILabel alloc]initWithFrame:CGRectMake(0, 169, 320, 33)];
    [orgLocationGroup addSubview:orgLocationBg];
    [orgInfoGroup addSubview:orgTempBg];
    
    UILabel *orgLocationTitle = [[UILabel alloc]initWithFrame:CGRectMake(13, 10, 65, 13)];
    orgLocationTitle.text = @"社群地点：";
    orgLocationTitle.font = [UIFont fontWithName:defaultBoldFont size:13];
    [orgLocationGroup addSubview:orgLocationTitle];
    
    orgLocation = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 500, 13)];
    orgLocation.text = @"";
    orgLocation.font = [UIFont fontWithName:defaultBoldFont size:13];
    [orgLocationGroup addSubview:orgLocation];
    
    UILabel *orgTempTitle = [[UILabel alloc]initWithFrame:CGRectMake(13, 10, 65, 13)];
    orgTempTitle.text = @"社群信息：";
    orgTempTitle.font = [UIFont fontWithName:defaultBoldFont size:13];
    [orgInfoGroup addSubview:orgTempTitle];
    
    orgInfo = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 500, 13)];
    orgInfo.text = @"";
    orgInfo.font = [UIFont fontWithName:defaultBoldFont size:13];
    [orgInfoGroup addSubview:orgInfo];
    
    [orgDetailTitleView addSubview:orgLocationGroup];
    [orgDetailTitleView addSubview:orgInfoGroup];
    
    activityArray = [[NSArray alloc]init];
    
    [self updateDisplay];
}

-(IBAction)createAnnounce:(id)sender
{
    if ([[UserManager Instance]GetLocalUserId].longValue != creatorId.longValue)
        return;
    
    CreateActivityTableViewController *createActivityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateActivityTableViewController"];
    [createActivityVC SetAnnounce:orgName];
    [self.navigationController pushViewController:createActivityVC animated:YES];
}

-(void)memberView
{
    [self.upperView setFrame:CGRectMake(0, 0, 320, 269)];
    UIButton *memberDetailBT = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, 320, 70)];
    [memberDetailBT setImage:[UIImage imageNamed:@"or_back"] forState:UIControlStateNormal];
    [memberDetailBT addTarget:self action:@selector(orgMemberBtClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:memberDetailBT];
    
    UILabel *memberTitle = [[UILabel alloc]initWithFrame:CGRectMake(11, 11, 29, 34)];
    memberTitle.font = [UIFont fontWithName:defaultFont size:13];
    memberTitle.text = @"社群成员";
    memberTitle.textAlignment = UITextAlignmentCenter;
    memberTitle.lineBreakMode = UILineBreakModeWordWrap;
    memberTitle.numberOfLines = 0;
    
    memberCount = [[UILabel alloc]initWithFrame:CGRectMake(11, 47, 29, 15)];
    memberCount.font = [UIFont fontWithName:defaultFont size:13];
    memberCount.text = @"(20)";
    memberCount.textAlignment = UITextAlignmentCenter;
    
    [memberDetailBT addSubview:memberCount];
    [memberDetailBT addSubview:memberTitle];
    
    memberIconArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 4; i++)
    {
        IconImageViewLoader* icon = [[IconImageViewLoader alloc]initWithFrame:CGRectMake(60+i*58, 10, 50, 50)];
        [memberDetailBT addSubview:icon];
        [memberIconArray addObject: icon];
    }
}

- (void) UpdateMemberInfo
{
    for (IconImageViewLoader* icon in memberIconArray)
    {
        [icon setHidden:true];
    }
    memberCount.text = @"(0)";
    
    NSString* memberUrlStr = @"http://e.taoware.com:8080/quickstart/api/v1/association/";
    memberUrlStr = [memberUrlStr stringByAppendingFormat:@"%@/user", orgId];
    ASIHTTPRequest* memberRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:memberUrlStr]];
    [memberRequest startSynchronous];
    
    NSError* error = [memberRequest error];
    
    if (error)
        return;
    
    NSArray* members = [NSJSONSerialization JSONObjectWithData:[memberRequest responseData] options:NSJSONReadingAllowFragments error:nil][@"content"];
    
    if (![members isKindOfClass:[NSArray class]])
        members = [NSArray alloc];
    
    NSMutableArray* filteredMembers = [[NSMutableArray alloc]init];
    
    for (NSDictionary* member in members)
    {
        if (filteredMembers.count >= memberIconArray.count)
            break;
        
        NSString* rule = member[@"role"];
        
        if ([rule isEqualToString:@"User"])
        {
            NSDictionary* userData = member[@"user"];
            [filteredMembers addObject:userData];
        }
        else if ([rule isEqualToString:@"Administrator"])
        {
            NSDictionary* userData = member[@"user"];
            [filteredMembers addObject:userData];
        }
    }    
    
    memberCount.text = [NSString stringWithFormat:@"(%d)", filteredMembers.count];
    
    for (int i = 0; i < filteredMembers.count; i++)
    {
        IconImageViewLoader* icon = memberIconArray[i];
        [icon setHidden:false];
        NSDictionary* data = filteredMembers[i];
        NSString* iconStr = @"";
        
        NSDictionary* profile = data[@"profile"];
        if ([profile isKindOfClass:[NSDictionary class]])
        {
            iconStr = profile[@"iconUrl"];
            iconStr = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/resources%@", iconStr];
            
        }
        
        [icon LoadFromUrl: [NSURL URLWithString:iconStr] :[UserManager DefaultIcon]];
    }
}

-(IBAction)orgMemberBtClick:(id)sender
{
    ActivityMemberTableViewController *activityMemberTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityMemberTableViewController"];
    [activityMemberTVC SetOrganization:localData];
    [self.navigationController pushViewController:activityMemberTVC animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.toolbar.frame = CGRectMake(0,self.tableView.contentOffset.y+self.view.frame.size.height-40, 320, 40);
}

- (void) SetOrgnizationId:(NSNumber *)oid
{
    orgId = oid;
}

- (void) SetOrgnizationData:(NSDictionary *)data
{
    localData = data;
    orgId = localData[@"id"];
}

- (void) SetOrgnizationIcon:(UIImage *)image
{
    localIconData = image;
}

- (void) RefreshData
{
    NSString* URLString = @"http://e.taoware.com:8080/quickstart/api/v1/association/";
    URLString = [URLString stringByAppendingFormat:@"%@", orgId];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:URL];
    [request setUsername:@"admin"];
    [request setPassword:@"admin"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error)
    {
        localData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil];
    }

}

- (void) updateDisplay
{
    if (orgId == NULL)
        return;
    
    if (localData == nil)
    {
        [self RefreshData];
    }
    
    orgName = localData[@"name"];
    NSDictionary* creator = localData[@"createdBy"];
    creatorId = creator[@"id"];
    
    if ([[UserManager Instance]GetLocalUserId].longValue == creatorId.longValue)
    {
        if (!noticeButton)
        {
            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]init];
            rightButton.title = @"发通知";
            self.navigationItem.rightBarButtonItem = rightButton;
            rightButton.target = self;
            rightButton.action = @selector(createAnnounce:);
            noticeButton = rightButton;
        }
    }
    else
    {
        if (noticeButton)
        {
            noticeButton = nil;
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    
    _orgnizationTittle.text = [UserManager filtStr:localData[@"name"] : @""];

    NSString* detailStr = [UserManager filtStr:localData[@"description"] : @""];
    _organizationDetail.text = detailStr;
    
    if (localIconData != nil)
        [_organizationIcon setImage:localIconData];
    else
    {
        NSString* iconUrl = [UserManager filtStr:localData[@"iconUrl"]: @""];
        
        if (iconUrl.length > 0)
        {
            NSString* tempstr = @"http://e.taoware.com:8080/quickstart/resources";
            //tempstr = [tempstr stringByAppendingFormat:@"/g/%@/", orgId];
            tempstr = [tempstr stringByAppendingString:iconUrl];
            iconUrl = tempstr;
        }
        
        [_organizationIcon LoadFromUrl:[NSURL URLWithString:iconUrl] :[UIImage imageNamed:@"icon_org"] :@selector(SetOrgnizationIcon:) :self];
    }
    
    //   - id - contact - department - peopleLimit - tags - description - iconUrl - address - regionLimit - otherLimit - users - linkUrl - name - area - shortName - createdBy - createdDate - university

    orgLocation.text = [UserManager filtStr:localData[@"address"] : @""];
    orgInfo.text = [UserManager filtStr:localData[@"contact"] : @""];
    
    NSString* groupType = localData[@"type"];
    [self ParseOrgType:groupType];
    
    // Get group activity
    NSString* actUrlStr = @"http://e.taoware.com:8080/quickstart/api/v1/activity/";
    actUrlStr = [actUrlStr stringByAppendingFormat:@"%@/%@", groupType, orgId];
    ASIHTTPRequest* activityRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:actUrlStr]];
    [activityRequest startSynchronous];
    NSError* error = [activityRequest error];
    int returnCode = [activityRequest responseStatusCode];
    
    if (!error)
    {
        NSArray* data = [NSJSONSerialization JSONObjectWithData:[activityRequest responseData] options:NSJSONReadingAllowFragments error:nil][@"content"];
        NSMutableArray* actTemp = [[NSMutableArray alloc]init];
        
        for (NSDictionary* item in data)
        {
            [actTemp addObject:item];
        }
        activityArray = [NSArray arrayWithArray:actTemp];
    }
    
    [self UpdateMemberInfo];
    [self UpdateProfileInfo];
}

- (void)UpdateProfileInfo
{
    canJoin = true;
    canBookMark = true;
    
    NSNumber* uid = [[UserManager Instance]GetLocalUserId];
    
    NSString* URLString = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    URLString = [URLString stringByAppendingFormat:@"%@/associations", uid];
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
            NSNumber* oid = item[@"id"];
            
            if (oid.longValue == orgId.longValue)
            {
                canJoin = false;
                break;
            }
        }
    }
    
    NSString* bookmarkStr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    bookmarkStr = [bookmarkStr stringByAppendingFormat:@"%@/bookmark/group", uid];
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
            NSDictionary* data = returnData[i][@"value"];
            NSNumber* oid = data[@"id"];
            
            if (oid.longValue == orgId.longValue)
            {
                canBookMark = false;
                break;
            }
        }
    }

    if (canJoin)
    {
        [joinButton setImage:[UIImage imageNamed:@"bottom_sign_on"]];
    }
    else
    {
        [joinButton setImage:[UIImage imageNamed:@"bottom_sign_done"]];
    }
    
    if (canBookMark)
    {
        [bookmarkButton setImage:[UIImage imageNamed:@"bottom_like_on"]];
    }
    else
    {
        [bookmarkButton setImage:[UIImage imageNamed:@"bottom_like_done"]];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return activityArray.count;
}

- (void)ParseOrgType:(NSString*)input
{
    if ([input isEqualToString:@"University"])
    {
        orgType = University;
        //[_typeIcon setImage:[UIImage imageNamed:@"school_icon"]];
    }
    else if ([input isEqualToString:@"Department"])
    {
        orgType = Department;
        //[_typeIcon setImage:[UIImage imageNamed:@"school_icon"]];
    }
    else if ([input isEqualToString:@"Person"])
    {
        orgType = Person;
        //[_typeIcon setImage:[UIImage imageNamed:@"private_icon"]];
    }
    else if ([input isEqualToString:@"Association"])
    {
        orgType = Association;
        //[_typeIcon setImage:[UIImage imageNamed:@"group_icon"]];
    }
    else if ([input isEqualToString:@"Company"])
    {
        orgType = Company;
        //[_typeIcon setImage:[UIImage imageNamed:@"buisness_icon"]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrganizationActivityCell";
    OrganizationActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ( cell == nil )
    {
        cell = [[OrganizationActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    UIImageView *bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"activity_bar.png"]];
    [cell addSubview:bg];
    
    NSDictionary* actData = activityArray[indexPath.row];
    [cell SetData:actData];
    
 
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
    
    [viewController SetData:activityArray[indexPath.row]];
    //viewController.activity = activityArray[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

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

- (void)viewWillAppear:(BOOL)animated
{
    [self initNavBar];
    [self.tabBarController.tabBar setHidden:YES];
    
}


-(IBAction)likeClick:(id)sender{
    
    if (![UserManager IsInitSuccess])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户未登录" message:@"登陆后才能执行该操作。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        
        return;
    }
    
    if (!canBookMark)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"已经收藏了该社群。" delegate:Nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    NSString* urlstr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    urlstr = [urlstr stringByAppendingFormat:@"%@/group/%@", [[UserManager Instance]GetLocalUserId], orgId];
    NSURL* url = [NSURL URLWithString:urlstr];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    
    [request setUsername:[UserManager UserName]];
    [request setPassword:[UserManager UserPW]];
    
    [request addRequestHeader:@"Content-Type" value:@"application/json;charset=UTF-8"];
    [request setRequestMethod:@"POST"];
    
    [request startSynchronous];
    
    NSError* error = [request error];
    if (!error)
    {
        // TODO
        int resCode = [request responseStatusCode];
        NSLog(@"bookmark %d",resCode);
        
        if (resCode == 200)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"收藏成功" message:@"成功收藏至我的社群。" delegate:Nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            
            canBookMark = false;
            [bookmarkButton setImage:[UIImage imageNamed:@"bottom_like_done"]];
        }
    }

}

-(IBAction)signClick:(id)sender{
    
    if (![UserManager IsInitSuccess])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户未登录" message:@"登陆后才能执行该操作。" delegate:Nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        
        return;
    }
    
    if (!canJoin)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"已经加入了该社群。" delegate:Nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        
        return;
    }
    
    NSString* urlstr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    urlstr = [urlstr stringByAppendingFormat:@"%@/request/association/%@", [[UserManager Instance]GetLocalUserId], orgId];
    NSURL* url = [NSURL URLWithString:urlstr];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    
    [request setUsername:[UserManager UserName]];
    [request setPassword:[UserManager UserPW]];
    
    [request addRequestHeader:@"Content-Type" value:@"application/json;charset=UTF-8"];
    [request setRequestMethod:@"POST"];
    
    [request startSynchronous];
    
    NSError* error = [request error];
    if (!error)
    {
        // TODO
        int resCode = [request responseStatusCode];
        NSLog(@"regist %d",resCode);
        
        if (resCode == 200)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"报名成功" message:@"成功提交报名申请。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
            [alertView show];
        }
    }
}

-(IBAction)shareClick:(id)sender{
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5422c5acfd98c5ccad0135fc"
                                      shareText:@"你要分享的文字"
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToRenren,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,nil]
                                       delegate:nil];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
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
