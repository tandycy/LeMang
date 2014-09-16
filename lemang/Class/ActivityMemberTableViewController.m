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
    
    self.image = [UIImage imageNamed:@"user_icon_de.png"];
    
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

- (void) SetActivity:(Activity *)activity
{
    linkedActivity = activity;
    
    adminList = [[NSMutableArray alloc]init];
    memberList = [[NSMutableArray alloc]init];
    
    NSArray* members = [activity GetMemberList];
    
    if (!members)
        return;
    
    for (int i = 0; i < members.count; i++)
    {
        NSDictionary* member = members[i];

        // TODO: approve check
        
        NSString* rule = member[@"role"];
        
        if ([rule isEqualToString:@"Guest"] || [rule isEqualToString:@"User"])
        {
            NSDictionary* userData = member[@"user"];
            [memberList addObject:userData];
        }
        else if ([rule isEqualToString:@"Administrator"])
        {
            NSDictionary* userData = member[@"user"];
            [adminList addObject:userData];
        }
        else
        {
            NSLog(@"User not guest: %@", rule);
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
        if (adminList != nil && adminList.count > 0)
            return 1;
        else
            return 0;
    }
    else if (section == 2)
    {
        if (memberList == nil)
            return 0;
        
        int members = memberList.count;
        
        if (members == 0)
            return 0;
        
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
        NSDictionary* creator = [linkedActivity GetActivityData][@"createdBy"];
        NSDictionary* profile = creator[@"profile"];
        NSDictionary* creatorSchoolData = creator[@"university"];
        NSDictionary* creatorDepartData = creator[@"department"];
        
        UIImageView *cbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"member_back.png"]];
        cell.backgroundView = cbg;
        //  cell.selectedBackgroundView = [[UIView alloc]init];
        
        IconImageViewLoader *creatorImg = [[IconImageViewLoader alloc]init];
        
        [creatorImg setImage:[UserManager DefaultIcon]];
        if ([profile isKindOfClass:[NSDictionary class]])
        {
            NSString* iconStr = profile[@"iconUrl"];
            if ([iconStr isKindOfClass:[NSString class]])
            {
                NSString* iconStr = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/resources%@", iconStr];
                
                NSURL* creatorIconUrl = [NSURL URLWithString:iconStr];
                [creatorImg LoadFromUrl:creatorIconUrl :[UserManager DefaultIcon]];
            }
        }
        
        UILabel *creatorHead = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 50, 50)];
        UILabel *creatorName = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 200, 13)];
        UILabel *creatorSchool = [[UILabel alloc]initWithFrame:CGRectMake(100, 28, 200, 13)];
        UILabel *creatorColleage = [[UILabel alloc]initWithFrame:CGRectMake(100, 47, 200, 13)];
        
        creatorName.text = creator[@"name"];
        creatorSchool.text = creatorSchoolData[@"name"];
        creatorColleage.text = creatorDepartData[@"name"];
        
        creatorName.font = [UIFont fontWithName:defaultBoldFont size:13];
        creatorName.textColor = defaultMainColor;
        creatorSchool.font = [UIFont fontWithName:defaultBoldFont size:13];
        creatorColleage.font = [UIFont fontWithName:defaultBoldFont size:13];
        
        [creatorHead addSubview:creatorImg];
        [cell addSubview:creatorHead];
        [cell addSubview:creatorName];
        [cell addSubview:creatorSchool];
        [cell addSubview:creatorColleage];
        
    }
    else if (section == 1)
    {
        // TODO: admin list
        cell = [[UITableGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        int iconNumber = 4;
        if (iconNumber > adminList.count)
            iconNumber = adminList.count;
        
        for (int i = 0; i < iconNumber; i++)
        {
            //
        }
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
            
            
            NSDictionary* profile = member[@"profile"];
            [button setBackgroundImage:self.image forState:UIControlStateNormal];
            if ([profile isKindOfClass:[NSDictionary class]])
            {
                NSString* iconStr = profile[@"iconUrl"];
                if ([iconStr isKindOfClass:[NSString class]])
                {
                    NSString* iconStr = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/resources%@", iconStr];
                    NSURL* creatorIconUrl = [NSURL URLWithString:iconStr];
                    [button LoadFromUrl:creatorIconUrl :[UserManager DefaultIcon]];
                }
            }
            
            button.bounds = CGRectMake(0, 0, kImageWidth, kImageHeight);
            if (i==0) {
                button.center = CGPointMake((1 + i) * 15 + kImageWidth *(0.5 + i) , 10 + kImageHeight * 0.5);
            }
            else button.center = CGPointMake((1 + 2*i) * 15 + kImageWidth *(0.5 + i) , 10 + kImageHeight * 0.5);
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
    
    label.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:13];
    
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
}

-(void)imageItemClick:(UIImageButton *)button{
    NSString *msg = [NSString stringWithFormat:@"第%i行 第%i列",button.row + 1, button.column + 1];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"好的，知道了"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

/*
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
 */
                                   
@end
