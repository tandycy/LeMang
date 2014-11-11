//
//  InitViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14/11/12.
//  Copyright (c) 2014年 gxcm. All rights reserved.
//

#import "InitViewController.h"
#import "Constants.h"

@interface InitViewController ()
{
    UIScrollView *scrollView;
}

@end

@implementation InitViewController

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
    [self initPage];
}


-(void)initPage
{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    //[scrollView setContentSize:CGSizeMake(320*4, 640)];
    scrollView.pagingEnabled=YES;
    scrollView.bounces=NO;
    [scrollView setDelegate:self];
    scrollView.showsHorizontalScrollIndicator=NO;
    [scrollView setContentSize:CGSizeMake(320*4, self.view.frame.size.height)];
    
    UIImageView *imageview0=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    UIImageView *imageview1=[[UIImageView alloc]initWithFrame:CGRectMake(320, 0, 320, self.view.frame.size.height)];
    UIImageView *imageview2=[[UIImageView alloc]initWithFrame:CGRectMake(640, 0, 320, self.view.frame.size.height)];
    UIImageView *imageview3=[[UIImageView alloc]initWithFrame:CGRectMake(960, 0, 320, self.view.frame.size.height)];
    
    NSLog(@"%f",self.view.frame.size.height);
    if (self.view.frame.size.height == 480.0f) {
        [imageview0 setImage:[UIImage imageNamed:@"guide0_ip4"]];
        [imageview1 setImage:[UIImage imageNamed:@"guide1_ip4"]];
        [imageview2 setImage:[UIImage imageNamed:@"guide2_ip4"]];
        [imageview3 setImage:[UIImage imageNamed:@"guide3_ip4"]];
    }
    else{
        [imageview0 setImage:[UIImage imageNamed:@"guide0"]];
        [imageview1 setImage:[UIImage imageNamed:@"guide1"]];
        [imageview2 setImage:[UIImage imageNamed:@"guide2"]];
        [imageview3 setImage:[UIImage imageNamed:@"guide3"]];
    }
    
    [scrollView addSubview:imageview0];
    [scrollView addSubview:imageview1];
    [scrollView addSubview:imageview2];
    [scrollView addSubview:imageview3];
    
    UIButton *jumpButton = [[UIButton alloc]initWithFrame:CGRectMake(1090, self.view.frame.size.height*2/3, 60, 25)];
    NSLog(@"%f",self.view.frame.size.height*2/3);
    [jumpButton setTitle:@"立刻体验" forState:UIControlStateNormal];
    [jumpButton.titleLabel setFont:[UIFont fontWithName:defaultFont size:11]];
    [jumpButton setTitleColor:defaultMainColor forState:UIControlStateNormal];
    [jumpButton addTarget:self action:@selector(jumpToMain:) forControlEvents:UIControlEventTouchUpInside];
     
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 25)];
    img.image = [UIImage imageNamed:@"tags_4"];
    //[img setTintColor:[UIColor whiteColor]];
    //jumpButton.titleLabel.text = @"立刻体验";
    [jumpButton addSubview:img];
    [scrollView addSubview:jumpButton];
    
    [self.view addSubview:scrollView];
}

-(IBAction)jumpToMain:(id)sender
{
    [self dismissModalViewControllerAnimated:NO];
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
