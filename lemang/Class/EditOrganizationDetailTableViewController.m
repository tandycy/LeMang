//
//  EditOrganizationDetailTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-27.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "EditOrganizationDetailTableViewController.h"
#import "SchoolManager.h"
#import "Constants.h"

@interface EditOrganizationDetailTableViewController ()
{
    NSArray *pickerArray;
    NSArray *schoolArray;
    NSArray *areaArray;
    NSArray *collegeArray;
    
    NSArray* tagButtonArray;
    
    UIAlertView* endMessageView;
}

@end

@implementation EditOrganizationDetailTableViewController

@synthesize orgArea,orgAddress,orgCollege,orgContact,orgSchool,orgType;
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
    [self universityListInit];
    [self detailViewInit];
    [self initTag];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *ttt = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(ToFirstPage:)];
    self.navigationItem.leftBarButtonItem = ttt;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(DoCommitEdit:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [self RecoverDataContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) SetOrganizationData:(NSMutableDictionary*)data
{
    orgData = data;
}

- (void) SetIconData : (UIImage*)img
{
    iconImage = img;
}



-(void)universityListInit
{
    schoolArray = [SchoolManager GetSchoolNameList];}

- (void)detailViewInit
{
    //init orgSchool|area|college dataPicker
    orgSchool.inputView = dataPicker;
    orgSchool.inputAccessoryView = doneToolbar;
    orgSchool.delegate = self;
    [orgSchool addTarget:self action:@selector(schoolOnEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    orgArea.inputAccessoryView = doneToolbar;
    orgArea.inputView = dataPicker;
    orgArea.delegate = self;
    [orgArea addTarget:self action:@selector(areaOnEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    orgCollege.inputAccessoryView = doneToolbar;
    orgCollege.inputView = dataPicker;
    orgCollege.delegate = self;
    [orgCollege addTarget:self action:@selector(collegeOnEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    dataPicker.delegate = self;
    dataPicker.dataSource = self;
    dataPicker.frame = CGRectMake(0, 480, 320, 216);
    
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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger row = [dataPicker selectedRowInComponent:0];
    if (orgSchool.isEditing) {
        textField = orgSchool;
    }
    else if(orgArea.isEditing)
    {
        textField = orgArea;
    }
    else if(orgCollege.isEditing)
    {
        textField = orgCollege;
    }
    textField.text = [pickerArray objectAtIndex:row];
}

- (IBAction)selectButton:(id)sender {
    if (orgSchool.isEditing) {
        [orgSchool endEditing:YES];
        [self OnSchoolChange];
    }
    else if(orgArea.isEditing)
    {
        [orgArea endEditing:YES];
    }
    else if(orgCollege.isEditing)
    {
        [orgCollege endEditing:YES];
    }
}

- (void) OnSchoolChange
{
    orgArea.text = @"";
    orgCollege.text = @"";
    
    SchoolItem* item = [SchoolManager GetSchoolItem:orgSchool.text];
    
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
    NSString* category = [UserManager filtStr:orgData[@"type"] :@""];
    
    if ([category isEqualToString:@"University"])
        [orgType setSelectedSegmentIndex:0];
    else if ([category isEqualToString:@"Department"])
        [orgType setSelectedSegmentIndex:1];
    else if ([category isEqualToString:@"Company"])
        [orgType setSelectedSegmentIndex:2];
    else if ([category isEqualToString:@"Association"])
        [orgType setSelectedSegmentIndex:3];
    else if ([category isEqualToString:@"Person"])
        [orgType setSelectedSegmentIndex:3];
    else
        [orgType setSelectedSegmentIndex:0];
    
    
    orgAddress.text = [UserManager filtStr:orgData[@"address"] :@""];
    _otherLimit.text = [UserManager filtStr:orgData[@"otherLimit"] :@""];
    orgContact.text = [UserManager filtStr:orgData[@"contact"] :@""];
    
    
    orgSchool.text = [UserManager filtStr:orgData[@"university"] :@""];
    [self OnSchoolChange];
    orgArea.text = [UserManager filtStr:orgData[@"area"] :@""];
    orgCollege.text = [UserManager filtStr:orgData[@"department"] :@""];
    
    // Recover Tags
    NSString* fullTagStr = [UserManager filtStr:orgData[@"tags"] :@""];
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
    
    switch (orgType.selectedSegmentIndex) {
        case 0:// 0 - 学校
            [orgData setValue:@"University" forKey:@"type"];
            break;
        case 1:// 1 - 院系
            [orgData setValue:@"Department" forKey:@"type"];
            break;
        case 2:// 2 - 商家
            [orgData setValue:@"Company" forKey:@"type"];
            break;
        case 3:// 3 - 社团
            [orgData setValue:@"Association" forKey:@"type"];
            break;
        case 4:// 4 - 个人
            [orgData setValue:@"Person" forKey:@"type"];
            break;
        default:
            break;
    }

    
    // temp data
    [orgData setValue:orgSchool.text forKey:@"university"];
    [orgData setValue:orgArea.text forKey:@"area"];
    [orgData setValue:orgCollege.text forKey:@"department"];
    
    
    [orgData setValue:orgAddress.text forKey:@"address"];
    
    if (_otherLimit.text.length == 0)
        [orgData removeObjectForKey:@"otherLimit"];
    else
        [orgData setValue:_otherLimit.text forKey:@"otherLimit"];
    
    if (orgContact.text.length == 0)
        [orgData removeObjectForKey:@"contact"];
    else
        [orgData setValue:orgContact.text forKey:@"contact"];
    
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
    
    [orgData setValue:fullTagStr forKey:@"tags"];
    
}


- (void) UpdateIdData
{
    NSString* schoolName = orgSchool.text;
    SchoolItem* school = [SchoolManager GetSchoolItem:schoolName];
    if (school != Nil)
    {
        NSNumber* sid = [school GetId];
        //NSString* schoolData = [NSString stringWithFormat:@"{\"id\":%@}",sid];
        NSMutableDictionary* schoolDic = [[NSMutableDictionary alloc]init];
        [schoolDic setValue:sid forKey:@"id"];
        [orgData setObject:schoolDic forKey:@"university"];
        
        NSNumber* areaId = [school GetAreaId:orgArea.text];
        if (!areaId)
            [orgData removeObjectForKey:@"area"];
        else
        {
            //NSString* areaData = [NSString stringWithFormat:@"{\"id\":%@}",areaId];
            NSMutableDictionary* areaDic = [[NSMutableDictionary alloc]init];
            [areaDic setValue:areaId forKey:@"id"];
            [orgData setObject:areaDic forKey:@"area"];
        }
        
        NSNumber* departId = [school GetDepartId:orgCollege.text];
        if (!departId)
            [orgData removeObjectForKey:@"department"];
        else
        {
            //NSString* departData = [NSString stringWithFormat:@"{\"id\":%@}",departId];
            NSMutableDictionary* depDic = [[NSMutableDictionary alloc]init];
            [depDic setValue:departId forKey:@"id"];
            [orgData setObject:depDic forKey:@"department"];
        }
    }
    else
    {
        [orgData setValue:@"" forKey:@"university"];
        [orgData removeObjectForKey:@"department"];
        [orgData removeObjectForKey:@"area"];
    }
    
}

- (IBAction)DoCommitEdit:(id)sender
{
    if (![self CheckActivityData])  // failed pass info check
        return;
    
    [self UpdateDataContent];
    [self UpdateIdData];
    
    // TODO: type change is not allowed?
    [orgData removeObjectForKey:@"type"];
    
    NSData* postData = [NSJSONSerialization dataWithJSONObject:orgData options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"true\"" withString:@"true"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"false\"" withString:@"false"];
    
    //NSLog(@"%@", jsonString);
    
    NSString* orgUrlStr = @"http://e.taoware.com:8080/quickstart/api/v1/association";
    NSNumber* orgId = orgData[@"id"];
    orgUrlStr = [orgUrlStr stringByAppendingFormat:@"/%@", orgId];
    ASIHTTPRequest* createRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:orgUrlStr]];
    
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
        [self UploadImageFile: orgId];
        
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
    
    NSString* fileName = [NSString stringWithFormat: @"group_icon_%@", aid];
    NSString* fileFullName = [fileName stringByAppendingString:@".jpg"];
    [self saveImage:iconImage WithName:fileFullName];
    
    NSString* firstPath = @"http://e.taoware.com:8080/quickstart/api/v1/images/group/";
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
    NSString *iconPath = [documentsDirectory stringByAppendingPathComponent:fileFullName];
    
    
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
    int aaa = [uploadRequest responseStatusCode];
    NSString* bbb = [uploadRequest responseString];
    
    if (error)
    {
        // TODO
        NSLog(@"upload user icon fail: %d", error.code);
    }
    if (aaa == 200)
    {
        // TODO: success
    }
    else
    {
        // TODO
        NSLog(@"upload user icon return: %d", aaa);
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


- (void)DoAlert : (NSString*)caption: (NSString*)content
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:caption message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alertView show];
}

- (BOOL) CheckActivityData
{
    if (orgSchool.text.length == 0)
    {
        [self DoAlert:@"学校不能为空":@""];
        return false;
    }
    if (orgArea.text.length == 0)
    {
        [self DoAlert:@"校区不能为空":@""];
        return false;
    }
    if (orgCollege.text.length == 0)
    {
        [self DoAlert:@"院系不能为空":@""];
        return false;
    }
    
    
    if (orgAddress.text.length == 0)
    {
        [self DoAlert:@"地址不能为空":@""];
        return false;
    }
    
    return true;
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

/*
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
