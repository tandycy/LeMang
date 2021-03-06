//
//  ActivityMemberTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-12.
//  Copyright (c) 2014年 university media. All rights reserved.
//


#import "ActivityMemberTableViewController.h"
#import "UITableGridViewCell.h"
#import "UIImageButton.h"
#import "MemberInfoTableViewController.h"
#define kImageWidth  50 //UITableViewCell里面图片的宽度
#define kImageHeight  50 //UITableViewCell里面图片的高度
@interface ActivityMemberTableViewController()

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)NSMutableArray *titleArray;
@end

@implementation ActivityMemberTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
     self.title = @"成员列表";
     self.view.backgroundColor = [UIColor whiteColor];
    //UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //[self.navigationItem setHidesBackButton:YES];
    
    _titleArray = [[NSMutableArray alloc] initWithObjects:@"拥有者", @"管理员", @"成员", nil];
    
    self.image = [UserManager DefaultIcon];
    
//    [self cutCenterImage:self.image size:];
    
    CGSize mSize = [[UIScreen mainScreen] bounds].size;
    CGFloat screenWidth = mSize.width;
    CGFloat screenHeight = mSize.height;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, screenWidth, screenHeight-200) style:UITableViewStylePlain];
    //[self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    NSLog(@"%f",self.tableView.frame.size.height);
    NSLog(@"%f",self.tableView.frame.size.width);
}

- (void) FullRefresh
{
    if (!localData)
        return;
    
    if (isActivity)
        [self RefreshActivity];
    else
        [self RefreshOrganization];
    
    [self.tableView reloadData];
}

- (void) SetActivity:(NSDictionary *)actData
{
    isActivity = true;
    
    adminList = [[NSMutableArray alloc]init];
    memberList = [[NSMutableArray alloc]init];
    guestList = [[NSMutableArray alloc]init];
    
    localData = actData;
    
    [self RefreshActivity];
}

- (void) RefreshActivity
{
    NSNumber* actId = localData[@"id"];
    
    NSString* memberUrlStr = @"http://e.taoware.com:8080/quickstart/api/v1/activity/";
    memberUrlStr = [memberUrlStr stringByAppendingFormat:@"%@/user", actId];
    ASIHTTPRequest* memberRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:memberUrlStr]];
    [memberRequest startSynchronous];
    
    [adminList removeAllObjects];
    [memberList removeAllObjects];
    [guestList removeAllObjects];
    
    NSError* error = [memberRequest error];
    
    if (error)
    {
        NSLog(@"Get activity member error: %d", error.code);
        return;
    }
    
    NSArray* members = [NSJSONSerialization JSONObjectWithData:[memberRequest responseData] options:NSJSONReadingAllowFragments error:nil][@"content"];
    
    if (![members isKindOfClass:[NSArray class]])
        members = [NSArray alloc];
    
    for (int i = 0; i < members.count; i++)
    {
        NSDictionary* member = members[i];

        // TODO: approve check
        
        NSString* rule = member[@"role"];
        
        if ([rule isEqualToString:@"Guest"])
        {
            NSDictionary* userData = member[@"user"];
            [memberList addObject:userData];
        }
        else if ([rule isEqualToString:@"User"])
        {
            NSDictionary* userData = member[@"user"];
            [memberList addObject:userData];
        }
        else if ([rule isEqualToString:@"Administrator"])
        {
            NSDictionary* userData = member[@"user"];
            [adminList addObject:userData];
        }
        else if ([rule isEqualToString:@"Creator"])
        {
            // ??
        }
        else
        {
            NSLog(@"Unknow user role: %@", rule);
        }
    }
}

- (void) SetOrganization:(NSDictionary *)orgData
{
    isActivity = false;
    
    adminList = [[NSMutableArray alloc]init];
    memberList = [[NSMutableArray alloc]init];
    guestList = [[NSMutableArray alloc]init];
    
    localData = orgData;
    
    [self RefreshOrganization];
}

