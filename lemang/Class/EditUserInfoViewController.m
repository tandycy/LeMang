//
//  EditUserInfoViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-17.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "Constants.h"

@interface EditUserInfoViewController ()

@end

@implementation EditUserInfoViewController

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

- (void) SetEditProfile : (NSString*)itemKey  userId:(NSNumber*)userId  defaultValue:(NSString*)defaultValue
{
    userKey = itemKey;
    uid = userId;
    defaultV = defaultValue;
    itemType = 0;
}

- (void) SetEditContact : (NSString*)itemKey  userId:(NSNumber*)userId  defaultValue:(NSString*)defaultValue
{
    userKey = itemKey;
    uid = userId;
    defaultV = defaultValue;
    itemType = 1;
}

- (void) SetOwner:(UserInfoTableViewController *)_owner
{
    owner = _owner;
}

- (void) SetOriginData:(NSDictionary *)data
{
    originData = data;
}

-(void)initView
{
    // init view with white bg
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // init edit text view
    UILabel *editTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 320, 15)];
    editTitle.text = @"请输入您想要修改的内容...";
    editTitle.font = [UIFont fontWithName:defaultBoldFont size:15];
    [self.view addSubview:editTitle];
    
    self.editText = [[UITextView alloc]initWithFrame:CGRectMake(20, 120, 280, 100)];
    self.editText.backgroundColor = defaultLightGray243;
    self.editText.font = [UIFont fontWithName:defaultFont size:15];
    [self.view addSubview:self.editText];
    
    //init right barbutton item
    UIBarButtonItem *finish = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishEdit:)];
    self.navigationItem.rightBarButtonItem = finish;
    
    [self.editText setText:defaultV];
}

-(IBAction)finishEdit:(id)sender{
    
    NSString* userUrlStr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    userUrlStr = [userUrlStr stringByAppendingFormat:@"%@", uid];

    if (itemType == 0)
    {
        userUrlStr = [userUrlStr stringByAppendingString:@"/profile"];
        
        if (![originData isKindOfClass:[NSDictionary class]])
        {
            originData = [[NSMutableDictionary alloc]init];
        }
    }
    else if (itemType == 1)
    {
        userUrlStr = [userUrlStr stringByAppendingString:@"/contact"];
        
        if (![originData isKindOfClass:[NSDictionary class]] || originData.count == 0)
        {
            originData = [[NSMutableDictionary alloc]init];
            [originData setValue:@"" forKey:@"CELL"];
            [originData setValue:@"" forKey:@"QQ"];
            [originData setValue:@"" forKey:@"WECHAT"];
        }
    }
    
    NSMutableDictionary* editData = [NSMutableDictionary dictionaryWithDictionary:originData];
    ASIHTTPRequest *updateRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:userUrlStr]];
    
    NSString* valueString = _editText.text;
    [editData setValue:valueString forKey:userKey];
    
    NSData* postData = [NSJSONSerialization dataWithJSONObject:editData options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    postData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    [updateRequest addRequestHeader:@"Content-Type" value:@"application/json;charset=UTF-8"];
    [updateRequest appendPostData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [updateRequest setRequestMethod:@"PUT"];
    
    [updateRequest startSynchronous];
    
    NSError *error = [updateRequest error];
    
    if (!error)
    {
        int returnCode = [updateRequest responseStatusCode];
        
        if (returnCode == 200)
        {
            [owner UpdateContentDisplay];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSLog(@"edit info: %d - %@", [updateRequest responseStatusCode], [updateRequest responseString]);
            // TODO
        }
    }
    else
    {
        // TODO
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

- (void)viewWillAppear:(BOOL)animated
{
    [self initNavBar];
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

@end
