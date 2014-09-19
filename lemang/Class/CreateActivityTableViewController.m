//
//  CreateActivityTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-20.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "CreateActivityTableViewController.h"
#import "Constants.h"

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
@synthesize actLocation,actTags,otherTag;
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

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.actName resignFirstResponder];
    [self.actDescription resignFirstResponder];
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
    }
    else if (endDate.isEditing)
    {
        endDate.text =dateAndTime;
        tempDate2 = selected;
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