- (void) RefreshOrganization
{
    NSNumber* actId = localData[@"id"];
    
    NSString* memberUrlStr = @"http://e.taoware.com:8080/quickstart/api/v1/association/";
    memberUrlStr = [memberUrlStr stringByAppendingFormat:@"%@/user", actId];
    ASIHTTPRequest* memberRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:memberUrlStr]];
    [memberRequest startSynchronous];
    
    [adminList removeAllObjects];
    [memberList removeAllObjects];
    [guestList removeAllObjects];
    
    NSError* error = [memberRequest error];
    
    if (error)
    {
        NSLog(@"Get group member error: %d", error.code);
        return;
    }
    
    NSArray* members = [NSJSONSerialization JSONObjectWithData:[memberRequest responseData] options:NSJSONReadingAllowFragments error:nil][@"content"];
    
    if (![members isKindOfClass:[NSArray class]])
        members = [NSArray alloc];
    
    for (int i = 0; i < members.count; i++)
    {
        NSDictionary* member = members[i];
        
        // TODO: approve check
        
        NSString* rule = member[@"role"];
        
        if ([rule isEqualToString:@"Guest"])
        {
           //NSDictionary* userData = member[@"user"];
            //[memberList addObject:userData];
        }
        else if ([rule isEqualToString:@"User"])
        {
            NSDictionary* userData = member[@"user"];
            [memberList addObject:userData];
        }
        else if ([rule isEqualToString:@"Administrator"])
        {
            NSDictionary* userData = member[@"user"];
            [adminList addObject:userData];
        }
        else if ([rule isEqualToString:@"Creator"])
        {
            // ??
        }
        else
        {
            NSLog(@"Unknow user role: %@", rule);
        }
    }
}

