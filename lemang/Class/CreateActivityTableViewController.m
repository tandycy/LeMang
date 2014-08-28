//
//  CreateActivityTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-26.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "CreateActivityTableViewController.h"

@interface CreateActivityTableViewController ()
{
    UIDatePicker *datePicker;
    UILabel *lab;
    NSDateFormatter *dateFormatter;
    NSDateFormatter *nowDate;
}

@end

@implementation CreateActivityTableViewController

@synthesize startDate,endDate;
@synthesize datePicker,allDayTrigger;
@synthesize actName,actDescription;

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
    //date.inputAccessoryView = doneToolbar;
    //date.delegate = self;
    
    startDate.inputView = datePicker;
    endDate.inputView = datePicker;
    
    [datePicker setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*8]];
    [datePicker setMinimumDate:[NSDate date]];
    [allDayTrigger addTarget:self action:@selector(allDayTriggerChanged:) forControlEvents:UIControlEventValueChanged];
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    datePicker.frame =  CGRectMake(0, 480, 320, 260);
    
    nowDate = [[NSDateFormatter alloc]init];
    [nowDate setDateFormat:@"yyyy年MM月dd日"];
    startDate.text = [nowDate stringFromDate:[NSDate date]];
    endDate.text = [nowDate stringFromDate:[NSDate date]];
    NSLog(@"%@",[nowDate stringFromDate:[NSDate date]]);
    NSLog(@"%@",nowDate);
    

   // lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 320, 50)];
    
   // [self.view addSubview:lab];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.actName resignFirstResponder];
    [self.actDescription resignFirstResponder];
}

- (IBAction)allDayTriggerChanged:(id)sender {
    if (allDayTrigger.isOn) {
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    }
    else {
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 hh:mm:ss"];
        [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    }
}


- (IBAction)datePickerValueChanged:(id)sender {
   NSDate * selected = [datePicker date];
    dateFormatter = [[NSDateFormatter alloc] init];
    if (allDayTrigger.isOn) {
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    }
    else [dateFormatter setDateFormat:@"yyyy年MM月dd日  hh:mm"];
    
    NSString *dateAndTime =  [dateFormatter stringFromDate:selected];
    if (startDate.isEditing) {
        startDate.text = dateAndTime;
    }
    else if (endDate.isEditing)
    {
        endDate.text =dateAndTime;
    }
    
   // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"时间提示" message:dateAndTime delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
   // [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
