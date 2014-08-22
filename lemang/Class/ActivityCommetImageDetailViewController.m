//
//  ActivityCommetImageDetailViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-19.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "ActivityCommetImageDetailViewController.h"

@interface ActivityCommetImageDetailViewController ()

@end

@implementation ActivityCommetImageDetailViewController

@synthesize img;

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
    UIButton *ImgButton  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UIImageView *Img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    Img.image = img;
    Img.contentMode =UIViewContentModeScaleAspectFit;
    [ImgButton addTarget:self action:@selector(Imgclick:) forControlEvents:UIControlEventTouchUpInside];
    
    [ImgButton addSubview:Img];
    [self.view addSubview:ImgButton];
    
    // Do any additional setup after loading the view.
}

-(void)Imgclick:(UIButton*)button
{
    [self dismissModalViewControllerAnimated:YES];
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