#pragma mark UITable datasource and delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        if (memberList == nil)
            return 1;
        
        int members = memberList.count;
        
        if (members == 0)
            return 1;
        
        int rows = members / 4;
        
        return rows + 1;
    };
    
    return 0;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UITableGridViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  //  NSUInteger row = [indexPath row];
        
    NSUInteger section = [indexPath section];
    
    if (section == 0) {
        cell = [[UITableGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        NSDictionary* creator = localData[@"createdBy"];
        
        NSDictionary* profile = creator[@"profile"];
        NSDictionary* creatorSchoolData = creator[@"university"];
        NSDictionary* creatorDepartData = creator[@"department"];
        
        UIImageView *cbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"member_back.png"]];
        cell.backgroundView = cbg;
        //  cell.selectedBackgroundView = [[UIView alloc]init];
        
        IconImageViewLoader *creatorImg = [[IconImageViewLoader alloc]initWithImage:self.image];
        creatorImg.bounds = CGRectMake(0, 0, 50, 50);
        creatorImg.center = CGPointMake(25, 25);
        NSString* creatorNameStr = creator[@"name"];
        
        if ([profile isKindOfClass:[NSDictionary class]])
        {
            NSString* iconStr = profile[@"iconUrl"];
            iconStr = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/resources%@", iconStr];
            
            NSURL* creatorIconUrl = [NSURL URLWithString:iconStr];
            [creatorImg LoadFromUrl:creatorIconUrl :[UserManager DefaultIcon]];

                NSString* nickname = [UserManager filtStr:profile[@"nickName"] : @""];
                if (nickname.length > 0)
                    creatorNameStr = nickname;
        }
        
        UILabel *creatorHead = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 50, 50)];
        UILabel *creatorName = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 200, 13)];
        UILabel *creatorSchool = [[UILabel alloc]initWithFrame:CGRectMake(100, 28, 200, 13)];
        UILabel *creatorColleage = [[UILabel alloc]initWithFrame:CGRectMake(100, 47, 200, 13)];
        
        creatorName.text = creatorNameStr;
        creatorSchool.text = creatorSchoolData[@"name"];
        creatorColleage.text = creatorDepartData[@"name"];
        
        creatorName.font = [UIFont fontWithName:defaultBoldFont size:13];
        creatorName.textColor = defaultMainColor;   
        creatorSchool.font = [UIFont fontWithName:defaultBoldFont size:13];
        creatorSchool.textColor = defaultTitleGray96;
        creatorColleage.font = [UIFont fontWithName:defaultBoldFont size:13];
        creatorColleage.textColor = defaultTitleGray96;
        
        [creatorHead addSubview:creatorImg];
        [cell addSubview:creatorHead];
        [cell addSubview:creatorName];
        [cell addSubview:creatorSchool];
        [cell addSubview:creatorColleage];
        
    }
    else if (section == 1)
    {
        UILabel *noAdmin = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 88)];
        noAdmin.font = [UIFont fontWithName:defaultBoldFont size:13];
        noAdmin.textColor = defaultTitleGray96;
        noAdmin.textAlignment = UITextAlignmentCenter;
        noAdmin.text = @"暂无活动管理员";
        
        if (adminList != nil && adminList.count > 0)
        {
            cell = [[UITableGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            int iconNumber = 4;
            if (iconNumber > adminList.count)
                iconNumber = adminList.count;
            
            for (int i = 0; i < iconNumber; i++)
            {
                int memberIndex = i;
                NSDictionary* member = adminList[memberIndex];
                
                IconImageButtonLoader *button = [IconImageButtonLoader buttonWithType:UIButtonTypeCustom];
                
                UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 50, 20)];
                name.text = member[@"name"];
                name.font = [UIFont fontWithName:defaultFont size:11];
                name.textAlignment = UITextAlignmentCenter;
                name.textColor = defaultMainColor;
                
                
                NSDictionary* profileData = member[@"profile"];
                [button setBackgroundImage:self.image forState:UIControlStateNormal];
                if ([profileData isKindOfClass:[NSDictionary class]])
                {
                    NSString* iconStr = [profileData valueForKey:@"iconUrl"];
                    iconStr = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/resources%@", iconStr];
                    NSURL* creatorIconUrl = [NSURL URLWithString:iconStr];
                    [button LoadFromUrl:creatorIconUrl :self.image];
                }
                
                button.bounds = CGRectMake(0, 0, kImageWidth, kImageHeight);
                if (i==0) {
                    button.center = CGPointMake((1 + i) * 15 + kImageWidth *(0.5 + i) , 10 + kImageHeight * 0.5);
                }
                else button.center = CGPointMake((1 + 2*i) * 15 + kImageWidth *(0.5 + i) , 10 + kImageHeight * 0.5);
                [button SetLocation:section : 0: i];
                //button.column = i;
                [button setValue:[NSNumber numberWithInt:i] forKey:@"column"];
                [button addTarget:self action:@selector(imageItemClick:) forControlEvents:UIControlEventTouchUpInside];
                //[button setBackgroundImage:self.image forState:UIControlStateNormal];
                [button addSubview:name];
                [cell addSubview:button];
                //[array addObject:button];
            }
        }
        else
        {
            cell = [[UITableGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell addSubview:noAdmin];
        }
        
        
    }
    else
    {
        if (memberList == nil||memberList.count==0)
        {
            UILabel *noMember = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 88)];
            noMember.font = [UIFont fontWithName:defaultBoldFont size:13];
            noMember.textAlignment = UITextAlignmentCenter;
            noMember.textColor = defaultTitleGray96;
            noMember.text = @"暂无活动成员";
            
            cell = [[UITableGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell addSubview:noMember];
            
        }
        else
        {
            cell = [[UITableGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            UIImageView *cbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"member_list_back.png"]];
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.backgroundView = cbg;
            
            int rowIndex = [indexPath row];
            int maxRow = memberList.count / 4;
            int iconNumber = 4;
            if (rowIndex == maxRow)
                iconNumber = memberList.count - 4 * maxRow;
            
            NSMutableArray *array = [NSMutableArray array];
            
            for (int i=0; i<iconNumber; i++) {
                
                int memberIndex = i + rowIndex*4;
                NSDictionary* member = memberList[memberIndex];
                
                IconImageButtonLoader *button = [IconImageButtonLoader buttonWithType:UIButtonTypeCustom];
                
                UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 50, 20)];
                name.text = member[@"name"];
                name.font = [UIFont fontWithName:defaultFont size:11];
                name.textAlignment = UITextAlignmentCenter;
                name.textColor = defaultMainColor;
                
                
                NSDictionary* profileData = member[@"profile"];
                [button setBackgroundImage:self.image forState:UIControlStateNormal];
                if ([profileData isKindOfClass:[NSDictionary class]])
                {
                    NSString* iconStr = [profileData valueForKey:@"iconUrl"];
                    iconStr = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/resources%@", iconStr];
                    NSURL* creatorIconUrl = [NSURL URLWithString:iconStr];
                    [button LoadFromUrl:creatorIconUrl :self.image];
                }
                
                button.bounds = CGRectMake(0, 0, kImageWidth, kImageHeight);
                if (i==0) {
                    button.center = CGPointMake((1 + i) * 15 + kImageWidth *(0.5 + i) , 10 + kImageHeight * 0.5);
                }
                else button.center = CGPointMake((1 + 2*i) * 15 + kImageWidth *(0.5 + i) , 10 + kImageHeight * 0.5);
                [button SetLocation:section : rowIndex: i];
                //button.column = i;
                [button setValue:[NSNumber numberWithInt:i] forKey:@"column"];
                [button addTarget:self action:@selector(imageItemClick:) forControlEvents:UIControlEventTouchUpInside];
                //[button setBackgroundImage:self.image forState:UIControlStateNormal];
                [button addSubview:name];
                [cell addSubview:button];
                [array addObject:button]; 
            }
            [cell setValue:array forKey:@"buttons"];
        }
        
    }
    
    //获取到里面的cell里面的3个图片按钮引用
    NSArray *imageButtons =cell.buttons;
    //设置UIImageButton里面的row属性
    [imageButtons setValue:[NSNumber numberWithInt:indexPath.row] forKey:@"row"];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    [view setBackgroundColor:[UIColor colorWithRed:0.95294117647059 green:0.95294117647059 blue:0.95294117647059 alpha:1]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
    
    label.textColor = [UIColor colorWithRed:0.94117647 green:0.42352941 blue:0.11764706 alpha:1];
    
    label.font = [UIFont fontWithName:defaultBoldFont size:13];
    
    label.backgroundColor = [UIColor clearColor];
    
    label.text = [_titleArray objectAtIndex:section];
    
    [view addSubview:label];
    
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 70;
    }
    else return 88;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        MemberInfoTableViewController *memberInfoTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MemberInfoTableViewController"];
        NSDictionary* creator = localData[@"createdBy"];
        [memberInfoTVC SetMemberId:creator[@"id"]];
        
        NSString* name = creator[@"name"];
        NSDictionary* profileData = creator[@"profile"];
        if ([profileData isKindOfClass:[NSDictionary class]])
        {
            NSString* nick = [UserManager filtStr:profileData[@"nickName"]:@""];
            if (nick.length > 0)
                name = nick;
        }
        memberInfoTVC.navigationItem.title = [NSString stringWithFormat:@"%@的账户",name];
        
        [self.navigationController pushViewController:memberInfoTVC animated:YES];
    }
}

