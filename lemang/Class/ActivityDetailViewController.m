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
    
    ActivityDetailTableViewController *tableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailTableViewController"];
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
}

-(IBAction)goCommentPage:(id)sender{
    if (![UserManager IsInitSuccess])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户未登录" message:@"登陆后才能执行该操作。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
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
}

- (void)SetData:(NSDictionary *)actData
{
    localData = actData;
    localId = actData[@"id"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setUserInteractionEnabled:NO];
    [self.tabBarController.tabBar setHidden:YES];
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
    
    NSString* urlstr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    urlstr = [urlstr stringByAppendingFormat:@"%@/request/activity/%d", activity.activityId, [[UserManager Instance]GetLocalUserId]];
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
    
    
    NSString* urlstr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    urlstr = [urlstr stringByAppendingFormat:@"%d/activity/%@", [[UserManager Instance]GetLocalUserId], activity.activityId];
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
