//
//  CreateActivityTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-26.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "EditActivityTableViewController.h"
#import "Constants.h"
#import "EditActivityDetailTableViewController.h"

@interface EditActivityTableViewController ()
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
}

@end

@implementation EditActivityTableViewController

@synthesize startDate,endDate;
@synthesize datePicker,allDayTrigger;
@synthesize actName,actDescription;
@synthesize doneToolbar;

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

    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    [self InitActivityData];
    
}

- (void) SetActivityData:(NSDictionary *)data
{
    activityData = [NSMutableDictionary dictionaryWithDictionary:data];
}

-(void)SetActivityDataFromId:(NSNumber *)actId
{
    NSString* urlStr = @"http://e.taoware.com:8080/quickstart/api/v1/activity";
    urlStr = [urlStr stringByAppendingFormat:@"/%@", actId];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [request setUsername:@"admin"];
    [request setPassword:@"admin"];
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error)
    {
        activityData = [[NSMutableDictionary alloc]init];
        
        NSDictionary* fullData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil];
        
        NSString* startTime = fullData[@"beginTime"];
        [activityData setValue:startTime forKey:@"beginTime"];
        NSString* endTIme = fullData[@"endTime"];
        [activityData setValue:endTIme forKey:@"endTime"];
        NSString* isallday = fullData[@"isAllDay"];
        
        int i = 0;
    }
}

- (void) InitActivityData
{
    if (activityData == nil)
        activityData = [[NSMutableDictionary alloc]init];
    else
    {
        // TODO: restore data
    }
    
    actNameString = @"";
    actDescriptionString = @"";

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
}

- (IBAction)nextButton:(id)sender {
    EditActivityDetailTableViewController *EditActDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditActivityDetailTableViewController"];
    EditActDetailVC.navigationItem.title = @"详细页面";
    
    NSNumber* uid = [NSNumber numberWithInt:[[UserManager Instance]GetLocalUserId]];
    

    [activityData setValue:actNameString forKey:@"title"];
    [activityData setValue:actDescriptionString forKey:@"description"];
    
    if (allDayTrigger.isOn)
        [activityData setValue:@"true" forKey:@"isAllDay"];
    else
        [activityData setValue:@"false" forKey:@"isAllDay"];
    
    [activityData setValue:uid forKey:@"createdBy"];
    [activityData setValue:startDate.text forKey:@"beginTime"];
    [activityData setValue:endDate.text forKey:@"endTime"];
    
    [EditActDetailVC SetActivityData:activityData];
    [self.navigationController pushViewController:EditActDetailVC animated:YES];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [SchoolManager InitSchoolList];
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
