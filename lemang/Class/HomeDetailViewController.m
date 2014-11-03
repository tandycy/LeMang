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
    NSString* contentStr = @"  一百多年来，交大人用知识和智慧创造累累硕果，谱写了近现代史上的诸多“第一”。这是人才培养的智慧、科学研究的智慧、服务社会的智慧、为国争光的智慧。新闻网特推出“交大智慧”专栏，聚焦交大人的智慧之光，展现交大人为国家发展和社会进步作出的重大贡献。\n  “胃不和而卧不安”，脾胃为后天之本，气血之源，是维持人体正常活动的营养加工厂和运输的脏器。维持着人体的饮食消化，营养吸收和废物的排出，保证机体的正常运作。把人体比作汽车，胃就是汽车发动机，提供着身体需要的能量。脾胃有病还会造成其他脏腑的疾病与症状。\n  在世界范围内，胃癌是第四大常见癌症类型，并且是引起人类死亡第二位的癌症类型，在亚洲地区更为严重。生活在“舌尖上的中国”，因为其特有的饮食文化、环境等诸多原因，无论是胃癌发病的绝对数和相对数都比较高。据统计，我国胃癌的发病率占到全世界的42%左右，每年发病40万例，死亡率超过三分之二。饮食不科学，不规律，吸烟酗酒，暴饮暴食，冷热刺激，偏食，营养不均衡等因素，致使我国年轻人的发病率也逐渐升高。早期胃癌大多无症状或仅有轻微症状，当症状明显时，病变已属晚期，对人类的生存健康构成了极大的威胁。因此，如何找到好的胃癌诊断指标和治疗靶点，具有着重大的医学价值。\n最近，上海交通大学Med-X-仁济医院干细胞研究中心的高维强教授研究组在胃癌发生机制中取得了突破性进展。他们发现TRIM蛋白家族的TRIM59蛋白在胃癌中表达水平很高，并且这一表达与胃癌病人的疾病进展和生存率密切相关。所以，TRIM59蛋白可能成为新的胃癌预后标志物，并且具有较高的作为潜在治疗靶点的价值。以周志诚（博士研究生）作为第一作者，朱鹤（Helen He Zhu）副研究员与高维强教授作为共同通讯作者的这一研究论文日前已经发表于Gastroenterology (影响因子为13.926)。\nTRIM59在胃癌中的高表达与病人疾病预后密切相关\nTRIM59属于TRIM家族蛋白，家族成员高度保守，通常包含三种保守结构域，包括RING、B-box和coiled-coil domain，总称RBCC结构域或TRIM结构域（Tripartite motif）。家族成员参与许多重要的生物学功能如免疫调控，抗病毒反应，转录调控，神经发育，细胞增殖，癌症，调控关键蛋白稳定性等。已有报导发现，前列腺特异表达TRIM59的转基因小鼠会有前列腺癌的自发发生。TRIM59可以调控NF-KB的表达从而参与调控免疫应答；介导巨噬细胞的细胞连接，参与免疫杀伤反应；TRIM59在多种肿瘤中有不同程度的高表达态势。\n高维强教授研究组通过运用多种生物学手段，对大量数据库以及临床样本进行分析发现，TRIM59在胃癌组织中呈高水平表达态势，并且TRIM59的表达水平高低与病人临床症状预后的好坏有很强的相关性：病人组织中TRIM59表达水平越高，病人的恶性程度越高。他们的体外研究还发现，减少TRIM59在癌细胞中的表达，可以减少癌细胞的增殖和耐受性能，同时可以降低细胞的恶性程度。\n他们相信：“他们的研究发现了一个可用来诊断治疗胃癌的崭新标志物，根据标志物的表达水平分析病人的疾病进展情况，据此对病人在外科手术的基础上进行针对靶标分子进行辅助治疗，更好的改善病人的生活质量。”\n\n“釜底抽薪”致肿瘤\np53是一种明星抑癌基因基因，是机体细胞的“安全卫士”。在G1期检查DNA损伤点，监视基因组的完整性。如果细胞发生损伤，p53可以启动修复过程使细胞进行自我修复；修复不了，p53便启动凋亡程序使受损细胞凋亡。如果这一“安全卫士”垮掉，细胞增殖分裂会失去控制，细胞便会癌变。TRIM59是通过对“安全卫士”的“掩杀”，促进p53的泛素化降解，致使“保卫”功能丧失不能行使监控机制，从而诱发了肿瘤的发生。\n高维强教授研究组通过实验首次发现，在病人样本中TRIM59的表达水平，跟野生型p53的表达是呈现负相关状态：TRIM59的表达水平升高使p53的稳定性下降。 TRIM59是通过调控p53的泛素化降解，使抑癌基因p53的稳定性下降，从而不能对机体细胞的病变进行监控修复，致使肿瘤发生。\n此发现有望改善胃癌治疗方法\n胃癌在全世界范围是高发恶性肿瘤，在我国更是如此。胃癌的特点是早期胃癌患者没有明显的症状，一旦发现已属中晚期。目前，还没有很好的早期诊断指标，胃癌的诊断主要依靠胃镜、X线、超声等几种手段，临床上对胃癌的治疗主要是通过外科手术切除。有迫切需要找到早期诊断胃癌的有效方法，以根据标志物的表达水平分析预测病人的预后情况，据此对病人在外科手术的基础上针对靶标分子进行辅助治疗。\n本研究提示：TRIM59可以作为诊断胃癌的靶标分子。医生有可能通过分析病人TRIM59的表达水平分析病人疾病的发展状况，有效地提供针对性的外科手术以外的辅助手段。本研究也提示：通过开发特异的药物以防止TRIM59的过高表达，可能也是一个新的治疗胃癌的方法。\n此外，以王嘉（博士研究生）作为第一作者，高维强教授作为通讯作者近期发表于Nature子刊 Nature Communications (IF: 10.742)的文章通过分析前列腺上皮细胞特殊的分裂模式，在前列腺发育和肿瘤形成的细胞起源研究中取得了突破性进展，对阐明前列腺上皮细胞谱系发生及对预防和治疗前列腺癌具有重要意义。高维强教授课题组最近发表于Journal of Pathology （影响因子为7.33）的论文报道了他们关于“Ska1促进中心体增殖及前列腺癌发生发展”的发现。高教授发表于Stem Cell Reports (影响因子预计为8分左右)的论文报道了他们关于“神经祖细胞和血管内皮祖细胞共移植能够协同性地促进脑卒中损伤修复”的发现。这些发现都为癌症、脑卒中等重大疾病的治疗提供了新思路。";
    
    
    
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
