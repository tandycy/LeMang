//
//  HomeDetailViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14/11/1.
//  Copyright (c) 2014年 gxcm. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "Constants.h"
#import "UserManager.h"
#import "IconImageViewLoader.h"

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

- (void) SetNewsData:(NSDictionary *)data
{
    localData = data;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initScrollView];
}

- (NSString*)ParseData:(NSString*)input
{
    NSString* result = @"";
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* tempdate = [formatter dateFromString:input];
    [formatter setDateFormat:@"yyyy年mm月dd日 hh:mm"];
    result = [formatter stringFromDate:tempdate];
    
    return result;
}

-(void)initScrollView
{
    NSString* contentStr = localData[@"body"];
    NSString* title = localData[@"title"];
    NSString* dateStr = [self ParseData:localData[@"createdDate"]];
    NSDictionary* createdBy = localData[@"createdBy"];
    
    NSString* userName = createdBy[@"name"];
    NSDictionary* profileData = createdBy[@"profile"];
    if ([profileData isKindOfClass:[NSDictionary class]])
    {
        NSString* nick = [UserManager filtStr:profileData[@"nickName"]:@""];
        if (nick.length > 0)
            userName = nick;
    }
    
    NSString* iconStr = localData[@"iconUrl"];
    iconStr = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/resources%@", iconStr];
    NSURL* url = [NSURL URLWithString:iconStr];
    
    UIScrollView *sv  =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 60.0,self.view.frame.size.width, self.view.frame.size.height)];
    sv.pagingEnabled = YES;
    sv.showsVerticalScrollIndicator = NO;
    sv.showsHorizontalScrollIndicator = NO;
    sv.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UILabel *newsTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width, 15)];
    newsTitle.text = title;
    newsTitle.font = [UIFont fontWithName:defaultBoldFont size:15];
    newsTitle.textColor = defaultTitleGray96;
    [sv addSubview:newsTitle];
    
    UILabel *newsAuthor = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, self.view.frame.size.width, 15)];
    NSString *authorName = @"作者：";
    authorName = [authorName stringByAppendingString:userName];
    newsAuthor.text = authorName;
    newsAuthor.font = [UIFont fontWithName:defaultBoldFont size:11];
    newsAuthor.textColor = defaultDarkGray137;
    [sv addSubview:newsAuthor];
    
    UILabel *newsDate = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, self.view.frame.size.width, 15)];
    NSString *newsDateString = @"发布日期：";
    newsDateString = [newsDateString stringByAppendingString:dateStr];
    newsDate.text = newsDateString;
    newsDate.font = [UIFont fontWithName:defaultBoldFont size:11];
    newsDate.textColor = defaultDarkGray137;
    [sv addSubview:newsDate];
    
    IconImageViewLoader *newsImgView = [[IconImageViewLoader alloc]initWithFrame:CGRectMake(10, 50, 300, 160)];
    [sv addSubview:newsImgView];
    [newsImgView LoadFromUrl:url :[UserManager DefaultIcon]];
    
    int detailLabelPos;
    if (newsImgView.image) {
        detailLabelPos = 220;
    }
    else detailLabelPos = 50;
    
    CGSize labelSize = {0, 0};
    labelSize = [contentStr sizeWithFont:[UIFont fontWithName:defaultFont size:11]
                       constrainedToSize:CGSizeMake(300.0, 5000)
                           lineBreakMode:UILineBreakModeWordWrap];
    
    UILabel *newsDetail = [[UILabel alloc]initWithFrame:CGRectMake(10, detailLabelPos, 300, labelSize.height)];
    //newsDetail.text = contentStr;
    newsDetail.numberOfLines = 0;
    newsDetail.lineBreakMode = UILineBreakModeWordWrap;
    newsDetail.font = [UIFont fontWithName:defaultBoldFont size:11];
    newsDetail.textColor = defaultDarkGray137;
    //调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentStr length])];
    
    newsDetail.attributedText = attributedString;
    [sv addSubview:newsDetail];
    [newsDetail sizeToFit];

    CGSize newSize = CGSizeMake(self.view.frame.size.width,labelSize.height+(labelSize.height/11*5)+detailLabelPos+80);
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
