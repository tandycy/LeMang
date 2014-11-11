//
//  QuestionViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14/11/12.
//  Copyright (c) 2014年 gxcm. All rights reserved.
//

#import "QuestionViewController.h"
#import "Constants.h"

@interface QuestionViewController ()

@end

@implementation QuestionViewController

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
    [self initView];
}

-(void)initView
{
    NSString *content = @"基本介绍：\n1：什么是乐芒（校园互动平台）？\n乐芒（校园互动平台）是一款校园互动工具，你不仅可以在里面看新闻资讯，还可以参加校园社团组织，还可以参加校园活动。是你校园生活的必必备智器。\n2：什么是社群？\n是指在某些边界线、地区或领域内发生作用的一切社会关系。它可以指实际的地理区域或是在某区域内发生的社会关系，或指存在于较抽象的、思想上的关系，除此之外。Worsley(1987)曾提出社群的广泛涵义：可被解释为地区性的社区；用来表示一个有相互关系的网络。校园就是一个大的社群。音乐社也是一个小的社群。\n3：什么是活动？\n活动是由共同目的联合起来并完成一定社会职能的动作的总和。乐芒（校园互动平台）的活动包含的很广泛，班级会议、社团活动、院系组织的活动、商家赞助的节目等等。\n\n\n功能介绍：\n1:怎么使用乐芒（校园互动平台）？\n乐芒app安装成功后，点击图标，进入乐芒，你可以看全部的资讯，活动，社群组织等等，如果你想参与其中或者可好的体验乐芒，在注册登录乐芒，你会发现很多惊喜。\n2：乐芒注册为什么需要手机号？\n利用手机号注册不但方便快捷，而且参与活动的也需要你的手机号。还有一点是为了杜绝不法分子乱发消息，扰乱正常秩序。并且你不需要发短信，只需把接收到的验证信息填上就可以啦。\n3：怎么参加社群、活动？\n请登录乐芒app，进入社群或者活动选项，点击你喜欢的社群组织或者活动，进入详情页面，你可以在最下面看到报名的按钮，点击报名，就可以向社群或者活动的管理员发一个请求加入的消息。如果他们批准你的加入，那你恭喜你报名成功。\n4：我可以创建社群和活动吗？\n可以。不过你需要先申请实名认证。我们为了防止不法分子乱发消息，给乐芒一个安全的环境。实名认证需要那些东西，请参考申请实名认证页面。实名认证成功后，你可以通过社群和活动页面的右上角点击“创建”按钮，来创建你的社群和活动。\n\n功能反馈：\n乐芒开发团队，非常感谢你反馈好的建议和产品bug。你可以通过产品“用户”-“设置”-“问题反馈”。";
    
    
    UIScrollView *sv  =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 60.0,self.view.frame.size.width, self.view.frame.size.height)];
    sv.pagingEnabled = YES;
    sv.showsVerticalScrollIndicator = NO;
    sv.showsHorizontalScrollIndicator = NO;
    sv.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGSize labelSize = {0, 0};
    labelSize = [content sizeWithFont:[UIFont fontWithName:defaultFont size:11]
                    constrainedToSize:CGSizeMake(300.0, 5000)
                        lineBreakMode:UILineBreakModeWordWrap];
    
    UILabel *newsDetail = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, labelSize.height)];
    //newsDetail.text = contentStr;
    newsDetail.numberOfLines = 0;
    newsDetail.lineBreakMode = UILineBreakModeWordWrap;
    newsDetail.font = [UIFont fontWithName:defaultBoldFont size:11];
    newsDetail.textColor = defaultDarkGray137;
    //调整行间距
    content = [content stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    
    newsDetail.attributedText = attributedString;
    [sv addSubview:newsDetail];
    [newsDetail sizeToFit];
    
    CGSize newSize = CGSizeMake(self.view.frame.size.width,labelSize.height+(labelSize.height/11*5)+80);
    [sv setContentSize:newSize];
    
    [self.view addSubview: sv];
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

@end
