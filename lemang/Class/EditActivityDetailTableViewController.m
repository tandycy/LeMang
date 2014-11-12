//
//  CreateActivityDetailTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-11.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "EditActivityDetailTableViewController.h"
#import "Constants.h"

@interface EditActivityDetailTableViewController ()
{
    NSArray *pickerArray;
    NSArray *schoolArray;
    NSArray *areaArray;
    NSArray *collegeArray;
    NSArray *hostArray;
    
    NSArray* tagButtonArray;
    
    UIAlertView* endMessageView;
}

@end

@implementation EditActivityDetailTableViewController

@synthesize actUniversity,actCollege,actArea,actHost;
@synthesize dataPicker,doneToolbar;

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
    
    [self pickerListInit];
    [self detailViewInit];
    [self initTag];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    UIBarButtonItem *ttt = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(ToFirstPage:)];
    
    self.navigationItem.leftBarButtonItem = ttt;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(DoCommitEdit:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [self RecoverDataContent];
}

- (IBAction)OnTypeChange:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 3)   // select group
    {
        [actHost setEnabled:true];
    }
    else
    {
        [actHost setEnabled:false];
        actHost.text = @"";
    }
}

- (void)SetActivityData:(NSMutableDictionary *)data
{
    activityData = data;
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
   // [self.orgName resignFirstResponder];
   // [self.orgDescription resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTag
{
    tagButtonArray = [[NSArray alloc]initWithObjects:_tag1,_tag2,_tag3,_tag4,_tag5,_tag6,_tag7,_tag8,nil];
    
    for (UIButton* item in tagButtonArray)
    {
        item.selected = false;
        
        //[_tag1 setTitle:tags[0] forState:UIControlStateNormal];
        [item setTintColor:[UIColor clearColor]];
        [item setTitleColor:defaultMainColor forState:UIControlStateNormal];
        [item addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    int currentTag = 0;
    NSArray* tagList = [UserManager GetTags];
    
    for (TagItem *item in tagList)
    {
        if (currentTag >= tagButtonArray.count)
            break;
        
        //if (item.tagClass == TagActivity)
        {
            UIButton* tagButton = tagButtonArray[currentTag];
            [tagButton setTitle:item.name forState:UIControlStateNormal];
            currentTag++;
        }
    }
    
    for (int i = currentTag; i < tagButtonArray.count; i++)
    {
        UIButton* item = tagButtonArray[i];
        [item setEnabled:NO];
    }

}

-(IBAction)tagClick:(id)sender
{
    if (![sender isKindOfClass:[UIButton class]])
        return;
    
    UIButton* tagItem = (UIButton*)sender;
    
    if (!tagItem.selected) {
        [tagItem setSelected:YES];
        [tagItem setBackgroundColor:defaultTagColor];
        [tagItem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    else
    {
        [tagItem setSelected:NO];
        [tagItem setBackgroundColor:[UIColor clearColor]];
    }
}

-(void)pickerListInit
{
    schoolArray = [SchoolManager GetSchoolNameList];
    
    NSArray* groupArray = [[UserManager Instance]GetAdminGroup];
    NSMutableArray* groupNames = [[NSMutableArray alloc]init];
    for (NSDictionary* item in groupArray)
    {
        NSString* name = item[@"name"];
        [groupNames addObject:name];
    }
    hostArray = [NSArray arrayWithArray:groupNames];
    
    [actHost setEnabled:false];
    actHost.text = @"";
}

- (void)detailViewInit
{
    //init actUniversity|area|college dataPicker
    actUniversity.inputView = dataPicker;
    actUniversity.inputAccessoryView = doneToolbar;
    actUniversity.delegate = self;
    [actUniversity addTarget:self action:@selector(schoolOnEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    actArea.inputAccessoryView = doneToolbar;
    actArea.inputView = dataPicker;
    actArea.delegate = self;
    [actArea addTarget:self action:@selector(areaOnEditing:) forControlEvents:UIControlEventEditingDidBegin];

    actCollege.inputAccessoryView = doneToolbar;
    actCollege.inputView = dataPicker;
    actCollege.delegate = self;
    [actCollege addTarget:self action:@selector(collegeOnEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    actHost.inputAccessoryView = doneToolbar;
    actHost.inputView = dataPicker;
    actHost.delegate = self;
    [actHost addTarget:self action:@selector(actHostOnEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    dataPicker.delegate = self;
    dataPicker.dataSource = self;
    dataPicker.frame = CGRectMake(0, 480, 320, 216);
    
}

- (IBAction)schoolOnEditing:(id)sender {
    pickerArray = schoolArray;
    [dataPicker reloadAllComponents];
}

- (IBAction)areaOnEditing:(id)sender {
    pickerArray = areaArray;
    [dataPicker reloadAllComponents];
}

- (IBAction)collegeOnEditing:(id)sender {
    pickerArray = collegeArray;
    [dataPicker reloadAllComponents];
}

- (IBAction)actHostOnEditing:(id)sender {
    pickerArray = hostArray;
    [dataPicker reloadAllComponents];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}

- (void)SetIconData:(UIImage *)img
{
    iconImage = img;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger row = [dataPicker selectedRowInComponent:0];
    if (actUniversity.isEditing) {
        textField = actUniversity;
    }
    else if(actArea.isEditing)
    {
        textField = actArea;
    }
    else if(actCollege.isEditing)
    {
        textField = actCollege;
    }
    else if (actHost.isEditing)
    {
        textField = actHost;
    }
    textField.text = [pickerArray objectAtIndex:row];
}

- (IBAction)selectButton:(id)sender {
    if (actUniversity.isEditing) {
        [actUniversity endEditing:YES];
        [self OnSchoolChange];
    }
    else if(actArea.isEditing)
    {
        [actArea endEditing:YES];
    }
    else if(actCollege.isEditing)
    {
        [actCollege endEditing:YES];
    }
    else if(actHost.isEditing)
    {
        [actHost endEditing:YES];
    }
}

- (void) OnSchoolChange
{
    actArea.text = @"";
    actCollege.text = @"";
    
    SchoolItem* item = [SchoolManager GetSchoolItem:actUniversity.text];
    
    areaArray = [item GetAreaList];
    collegeArray = [item GetDepartList];
}

- (IBAction)ToFirstPage:(id)sender
{
    [self UpdateDataContent];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)SetRootView:(UIViewController *)vc
{
    rootVC = vc;
}

- (void) RecoverDataContent
{
    NSString* category = [UserManager filtStr:activityData[@"activityGroup"] :@""];
    
    if ([category isEqualToString:@"University"])
        [_actHostType setSelectedSegmentIndex:0];
    else if ([category isEqualToString:@"Department"])
        [_actHostType setSelectedSegmentIndex:1];
    else if ([category isEqualToString:@"Company"])
        [_actHostType setSelectedSegmentIndex:2];
    else if ([category isEqualToString:@"Association"])
        [_actHostType setSelectedSegmentIndex:3];
    else if ([category isEqualToString:@"Person"])
        [_actHostType setSelectedSegmentIndex:4];
    else
        [_actHostType setSelectedSegmentIndex:0];
    
    if (_actHostType.selectedSegmentIndex == 3)
    {
        [actHost setEnabled:true];
    }
    
    NSString* region = [UserManager filtStr:activityData[@"regionLimit"] :@""];
    [_actAreaLimit setSelectedSegmentIndex:0];
    for (int i = 0; i < _actAreaLimit.numberOfSegments; i++)
    {
        if ([region isEqualToString:[_actAreaLimit titleForSegmentAtIndex:i]])
        {
            [_actAreaLimit setSelectedSegmentIndex:i];
            break;
        }
    }
    
    NSString* type = [UserManager filtStr:activityData[@"activityType"] :@""];
    if ([type isEqualToString:@"Notice"])
        [_actType setSelectedSegmentIndex:0];
    else if ([type isEqualToString:@"Activity"])
        [_actType setSelectedSegmentIndex:1];
    else
        [_actType setSelectedSegmentIndex:1];

    _actPeopleLimit.text = [UserManager filtStr:activityData[@"peopleLimit"] :@""];
    _actLocation.text = [UserManager filtStr:activityData[@"address"] :@""];
    _actOtherLimit.text = [UserManager filtStr:activityData[@"otherLimit"] :@""];
    _actContact.text = [UserManager filtStr:activityData[@"contact"] :@""];
    
    
    actUniversity.text = [UserManager filtStr:activityData[@"university"] :@""];
    [self OnSchoolChange];
    actArea.text = [UserManager filtStr:activityData[@"area"] :@""];
    actCollege.text = [UserManager filtStr:activityData[@"department"] :@""];
    
    // Recover Tags
    NSString* fullTagStr = [UserManager filtStr:activityData[@"tags"] :@""];
    NSString* otherTags = @"";
    
    NSArray *tagArray1 = [fullTagStr componentsSeparatedByString:@";"];
    
    for (NSString* tagPart1 in tagArray1)
    {
        NSArray *tagArray2 = [tagPart1 componentsSeparatedByString:@"；"];
        
        if (tagArray2.count > 1)
            NSLog(@"Meet CN ; symble.");
        
        for (NSString* tagPart2 in tagArray2)
        {
            bool setTag = false;
            
            for (UIButton* item in tagButtonArray)
            {
                if ([tagPart2 isEqualToString:item.titleLabel.text])
                {
                    setTag = true;
                    
                    // set select
                    [item setSelected:YES];
                    [item setBackgroundColor:defaultTagColor];
                    [item setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                }
            }
            
            if (!setTag)
            {
                if (otherTags.length > 0)
                    otherTags = [otherTags stringByAppendingString:@";"];
                
                otherTags = [otherTags stringByAppendingString:tagPart2];
            }
        }
    }
    _otherTag.text = otherTags;
    
}

- (void) UpdateDataContent
{
    //
    
    switch (_actHostType.selectedSegmentIndex) {
        case 0:// 0 - 学校
            [activityData setValue:@"University" forKey:@"activityGroup"];
            break;
        case 1:// 1 - 院系
            [activityData setValue:@"Department" forKey:@"activityGroup"];
            break;
        case 2:// 2 - 商家
            [activityData setValue:@"Company" forKey:@"activityGroup"];
            break;
        case 3:// 3 - 社团
            [activityData setValue:@"Association" forKey:@"activityGroup"];
            break;
        case 4:// 4 - 个人
            [activityData setValue:@"Person" forKey:@"activityGroup"];
            break;
        default:
            break;
    }
    
    if (actHost.text.length > 0)
        [activityData setValue:actHost.text forKey:@"createdByGroup"];
    
    NSString* areaLimitTxt = [_actAreaLimit titleForSegmentAtIndex:[_actAreaLimit selectedSegmentIndex]];
    [activityData setValue:areaLimitTxt forKey:@"regionLimit"];
    
    int type = [_actType selectedSegmentIndex];
    NSString* nam = [_actType titleForSegmentAtIndex:type];
    NSLog(@"%d - %@", type, nam);
    
    switch ([_actType selectedSegmentIndex]) {
        case 0:// 0 - 通知
            [activityData setValue:@"Notice" forKey:@"activityType"];
            break;
        case 1:// 1 - 活动
            [activityData setValue:@"Activity" forKey:@"activityType"];
            break;
        default:
            break;
    }

    // temp data
    [activityData setValue:actUniversity.text forKey:@"university"];
    [activityData setValue:actArea.text forKey:@"area"];
    [activityData setValue:actCollege.text forKey:@"department"];

    
    NSString* memberUp = @"0";
    if (_actPeopleLimit.text.length > 0)
        memberUp = _actPeopleLimit.text;
    [activityData setValue:memberUp forKey:@"peopleLimit"];
    
    [activityData setValue:_actLocation.text forKey:@"address"];
    
    if (_actOtherLimit.text.length == 0)
        [activityData removeObjectForKey:@"otherLimit"];
    else
        [activityData setValue:_actOtherLimit.text forKey:@"otherLimit"];
    
    if (_actContact.text.length == 0)
        [activityData removeObjectForKey:@"contact"];
    else
        [activityData setValue:_actContact.text forKey:@"contact"];
    
    NSString* fullTagStr = @"";
    
    for (UIButton* tagItem in tagButtonArray)
    {
        if (tagItem.isSelected)
        {
            if (fullTagStr.length != 0)
                fullTagStr = [fullTagStr stringByAppendingString:@";"];
            
            NSString* tagName = tagItem.titleLabel.text;
            
            fullTagStr = [fullTagStr stringByAppendingString:tagName];
        }
    }
    
    if (_otherTag.text.length > 0)
    {
        if (fullTagStr.length != 0)
            fullTagStr = [fullTagStr stringByAppendingString:@";"];
        
        fullTagStr = [fullTagStr stringByAppendingString:_otherTag.text];
    }
    
    [activityData setValue:fullTagStr forKey:@"tags"];
    
}


- (void) UpdateIdData
{
    NSNumber* uid = [[UserManager Instance]GetLocalUserId];
    NSMutableDictionary* uidDic = [[NSMutableDictionary alloc]init];
    [uidDic setValue:uid forKey:@"id"];
    [activityData setValue:uidDic forKey:@"createdBy"];
    
    NSString* schoolName = actUniversity.text;
    SchoolItem* school = [SchoolManager GetSchoolItem:schoolName];
    if (school != Nil)
    {
        NSNumber* sid = [school GetId];
        //NSString* schoolData = [NSString stringWithFormat:@"{\"id\":%@}",sid];
        NSMutableDictionary* schoolDic = [[NSMutableDictionary alloc]init];
        [schoolDic setValue:sid forKey:@"id"];
        [activityData setObject:schoolDic forKey:@"university"];
        
        NSNumber* areaId = [school GetAreaId:actArea.text];
        if (!areaId)
            [activityData removeObjectForKey:@"area"];
        else
        {
            //NSString* areaData = [NSString stringWithFormat:@"{\"id\":%@}",areaId];
            NSMutableDictionary* areaDic = [[NSMutableDictionary alloc]init];
            [areaDic setValue:areaId forKey:@"id"];
            [activityData setObject:areaDic forKey:@"area"];
        }
        
        NSNumber* departId = [school GetDepartId:actCollege.text];
        if (!departId)
            [activityData removeObjectForKey:@"department"];
        else
        {
            //NSString* departData = [NSString stringWithFormat:@"{\"id\":%@}",departId];
            NSMutableDictionary* depDic = [[NSMutableDictionary alloc]init];
            [depDic setValue:departId forKey:@"id"];
            [activityData setObject:depDic forKey:@"department"];
        }
    }
    else
    {
        [activityData setValue:@"" forKey:@"university"];
        [activityData removeObjectForKey:@"department"];
        [activityData removeObjectForKey:@"area"];
    }
    
    if (_actHostType.selectedSegmentIndex == 3 && actHost.text.length > 0)
    {
        NSString* groupName = actHost.text;
        NSDictionary* groupDic = [[UserManager Instance]GetGroupMap];
        
        NSNumber* gid = groupDic[groupName];
        
        if ([gid isKindOfClass:[NSNumber class]])
        {
            NSMutableDictionary* hostDic = [[NSMutableDictionary alloc]init];
            [hostDic setValue:gid forKey:@"id"];
            [activityData setObject:hostDic forKey:@"createdByGroup"];
        }
    }
    
    NSNumber* memberUp = [NSNumber numberWithLong:_actPeopleLimit.text.integerValue];
    [activityData setValue:memberUp forKey:@"peopleLimit"];
}

- (void)DoAlert : (NSString*)caption: (NSString*)content
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:caption message:content delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (BOOL) CheckActivityData
{
    if (actUniversity.text.length == 0)
    {
        [self DoAlert:@"学校不能为空":@""];
        return false;
    }
    if (actArea.text.length == 0)
    {
        [self DoAlert:@"校区不能为空":@""];
        return false;
    }
    if (actCollege.text.length == 0)
    {
        [self DoAlert:@"院系不能为空":@""];
        return false;
    }

    
    if (_actLocation.text.length == 0)
    {
        [self DoAlert:@"地址不能为空":@""];
        return false;
    }
    if (_actPeopleLimit.text.length == 0)
    {
        [self DoAlert:@"未指定人数限制":@""];
        return false;
    }
    
    if (_actHostType.selectedSegmentIndex == 3 && actHost.text.length == 0)
    {
        [self DoAlert:@"请选择活动所属组织":@"需要为本人创建或管理的组织"];
        return false;
    }
    
    return true;
}

- (IBAction)DoCommitEdit:(id)sender
{
    if (![self CheckActivityData])  // failed pass info check
        return;
    
    [self UpdateDataContent];
    [self UpdateIdData];
    
    NSData* postData = [NSJSONSerialization dataWithJSONObject:activityData options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"true\"" withString:@"true"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"false\"" withString:@"false"];
    
    //NSLog(@"%@", jsonString);
    
    NSString* actUrlStr = @"http://e.taoware.com:8080/quickstart/api/v1/activity";
    NSNumber* actId = activityData[@"id"];
    actUrlStr = [actUrlStr stringByAppendingFormat:@"/%@", actId];
    ASIHTTPRequest* createRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:actUrlStr]];
    
    [createRequest addRequestHeader:@"Content-Type" value:@"application/json;charset=UTF-8"];
    [createRequest appendPostData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [createRequest setRequestMethod:@"PUT"];
    
    [createRequest startSynchronous];
    
    NSError* error = [createRequest error];
    
    if (error)
    {
        NSString* errorStr = @"网络连接错误:";
        errorStr = [errorStr stringByAppendingFormat:@"%d - %@",error.code, error.localizedDescription];
        [self DoAlert:@"编辑失败" :errorStr];
        return;
    }
    
    int returnCode = [createRequest responseStatusCode];
    
    if (returnCode == 200)
    {
        [self UploadImageFile: actId];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"编辑完成" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        endMessageView = alertView;
        [alertView show];
    }
    else
    {
        NSLog(@"%d - %@", returnCode, jsonString);
    }
}

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger*)buttonIndex
{
    if ((id)alertView == (id)endMessageView)
    {
        if (rootVC)
            [self.navigationController popToViewController:rootVC animated:true];
        else
            [self.navigationController popToRootViewControllerAnimated:true];
    }
}

- (void) UploadImageFile : (NSNumber*)aid
{
    if (iconImage == nil)
        return;
    
    NSString* fileName = [NSString stringWithFormat: @"activity_icon_%@", aid];
    NSString* fileFullName = [fileName stringByAppendingString:@".jpg"];
    [self saveImage:iconImage WithName:fileFullName];
    
    NSString* firstPath = @"http://e.taoware.com:8080/quickstart/api/v1/images/activity/";
    firstPath = [firstPath stringByAppendingFormat:@"%@?imageName=%@.jpg", aid, fileName];
    
    NSURL* URL = [NSURL URLWithString:firstPath];
    ASIHTTPRequest *putRequest = [ASIHTTPRequest requestWithURL:URL];
    [putRequest setUsername:[UserManager UserName]];
    [putRequest setPassword:[UserManager UserPW]];
    
    [putRequest setRequestMethod:@"PUT"];
    [putRequest startSynchronous];
    
    NSError *error = [putRequest error];
    NSString* pathResp;
    
    if (!error)
    {
        pathResp = [putRequest responseString];
    }
    else
    {
        // TODO
        return;
    }
    

    NSURL* uploadUrl = [NSURL URLWithString:@"http://e.taoware.com:8080/quickstart/api/v1/images/upload"];
    
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *iconPath = [documentsDirectory stringByAppendingPathComponent:@"iconImageBig.jpg"];
    
    
    //[ASIHTTPRequest clearSession];
    ASIFormDataRequest *uploadRequest = [ASIFormDataRequest requestWithURL:uploadUrl];
    
    [uploadRequest setRequestMethod:@"POST"];
    [uploadRequest setTimeOutSeconds:15];
    
    [uploadRequest setPostValue:pathResp forKey:@"name"];
    [uploadRequest setFile:iconPath withFileName:fileFullName andContentType:@"image/jpeg" forKey:@"file"];
    [uploadRequest buildRequestHeaders];
    [uploadRequest buildPostBody];
    
    NSDictionary* hdata = [uploadRequest requestHeaders];
    NSLog(@"header: %@", hdata);
    
    [uploadRequest startSynchronous];
    
    error = [uploadRequest error];
    int returnCode = [uploadRequest responseStatusCode];
    
    if (error)
    {
        // TODO
        NSLog(@"upload user icon fail: %d", error.code);
    }
    if (returnCode == 200)
    {
        // TODO: success
    }
    else
    {
        // TODO
        NSLog(@"upload user icon return: %d", returnCode);
    }

}

#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

#pragma mark - Table view data source
/*
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
