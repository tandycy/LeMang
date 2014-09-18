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
    tableVC.activity = activity;
    
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
    
    NSString* urlstr = @"http://e.taoware.com:8080/quickstart/api/v1/activity/";
    urlstr = [urlstr stringByAppendingFormat:@"%@/user/%d", activity.activityId, [[UserManager Instance]GetLocalUserId]];
    NSURL* url = [NSURL URLWithString:urlstr];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    
    [request setUsername:[UserManager UserName]];
    [request setPassword:[UserManager UserPW]];
    
    //    [request setValue:@"application/json;charset=UTF-8" forKey: @"Content-Type"];
    [request addRequestHeader:@"Content-Type" value:@"application/json;charset=UTF-8"];
    //[request addRequestHeader:@"Content-Length" value:dataLength];
    
    [request setRequestMethod:@"POST"];
    //[request appendPostData:postData];
    
    [request startSynchronous];
    
    NSError* error = [request error];
    if (!error)
    {
        // TODO
        int resCode = [request responseStatusCode];
        NSLog(@"regist %d",resCode);
    }
}

- (IBAction)bookMark:(id)sender {
    if (![UserManager IsInitSuccess])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户未登录" message:@"登陆后才能执行该操作。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        
        return;
    }
}

- (IBAction)doShare:(id)sender {
}
@end
