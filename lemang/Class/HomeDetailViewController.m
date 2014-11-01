//
//  HomeDetailViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14/11/1.
//  Copyright (c) 2014年 gxcm. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "Constants.h"

@interface HomeDetailViewController ()

@end

@implementation HomeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initScrollView];
}


-(void)initScrollView
{
    NSString* contentStr = @"千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去千万额前往俄企鹅请问去";
    
    CGSize labelSize = {0, 0};
    labelSize = [contentStr sizeWithFont:[UIFont fontWithName:defaultFont size:11]
                       constrainedToSize:CGSizeMake(300.0, 5000)
                           lineBreakMode:UILineBreakModeWordWrap];
    
    UIScrollView *sv  =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 60.0,self.view.frame.size.width, self.view.frame.size.height)];
    sv.pagingEnabled = YES;
    sv.showsVerticalScrollIndicator = NO;
    sv.showsHorizontalScrollIndicator = NO;
    sv.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UILabel *newsTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width, 15)];
    newsTitle.text = @"复旦大学宣讲会";
    newsTitle.font = [UIFont fontWithName:defaultBoldFont size:15];
    newsTitle.textColor = defaultTitleGray96;
    [sv addSubview:newsTitle];
    
    UILabel *newsAuthor = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, self.view.frame.size.width, 15)];
    NSString *authorName = @"作者：";
    authorName = [authorName stringByAppendingString:@"王尼玛"];
    newsAuthor.text = authorName;
    newsAuthor.font = [UIFont fontWithName:defaultBoldFont size:11];
    newsAuthor.textColor = defaultDarkGray137;
    [sv addSubview:newsAuthor];
    
    UILabel *newsDate = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, self.view.frame.size.width, 15)];
    NSString *newsDateString = @"发布日期：";
    newsDateString = [newsDateString stringByAppendingString:@"2014年11月11日 11：11"];
    newsDate.text = newsDateString;
    newsDate.font = [UIFont fontWithName:defaultBoldFont size:11];
    newsDate.textColor = defaultDarkGray137;
    [sv addSubview:newsDate];
    
    UIImageView *newsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 50, 300, 160)];
    newsImgView.image = [UIImage imageNamed:@"11.jpg"];
    [sv addSubview:newsImgView];
    
    int detailLabelPos;
    if (newsImgView.image) {
        detailLabelPos = 220;
    }
    else detailLabelPos = 50;
    
    UILabel *newsDetail = [[UILabel alloc]initWithFrame:CGRectMake(10, detailLabelPos, 300, labelSize.height)];
    newsDetail.text = contentStr;
    newsDetail.numberOfLines = 0;
    newsDetail.lineBreakMode = UILineBreakModeWordWrap;
    newsDetail.font = [UIFont fontWithName:defaultBoldFont size:11];
    newsDetail.textColor = defaultDarkGray137;
    [sv addSubview:newsDetail];

    CGSize newSize = CGSizeMake(self.view.frame.size.width,labelSize.height+detailLabelPos+80);
    [sv setContentSize:newSize];
    
    [self.view addSubview: sv];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