// click the specify member
-(void)imageItemClick:(IconImageButtonLoader *)button{
    
    
    MemberInfoTableViewController *memberInfoTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MemberInfoTableViewController"];
    
    int section = [button Sector];
    
    NSDictionary* creator = localData[@"createdBy"];
    NSNumber* creatorId = creator[@"id"];
    
    if (section == 1)
    {
        // admin
        int offset = [button Index];
        
        NSDictionary* data = adminList[offset];
        
        [memberInfoTVC SetMemberId:data[@"id"]];
        [memberInfoTVC SetFromActivity:localData[@"id"] :creatorId :true];
        [memberInfoTVC SetRefreshOwner:self :@selector(FullRefresh)];
    }
    else if (section == 2)
    {
        // user
        int row = [button Row];
        int index = [button Index];
        
        int offset = row * 4 + index;
        
        NSDictionary* data = memberList[offset];
        
        if (adminList.count < 4)
        {
            [memberInfoTVC SetMemberId:data[@"id"]];
            [memberInfoTVC SetFromActivity:localData[@"id"] :creatorId :false];
            [memberInfoTVC SetRefreshOwner:self :@selector(FullRefresh)];
        }
    }
    
    NSString* name = creator[@"name"];
    NSDictionary* profileData = creator[@"profile"];
    if ([profileData isKindOfClass:[NSDictionary class]])
    {
        NSString* nick = [UserManager filtStr:profileData[@"nickName"]:@""];
        if (nick.length > 0)
            name = nick;
    }
    memberInfoTVC.navigationItem.title = [NSString stringWithFormat:@"%@的账户",name];
    
    [self.navigationController pushViewController:memberInfoTVC animated:YES];
}


#pragma mark 根据size截取图片中间矩形区域的图片 这里的size是正方形
-(UIImage *)cutCenterImage:(UIImage *)image size:(CGSize)size{
    CGSize imageSize = image.size;
    CGRect rect;
    //根据图片的大小计算出图片中间矩形区域的位置与大小
    if (imageSize.width > imageSize.height) {
        float leftMargin = (imageSize.width - imageSize.height) * 0.5;
        rect = CGRectMake(leftMargin, 0, imageSize.height, imageSize.height);
    }else{
        float topMargin = (imageSize.height - imageSize.width) * 0.5;
        rect = CGRectMake(0, topMargin, imageSize.width, imageSize.width);
    }
    
    CGImageRef imageRef = image.CGImage;
    //截取中间区域矩形图片
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, rect);
    
    UIImage *tmp = [[UIImage alloc] initWithCGImage:imageRefRect];
    CGImageRelease(imageRefRect);
    
    UIGraphicsBeginImageContext(size);
    CGRect rectDraw = CGRectMake(0, 0, size.width, size.height);
    [tmp drawInRect:rectDraw];
    // 从当前context中创建一个改变大小后的图片
    tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return tmp;
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
                                   
@end
