//
//  ActivityDetailViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-7-29.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityDetailTableViewController.h"
#import "CreateActivityCommentViewController.h"
#import "Constants.h"
#import "UMSocial.h"

@interface ActivityDetailViewController ()

@end

@implementation ActivityDetailViewController
{
    ActivityDetailTableViewController *tableVC;
}

@synthesize title;
@synthesize containerView;
@synthesize toolBar,goComment;
@synthesize activity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        /*
         UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
         backButton.frame = CGRectMake(0.0, 0.0, 40.0, 27.0);
         [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
         [backButton setImage:[UIImage imageNamed:@"top_back_down.png"] forState:UIControlStateSelected];
         [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
         UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
         temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
         self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
         */
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //  self.navigationItem.title = activity.title;
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor colorWithRed:0.94117647 green:0.42352941 blue:0.11764706 alpha:1], UITextAttributeTextColor,
                                                                     [UIColor colorWithRed:0.94117647 green:0.42352941 blue:0.11764706 alpha:1], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                                     [UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,
                                                                     nil]];
    // [self.tabBarController.tabBar setHidden:YES];
    
    tableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailTableViewController"];
    if (activity)
        [tableVC SetActivityData:[activity GetActivityData]];
    else
        [tableVC SetActivityData:localData];
    
    if (activity)
        [tableVC SetActivityId:activity.activityId];
    else
        [tableVC SetActivityId:localId];
    
    toolBar.tintColor = defaultMainColor;
    
    [self addChildViewController:tableVC];
    [containerView addSubview:tableVC.view];
    [self didMoveToParentViewController:tableVC];
    [self.view addSubview:toolBar];
    
    goComment.target = self;
    goComment.action = @selector(goCommentPage:);
    
    [self UpdateProfileInfo];
}

-(IBAction)goCommentPage:(id)sender{
    if (![UserManager IsInitSuccess])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户未登录" message:@"登陆后才能执行该操作。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        return;
    }
    
    NSNumber* actId = activity.activityId;
    bool isjoin = false;
    NSString* URLString = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    URLString = [URLString stringByAppendingFormat:@"%@/activities", [[UserManager Instance]GetLocalUserId]];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    ASIHTTPRequest *URLRequest = [ASIHTTPRequest requestWithURL:URL];
    [URLRequest startSynchronous];
    NSError *error = [URLRequest error];
    
    if (!error)
    {
        NSArray* returnData = [NSJSONSerialization JSONObjectWithData:[URLRequest responseData] options:NSJSONReadingAllowFragments error:nil][@"content"];
        
        for (int i = 0; i < returnData.count; i++)
        {
            NSDictionary* item = returnData[i];
            NSNumber* itemId = item[@"id"];
            
            if (itemId.longValue == actId.longValue)
            {
                isjoin = true;
                break;
            }
        }
    }

    
    if (!isjoin)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未参加该活动" message:@"只有加入活动后才能评论。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        return;
    }
    
    
    CreateActivityCommentViewController *createActivityCommentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateActivityCommentViewController"];
    [createActivityCommentVC SetActivity:activity];
    [createActivityCommentVC SetOwner:self];
    [self.navigationController pushViewController:createActivityCommentVC animated:YES];
}

- (void) OnCommentSuccess
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评论提交成功" message:@"您成功提交了一条评论。" delegate:self
                                              cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alertView show];
    
    [tableVC RefreshCommentList];
}

- (void)SetData:(NSDictionary *)actData
{
    localData = actData;
    localId = actData[@"id"];
}

- (void)UpdateProfileInfo
{
    canBookMark = true;
    canJoin = true;
    
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
            NSNumber* aid = item[@"id"];
            
            if (aid.longValue == activity.activityId.longValue)
            {
                canJoin = false;
                break;
            }
        }
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
            NSNumber* aid = item[@"id"];
            
            if (aid.longValue == activity.activityId.longValue)
            {
                canBookMark = false;
                break;
            }
        }
    }
    
    if (canJoin)
    {
        [_joinButton setImage:[UIImage imageNamed:@"bottom_sign_on"]];
    }
    else
    {
        [_joinButton setImage:[UIImage imageNamed:@"bottom_sign_done"]];
    }
    
    if (canBookMark)
    {
        [_bookmarkButton setImage:[UIImage imageNamed:@"bottom_like_on"]];
    }
    else
    {
        [_bookmarkButton setImage:[UIImage imageNamed:@"bottom_like_done"]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setUserInteractionEnabled:NO];
    [self.tabBarController.tabBar setHidden:YES];
    [self initNavBar];
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

- (IBAction)signUp:(id)sender {
    if (![UserManager IsInitSuccess])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户未登录" message:@"登陆后才能执行该操作。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        
        return;
    }
    
    if (!canJoin)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"已经参加了该活动。" delegate:Nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        
        return;
    }
    
    NSString* urlstr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    urlstr = [urlstr stringByAppendingFormat:@"%@/request/activity/%@", [[UserManager Instance]GetLocalUserId], activity.activityId];
    NSLog(@"%@",urlstr);
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"报名成功" message:@"成功提交报名申请。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
            [alertView show];
        }
    }
}

- (IBAction)bookMark:(id)sender {
    if (![UserManager IsInitSuccess])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户未登录" message:@"登陆后才能执行该操作。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        
        return;
    }
    
    if (!canBookMark)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"已经收藏了该活动。" delegate:Nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    NSString* urlstr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    urlstr = [urlstr stringByAppendingFormat:@"%@/activity/%@", [[UserManager Instance]GetLocalUserId], activity.activityId];
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"收藏成功" message:@"成功收藏至我的活动。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
            [alertView show];
            
            canBookMark = false;
            [_bookmarkButton setImage:[UIImage imageNamed:@"bottom_like_done"]];
        }
    }
}

- (IBAction)doShare:(id)sender {
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
@end
