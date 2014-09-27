//
//  EditOrganizationDetailTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-27.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "EditOrganizationDetailTableViewController.h"
#import "SchoolManager.h"

@interface EditOrganizationDetailTableViewController ()
{
    NSArray *pickerArray;
    NSArray *schoolArray;
    NSArray *areaArray;
    NSArray *collegeArray;
    
    NSArray* tagButtonArray;
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
