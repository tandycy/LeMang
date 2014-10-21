//
//  CreateActivityTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-20.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "CreateActivityTableViewController.h"
#import "Constants.h"
#import "ActivityViewController.h"

@interface CreateActivityTableViewController ()
{
    UIDatePicker *datePicker;
    UILabel *lab;
    NSDateFormatter *dateFormatter;
    NSDateFormatter *nowDate;
    UILabel *descriptionHolder;
    UILabel *nameHolder;
    
    NSString *actNameString;
    NSString *actDescriptionString;
    
    NSDate *tempDate;
    NSDate *tempDate2;
    
    NSArray *pickerArray;
    NSArray *schoolArray;
    NSArray *areaArray;
    NSArray *collegeArray;
    NSArray *hostArray;
    
    NSArray* tagButtonArray;
    
    int keyboardHeight;
    
    NSArray* titleArray;
}

@end

@implementation CreateActivityTableViewController

@synthesize actName,actDescription;
@synthesize actUniversity,actArea,actCollege;
@synthesize dataPicker,doneToolbar;
@synthesize actHost,actHostType;
@synthesize actLocation,actPeopleLimit,otherTag;
@synthesize startDate,endDate,datePicker,allDayTrigger;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor whiteColor]];
        //[self.tableView setBackgroundColor:[UIColor whiteColor]];
        [SchoolManager InitSchoolList];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pickerListInit];
    [self initView];
    [self initTag];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(DoCommitCreate:)];
    self.navigationItem.rightBarButtonItem = doneButton;

}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardHeight = keyboardRect.size.height;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
}

