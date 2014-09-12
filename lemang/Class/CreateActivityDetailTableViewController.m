//
//  CreateActivityDetailTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-11.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "CreateActivityDetailTableViewController.h"

@interface CreateActivityDetailTableViewController ()
{
    NSArray *pickerArray;
    NSArray *schoolArray;
    NSArray *areaArray;
    NSArray *collegeArray;
}

@end

@implementation CreateActivityDetailTableViewController

@synthesize actUniversity,actCollege,actArea;
@synthesize dataPicker,doneToolbar;
@synthesize actTitle,actDescription,actStartDate,actEndDate,isAllDay,actIcon;

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
    
    NSLog(@"%@ - %@ - %@ - %@ - %hhd",actTitle,actDescription,actStartDate,actEndDate,isAllDay);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
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

-(void)universityListInit
{
    schoolArray = [SchoolManager GetSchoolNameList];
    //NSLog(@"done",schoolArray);
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
}

- (void) OnSchoolChange
{
    actArea.text = @"";
    actCollege.text = @"";
    
    SchoolItem* item = [SchoolManager GetSchoolItem:actUniversity.text];
    
    areaArray = [item GetAreaList];
    collegeArray = [item GetDepartList];
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
