//
//  UserTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "UserTableViewController.h"
#import "MyMessageTableViewController.h"
#import "Constants.h"

@interface UserTableViewController ()
{
    //UIButton *loginButton;
}

@end

@implementation UserTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // loginButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    // loginButton.backgroundColor = [UIColor blueColor];
    //loginButton.titleLabel.text = @"login!";
    
    [self.messageButton addTarget:self action:@selector(msgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginButton addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self clearUserDataDisplay];
    [UserManager Instance].loginDelegate = self;
    [[UserManager Instance] LogInCheck];
    [SchoolManager InitSchoolList] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)msgBtnClick:(id)sender
{
    MyMessageTableViewController *MyMsgTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyMessageTableViewController"];
    [self.navigationController pushViewController:MyMsgTVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController.tabBar setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIFont fontWithName:defaultBoldFont size:20.0], UITextAttributeFont,
                                                                     nil]];
    [self.navigationController.navigationBar setBarTintColor:defaultMainColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self userLoginState:[UserManager IsInitSuccess]];
    
    if ([UserManager IsInitSuccess] && [UserManager IsDirty])
    {
        [self refreshUserData];
    }
}


- (void) UserLoginContact:(int)returnCode
{
    if ([UserManager IsInitSuccess])
    {
        [self refreshUserData];
        NSLog(@"refresh");
    }
    else
    {
        // Login failed
        [self popOverDelay];
    }
}

-(void)userLoginState:(BOOL)state
{
    if (state) {
        [self.userSchoolText setHidden:false];
        [self.userDescText setHidden:false];
        [self.userGenderIcon setHidden:false];
        [self.rankButton setHidden:false];
        [self.verifyButton setHidden:false];
        [self.mobilePhoneButton setHidden:false];
        [self.loginButton setImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
        [self.accCell setUserInteractionEnabled:true];
        [self.myActCell setUserInteractionEnabled:true];
        [self.myFriendsCell setUserInteractionEnabled:true];
        [self.myOrgCell setUserInteractionEnabled:true];
    }
    else{
        [self.userSchoolText setHidden:true];
        [self.userDescText setHidden:true];
        [self.userGenderIcon setHidden:true];
        [self.rankButton setHidden:true];
        [self.verifyButton setHidden:true];
        [self.mobilePhoneButton setHidden:true];
        [self.loginButton setImage:[UIImage imageNamed:@"login"]  forState:UIControlStateNormal];
        [self.accCell setUserInteractionEnabled:false];
        [self.myActCell setUserInteractionEnabled:false];
        [self.myFriendsCell setUserInteractionEnabled:false];
        [self.myOrgCell setUserInteractionEnabled:false];
    }
}

-(IBAction)loginClick:(id)sender{
    if ([UserManager IsInitSuccess])
    {
        [[UserManager Instance] ClearLocalUserData];
        [self clearUserDataDisplay];
        [self userLoginState:[UserManager IsInitSuccess]];
    }
    else
    {
        // Login failed
        [self popUpULVC];
    }
}

- (void)clearUserDataDisplay
{
    _userNameText.text = @"未登录";
    _userSchoolText.text = @"";
    _userDescText.text = @"";
    
    [_userIconImageLoader setImage:[UserManager DefaultIcon]];
    [_userGenderIcon setHidden:true];
    
    [self userLoginState:false];
}

// insert popOverDelay into login failed solution.
// Example: [self popOverDelay];

- (void)popUpULVC
{
    if (ULVC == Nil)
    {
        //ULVC = [[UserLoginViewController alloc]init];
        ULVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserLoginViewController"];
        ULVC.owner = self;
    }
    [self presentModalViewController:ULVC animated:YES];
}

- (void)popOverDelay
{
    [self performSelector:@selector(popUpULVC) withObject:@"delay 0.1s" afterDelay:0.1];
}

- (void)refreshUserData
{
    if (![UserManager IsInitSuccess])
    {
        [self clearUserDataDisplay];
        return;
    }
    
    [UserManager SetClear];
    
    [self userLoginState:true];
    
    userData = [UserManager LocalUserData];
    //[NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingAllowFragments error:nil];
    
    _userNameText.text = [UserManager filtStr:userData[@"name"]];
    _userDescText.text = @"";
    _userSchoolText.text = [UserManager filtStr:userData[@"university"][@"name"]];
    NSDictionary* profileData = userData[@"profile"];
    
    if ([profileData isKindOfClass:[NSDictionary class]])
    {
        _userDescText.text = [UserManager filtStr:profileData[@"signature"] : @""];
        
        NSString* nick = [UserManager filtStr:profileData[@"nickName"] : @""];
        if (nick.length > 0)
            _userNameText.text = nick;
        
        NSString* urlStr = profileData[@"iconUrl"];
        urlStr = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/resources%@", urlStr];
        [_userIconImageLoader LoadFromUrl:[NSURL URLWithString:urlStr]:[UserManager DefaultIcon]];
        
        NSString* genderStr = [UserManager filtStr:profileData[@"gender"] : @""];
        if ([genderStr isEqualToString:@"MALE"])
        {
            [_userGenderIcon setHidden:false];
            [_userGenderIcon setImage:[UIImage imageNamed:@"gender_male"]];
        }
        else if ([genderStr isEqualToString:@"FEMALE"])
        {
            [_userGenderIcon setHidden:false];
            [_userGenderIcon setImage:[UIImage imageNamed:@"gender_feale"]];
        }
        
    }
    else
    {
        
    }
}

#pragma mark - Table view data source

 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 #warning Potentially incomplete method implementation.
 // Return the number of sections.
 return 1;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 #warning Incomplete method implementation.
 // Return the number of rows in the section.
 return 4;
 }
 /*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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