-(void)initView
{
    actDescription.delegate = self;
    actName.delegate = self;
    otherTag.delegate = self;
    //actPeopleLimit.delegate = self;
    
    nameHolder = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, actDescription.frame.size.width, 20)];
    nameHolder.font = [UIFont fontWithName:defaultFont  size:15];
    nameHolder.enabled = NO;//lable必须设置为不可用
    nameHolder.backgroundColor = [UIColor clearColor];
    [actName addSubview:nameHolder];
    
    descriptionHolder = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, actDescription.frame.size.width, 20)];
    descriptionHolder.font = [UIFont fontWithName:defaultFont  size:15];

    descriptionHolder.enabled = NO;//lable必须设置为不可用
    descriptionHolder.backgroundColor = [UIColor clearColor];
    [actDescription addSubview:descriptionHolder];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //date.inputAccessoryView = doneToolbar;
    //date.delegate = self;
    
    startDate.inputView = datePicker;
    startDate.inputAccessoryView = doneToolbar;
    endDate.inputView = datePicker;
    endDate.inputAccessoryView = doneToolbar;
    
    [datePicker setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*8]];
    [datePicker setMinimumDate:[NSDate date]];
    [allDayTrigger addTarget:self action:@selector(allDayTriggerChanged:) forControlEvents:UIControlEventValueChanged];
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    datePicker.frame =  CGRectMake(0, 480, 320, 260);
    
    nowDate = [[NSDateFormatter alloc]init];
    [nowDate setDateFormat:@"yyyy年MM月dd日"];
    startDate.text = [nowDate stringFromDate:[NSDate date]];
    endDate.text = [nowDate stringFromDate:[NSDate date]];
    tempDate = tempDate2 = [NSDate date];
    
    [nowDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    startDataText = [nowDate stringFromDate:[NSDate date]];
    endDataText = [nowDate stringFromDate:[NSDate date]];
    
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
    
    [actArea setEnabled:FALSE];
    [actCollege setEnabled:FALSE];
    
    actHost.inputAccessoryView = doneToolbar;
    actHost.inputView = dataPicker;
    actHost.delegate = self;
    [actHost addTarget:self action:@selector(actHostOnEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    dataPicker.delegate = self;
    dataPicker.dataSource = self;
    dataPicker.frame = CGRectMake(0, 480, 320, 216);
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    
    
    titleArray = [NSArray arrayWithObjects: _titleTop, _titleDesc, _titleTimeBegin, _titleTimeEnd, _titleSchool, _titleArea, _titleDepart, _titleAddress, _titleTag, nil];
    if (isActivity)
    {
        self.navigationItem.title = @"创建活动";
        nameHolder.text = @"请输入活动标题...";
        descriptionHolder.text = @"请输入活动描述...";

        for (UILabel* label in titleArray)
        {
            NSString* title = label.text;
            title = [title stringByReplacingOccurrencesOfString:@"通知" withString:@"活动"];
            label.text = title;
        }
    }
    else
    {
        self.navigationItem.title = @"创建通知";
        nameHolder.text = @"请输入通知标题...";
        descriptionHolder.text = @"请输入通知描述...";
        
        for (UILabel* label in titleArray)
        {
            NSString* title = label.text;
            title = [title stringByReplacingOccurrencesOfString:@"活动" withString:@"通知"];
            label.text = title;
        }
        
        actHost.text = groupName;
        [actHost setEnabled: false];
        [actHostType setSelectedSegmentIndex:3];    // for association only
        [actHostType setEnabled: false];
    }
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


- (void)DoAlert : (NSString*)caption: (NSString*)content
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:caption message:content delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alertView show];
}

- (BOOL) CheckActivityData
{
    if (actNameString.length == 0)
    {
        [self DoAlert:@"标题不能为空":@""];
        return false;
    }
    if (actDescriptionString.length == 0)
    {
        [self DoAlert:@"描述不能为空":@""];
        return false;
    }
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

    
    if (actLocation.text.length == 0)
    {
        [self DoAlert:@"地址不能为空":@""];
        return false;
    }
    if (actPeopleLimit.text.length == 0)
    {
        [self DoAlert:@"未指定人数限制":@""];
        return false;
    }
    
    if (actHostType.selectedSegmentIndex == 3 && actHost.text.length == 0)
    {
        [self DoAlert:@"请选择活动所属组织":@"需要为本人创建或管理的组织"];
        return false;
    }
    
    return true;
}

- (IBAction)DoCommitCreate:(id)sender
{
    if (![self CheckActivityData])  // failed pass info check
        return;
    
    activityData = [[NSMutableDictionary alloc]init];
    NSNumber* uid = [[UserManager Instance]GetLocalUserId];
    NSMutableDictionary* uidDic = [[NSMutableDictionary alloc]init];
    [uidDic setValue:uid forKey:@"id"];
    [activityData setValue:uidDic forKey:@"createdBy"];

    [activityData setValue:actNameString forKey:@"title"];
    [activityData setValue:actDescriptionString forKey:@"description"];
    [activityData setValue:actLocation.text forKey:@"address"];
    
    if (allDayTrigger.isOn)
        [activityData setValue:@"true" forKey:@"isAllDay"];
    else
        [activityData setValue:@"false" forKey:@"isAllDay"];
    
    [activityData setValue:startDataText forKey:@"beginTime"];
    [activityData setValue:endDataText forKey:@"endTime"];
    
    nowDate = [[NSDateFormatter alloc]init];
    [nowDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* createDataText = [nowDate stringFromDate:[NSDate date]];
    [activityData setValue:createDataText forKey:@"createdDate"];
    
    switch (actHostType.selectedSegmentIndex) {
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
            [activityData setValue:@"Private" forKey:@"activityGroup"];
            break;
        default:
            break;
    }
    
    if (isActivity)
        [activityData setValue:@"Activity" forKey:@"activityType"];
    else
        [activityData setValue:@"Announcement" forKey:@"activityType"];
    
    if (actHostType.selectedSegmentIndex == 3 && actHost.text.length > 0)
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

    NSNumber* memberUp = [NSNumber numberWithLong:actPeopleLimit.text.integerValue];
    [activityData setValue:memberUp forKey:@"peopleLimit"];
    [activityData setValue:@"本校" forKey:@"regionLimit"];
    
    
    
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
    
    if (otherTag.text.length > 0)
    {
        if (fullTagStr.length != 0)
            fullTagStr = [fullTagStr stringByAppendingString:@";"];
        
        fullTagStr = [fullTagStr stringByAppendingString:otherTag.text];
    }
    
    [activityData setValue:fullTagStr forKey:@"tags"];
    
    
    
    
    NSData* postData = [NSJSONSerialization dataWithJSONObject:activityData options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"true\"" withString:@"true"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"false\"" withString:@"false"];
    
    //NSLog(@"%@", jsonString);
    
    NSString* actUrlStr = @"http://e.taoware.com:8080/quickstart/api/v1/activity";
    ASIHTTPRequest* createRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:actUrlStr]];

    [createRequest addRequestHeader:@"Content-Type" value:@"application/json;charset=UTF-8"];
    [createRequest appendPostData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [createRequest setRequestMethod:@"POST"];
    
    [createRequest startSynchronous];
    
    NSError* error = [createRequest error];
    
    if (error)
    {
        NSString* errorStr = @"网络连接错误:";
        errorStr = [errorStr stringByAppendingFormat:@"%d - %@",error.code, error.localizedDescription];
        [self DoAlert:@"创建失败" :errorStr];
        return;
    }
    
    int returnCode = [createRequest responseStatusCode];
    
    if (returnCode == 201)
    {
        if (owner != nil && [owner isKindOfClass:[ActivityViewController class]])
        {
            [(ActivityViewController*)owner CreateActivityDone];
        }
        else if (!isActivity)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建通知成功" message:@"在-我的活动-中可以编辑通知详细信息" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
        
        [self.navigationController popViewControllerAnimated:true];
    }
    else
    {
        NSString* message = [NSString stringWithFormat:@"服务器错误:%d",returnCode];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建通知失败" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        NSLog(@"%@", jsonString);
    }
}

- (void)SetActivity:(id)_owner
{
    isActivity = true;
    owner = _owner;
}

- (void) SetAnnounce:(NSString *)gname
{
    isActivity = false;
    groupName = gname;
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.actName resignFirstResponder];
    [self.actDescription resignFirstResponder];
    [self.actLocation resignFirstResponder];
    [self.actPeopleLimit resignFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == actName) {
        if (textView.text.length == 0) {
            nameHolder.text = @"请输入活动标题...";
        }else{
            nameHolder.text = @"";
        }
        actNameString =  textView.text;
    }
    else if (textView == actDescription)
    {
        if (textView.text.length == 0) {
            descriptionHolder.text = @"请输入活动描述...";
        }else{
            descriptionHolder.text = @"";
        }
        actDescriptionString = textView.text;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (textView == actName) {
        if ([text isEqualToString:@"\n"]) {
            [actName resignFirstResponder];
            return NO;
        }
    }
    return YES;
    
}

- (IBAction)allDayTriggerChanged:(id)sender {
    dateFormatter = [[NSDateFormatter alloc] init];
    if (allDayTrigger.isOn) {
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    }
    else {
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    }
    
    NSString *dateAndTime =  [dateFormatter stringFromDate:tempDate];
    NSString *dateAndTime2 = [dateFormatter stringFromDate:tempDate2];
    startDate.text = dateAndTime;
    endDate.text = dateAndTime2;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    startDataText = [dateFormatter stringFromDate:tempDate];
    endDataText = [dateFormatter stringFromDate:tempDate2];
}

- (IBAction)selectButton:(id)sender {
    if (startDate.isEditing) {
        [startDate endEditing:YES];
    }
    else if(endDate.isEditing)
    {
        [endDate endEditing:YES];
    }
    else if (actUniversity.isEditing) {
        [actUniversity endEditing:YES];
        [self OnSchoolChange];
        [self downAnim];
    }
    else if(actArea.isEditing)
    {
        [actArea endEditing:YES];
        [self downAnim];
    }
    else if(actCollege.isEditing)
    {
        [actCollege endEditing:YES];
        [self downAnim];
    }
    else if(actHost.isEditing)
    {
        [actHost endEditing:YES];
        [self downAnim];
    }
}

-(void)downAnim
{
    NSTimeInterval animationDuration = 0.20f;
    CGRect frame = self.view.frame;
    frame.origin.y += 216;
    frame.size.height -=10;
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (IBAction)datePickerValueChanged:(id)sender {
    NSDate * selected = [datePicker date];
    dateFormatter = [[NSDateFormatter alloc] init];
    if (allDayTrigger.isOn) {
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    }
    else [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    
    NSString *dateAndTime =  [dateFormatter stringFromDate:selected];
    if (startDate.isEditing) {
        startDate.text = dateAndTime;
        tempDate = selected;
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        startDataText = [dateFormatter stringFromDate:tempDate];
    }
    else if (endDate.isEditing)
    {
        endDate.text =dateAndTime;
        tempDate2 = selected;
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        endDataText = [dateFormatter stringFromDate:tempDate2];
    }
    
    
    // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"时间提示" message:dateAndTime delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    // [alert show];
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

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==otherTag) {
        textField.text = otherTag.text;
    }
    else{
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
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{ //当点触textField内部，开始编辑都会调用这个方法。textField将成为first responder
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y -= 216;
    frame.size.height +=10;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{//当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
    NSTimeInterval animationDuration = 0.10f;
    CGRect frame = self.view.frame;
    frame.origin.y += 216;
    frame.size.height -=10;
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return 0;
}

- (void) OnSchoolChange
{
    actArea.text = @"";
    actCollege.text = @"";
    
    SchoolItem* item = [SchoolManager GetSchoolItem:actUniversity.text];
    
    areaArray = [item GetAreaList];
    collegeArray = [item GetDepartList];
    
    if (areaArray.count > 0)
        [actArea setEnabled:TRUE];
    else
        [actArea setEnabled:FALSE];
    
    if (collegeArray.count > 0)
        [actCollege setEnabled:TRUE];
    else
        [actCollege setEnabled:FALSE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
   
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
@end
