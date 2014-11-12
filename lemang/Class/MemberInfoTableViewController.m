//
//  MemberInfoTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-16.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "MemberInfoTableViewController.h"
#import "Constants.h"

@interface MemberInfoTableViewController ()

@end

@implementation MemberInfoTableViewController

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
    
    UIBarButtonItem *addFriend = [[UIBarButtonItem alloc]init];
    addFriend.title = @"添加好友";
    [self.navigationItem setRightBarButtonItem:addFriend animated:YES];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self ClearDisplay];
    [self RefreshDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) ClearDisplay
{
    _departName.text = @"";
    _userNickName.text = @"";
    _phoneNumber.text = @"";
    _qqNumber.text = @"";
    _wechatId.text = @"";
    _schoolName.text = @"";
    _schoolNumber.text = @"";
    _userSign.text = @"";
    _userName.text = @"";
    
    [_userIcon setImage:[UserManager DefaultIcon]];
}

- (void) SetMemberId:(NSNumber*)userId
{
    memberId = userId;
}

- (void) RefreshDisplay
{
    if (memberId == nil)
        return;
    
    NSString* userUrlStr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    userUrlStr = [userUrlStr stringByAppendingFormat:@"%@", memberId];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:userUrlStr]];
    [request setUsername:@"admin"];    
    [request setPassword:@"admin"];
    
    [request startSynchronous];
    
    NSError* error = [request error];
    
    if (error)
    {
        NSLog(@"user error: %@",error);
        return;
    }
    
    int rcode = [request responseStatusCode];
    NSDictionary* userData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil];
    
    // Friend check
    bool isfriend = false;
    NSString* friendStr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    friendStr = [friendStr stringByAppendingFormat:@"%@/friend/q", [[UserManager Instance]GetLocalUserId]];
    
    ASIHTTPRequest* friendRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:friendStr]];
    [friendRequest startSynchronous];
    
    error = [friendRequest error];
    if (!error)
    {
        NSArray* respData = [NSJSONSerialization JSONObjectWithData:[friendRequest responseData] options:NSJSONReadingAllowFragments error:nil][@"content"];
        
        for (int i = 0; i < respData.count; i++)
        {
            NSDictionary* item = respData[i];
            Friend* fitem = [[Friend alloc]init];
            [fitem SetData:item];
            
            if ([fitem userId].longValue == memberId.longValue)
            {
                isfriend = true;
                break;
            }
        }
    }
    
    _userName.text = @"未认证用户";
    _schoolName.text = [UserManager filtStr:userData[@"university"][@"name"]];
    _departName.text =[UserManager filtStr:userData[@"department"][@"name"]];
    _userGender.text = @"未认证用户";
    
    NSDictionary* profileData = userData[@"profile"];
    
    if ([profileData isKindOfClass:[NSDictionary class]])
    {
        _userName.text = [UserManager filtStr:profileData[@"fullName"] : @"未认证用户"];
        _userNickName.text = [UserManager filtStr:profileData[@"nickName"] : @""];
        _userSign.text = [UserManager filtStr:profileData[@"signature"] : @""];
        _schoolNumber.text = [UserManager filtStr:profileData[@"code"] : @"未认证用户"];
        
        NSString* urlStr = profileData[@"iconUrl"];
        urlStr = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/resources%@", urlStr];
        [_userIcon LoadFromUrl:[NSURL URLWithString:urlStr]:[UserManager DefaultIcon]];
        
        
        NSString* genderStr = [UserManager filtStr:profileData[@"gender"] : @""];
        if ([genderStr isEqualToString:@"MALE"])
        {
            _userGender.text = @"男";
        }
        else if ([genderStr isEqualToString:@"FEMALE"])
        {
            _userGender.text = @"女";
        }
    }
    
    NSDictionary* contactData = userData[@"contacts"];
    
    if ([contactData isKindOfClass:[NSDictionary class]])
    {
        _phoneNumber.text = [UserManager filtStr:contactData[@"CELL"] : @"未绑定手机"];
        if (_phoneNumber.text.length == 0)
            _phoneNumber.text = @"未绑定手机";
        _qqNumber.text = [UserManager filtStr:contactData[@"QQ"] : @""];
        _wechatId.text = [UserManager filtStr:contactData[@"WECHAT"] : @""];
    }
    
    if (!isfriend)
    {
        _phoneNumber.text = @"仅好友可见";
        _qqNumber.text = @"仅好友可见";
        _wechatId.text = @"仅好友可见";
        _schoolNumber.text = @"仅好友可见";
        _userName.text = userData[@"name"];
        _userGender.text = @"仅好友可见";
    }

    [self CheckAdminButton];
}

- (void) CheckAdminButton
{
    bool isHide = true;
    
    if (fromActId || fromOrgId)
    {
        if (actOrgOwner.longValue == [[UserManager Instance]GetLocalUserId].longValue)
            isHide = false;
    }
    
    if (!isHide)
    {
        [_setAdmin setEnabled:true];
        
        if (isAdmin)
            _setAdmin.titleLabel.text = @"取消管理员";
        else
            _setAdmin.titleLabel.text = @"设为管理员";
    }
    else
    {
        [_setAdmin setEnabled:false];
    }
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

-(void)SetFromActivity:(NSNumber *)actId
{
    fromActId = actId;
}

-(void)SetFromGroup:(NSNumber *)gId
{
    fromOrgId = gId;
}

- (void)SetRefreshOwner:(id)target :(SEL)selecter
{
    owner = target;
    ownerRefresh = selecter;
}

- (IBAction)OnSetAdmin:(id)sender
{
    //
    [owner performSelector:ownerRefresh];
}

/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
