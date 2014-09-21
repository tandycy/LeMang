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
}

@end

@implementation CreateActivityTableViewController

@synthesize actName,actDescription;
@synthesize actUniversity,actArea,actCollege;
@synthesize dataPicker,doneToolbar;
@synthesize actHost,actHostType;
@synthesize actLocation,actPeopleLimit,actTags,otherTag;
@synthesize startDate,endDate,datePicker,allDayTrigger;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [SchoolManager InitSchoolList];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self universityListInit];
    [self initView];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(DoCommitCreate:)];
    self.navigationItem.rightBarButtonItem = doneButton;

}

-(void)initView
{
    actDescription.delegate = self;
    actName.delegate = self;
    
    nameHolder = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, actDescription.frame.size.width, 20)];
    nameHolder.font = [UIFont fontWithName:defaultFont  size:15];
    nameHolder.text = @"请输入活动标题...";
    nameHolder.enabled = NO;//lable必须设置为不可用
    nameHolder.backgroundColor = [UIColor clearColor];
    [actName addSubview:nameHolder];
    
    descriptionHolder = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, actDescription.frame.size.width, 20)];
    descriptionHolder.font = [UIFont fontWithName:defaultFont  size:15];
    descriptionHolder.text = @"请输入活动描述...";
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
    //[datePicker setMinimumDate:[NSDate date]];
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
    
    dataPicker.delegate = self;
    dataPicker.dataSource = self;
    dataPicker.frame = CGRectMake(0, 480, 320, 216);
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void)DoAlert : (NSString*)caption: (NSString*)content
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:caption message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
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
    
    // TODO: 活动发起？ act host
    return true;
}

- (IBAction)DoCommitCreate:(id)sender
{
    if (![self CheckActivityData])  // failed pass info check
        return;
    
    activityData = [[NSMutableDictionary alloc]init];
    NSNumber* uid = [NSNumber numberWithInt:[[UserManager Instance]GetLocalUserId]];
    NSMutableDictionary* uidDic = [[NSMutableDictionary alloc]init];
    [uidDic setValue:uid forKey:@"id"];
    [activityData setValue:uidDic forKey:@"createdBy"];

    [activityData setValue:actNameString forKey:@"title"];
    [activityData setValue:actDescriptionString forKey:@"description"];
    
    if (allDayTrigger.isOn)
        [activityData setValue:@"true" forKey:@"isAllDay"];
    else
        [activityData setValue:@"false" forKey:@"isAllDay"];
    
    [activityData setValue:startDataText forKey:@"beginTime"];
    [activityData setValue:endDataText forKey:@"endTime"];
    
    nowDate = [[NSDateFormatter alloc]init];
    [nowDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* createDataText = [nowDate stringFromDate:[NSDate date]];
    [activityData setValue:endDataText forKey:@"createdDate"];
    
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
            [activityData setValue:@"Person" forKey:@"activityGroup"];
            break;
        default:
            break;
    }

    [activityData setValue:@"Activity" forKey:@"activityType"];

    
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
        // TODO create success operation
        if (owner != nil && [owner isKindOfClass:[ActivityViewController class]])
        {
            [(ActivityViewController*)owner CreateActivityDone];
            [self.navigationController popViewControllerAnimated:true];
        }
    }
}

- (void)SetOwner:(id)_owner
{
    owner = _owner;
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.actName resignFirstResponder];
    [self.actDescription resignFirstResponder];
    [self.actLocation resignFirstResponder];
    [self.actPeopleLimit resignFirstResponder];
    [self.otherTag resignFirstResponder];
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
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
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
    }
    else if(actArea.isEditing)
    {
        [actArea endEditing:YES];
    }
    else if(actCollege.isEditing)
    {
        [actCollege endEditing:YES];
    }
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

-(void)universityListInit
{
    schoolArray = [SchoolManager GetSchoolNameList];
    //NSLog(@"done %@",schoolArray);
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
    textField.text = [pickerArray objectAtIndex:row];
}

- (void) OnSchoolChange
{
    actArea.text = @"";
    actCollege.text = @"";
    
    SchoolItem* item = [SchoolManager GetSchoolItem:actUniversity.text];
    
    areaArray = [item GetAreaList];
    collegeArray = [item GetDepartList];
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

@end
