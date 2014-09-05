//
//  UserRegisterViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "UserRegisterViewController.h"

@interface UserRegisterViewController ()
{
    NSString *tempName;
    NSString *tempPW;
    NSString *tempPWC;
}

@end

@implementation UserRegisterViewController

@synthesize myArea,myCollege,myUniversity;
@synthesize userName,userPW,userPWConform;
@synthesize selectPicker,doneToolbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectPicker.delegate = self;
    selectPicker.dataSource = self;
    selectPicker.frame = CGRectMake(0, 480, 320, 216);
    [self universityListInit];
    [self registViewInit];
    
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
    [self.userName resignFirstResponder];
    [self.userPW resignFirstResponder];
    [self.userPWConform resignFirstResponder];
    [self.myUniversity resignFirstResponder];
    [self.myCollege resignFirstResponder];
    [self.myArea resignFirstResponder];
}

-(void)universityListInit
{
    schoolPickerArray = [NSArray arrayWithObjects:@"交通大学",@"上海大学",@"同济大学",@"复旦大学", nil];
    collegePickerArray = [NSArray arrayWithObjects:@"软件工程",@"计算机信息与技术",@"工程技术",@"文法",@"广播电视传媒",nil];
    areaPickerArray = [NSArray arrayWithObjects:@"嘉定校区",@"沪西校区",@"沪北校区",@"四平校区",nil];
}

-(void)registViewInit
{
    myUniversity.inputView = selectPicker;
    myUniversity.inputAccessoryView = doneToolbar;
    myUniversity.delegate = self;
    [myUniversity addTarget:self action:@selector(schoolOnEditing:) forControlEvents:UIControlEventEditingDidBegin];
    myCollege.inputView = selectPicker;
    myCollege.inputAccessoryView = doneToolbar;
    myCollege.delegate = self;
    [myCollege addTarget:self action:@selector(collegeOnEditing:) forControlEvents:UIControlEventEditingDidBegin];
    myArea.inputView = selectPicker;
    myArea.inputAccessoryView = doneToolbar;
    myArea.delegate = self;
    [myArea addTarget:self action:@selector(areaOnEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
   /*
    userName.delegate = self;
    userPW.delegate = self;
    userPWConform.delegate = self;
    */
}

/*
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (userName.isEditing) {
        tempName = userName.text;
        [userName endEditing:YES];
    }
    else if (userPW.isEditing) {
        tempPW = userPW.text;
        [userPW endEditing:YES];
    }
    else if (userPWConform.isEditing) {
        tempPWC = userPWConform.text;
        [userPWConform endEditing:YES];
    }
    userName.text = tempName;
    userPW.text = tempPW;
    userPWConform.text = tempPWC;
    return true;
}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)schoolOnEditing:(id)sender {
    pickerArray = schoolPickerArray;
    [selectPicker reloadAllComponents];
}

- (IBAction)collegeOnEditing:(id)sender {
    pickerArray = collegePickerArray;
    [selectPicker reloadAllComponents];
}

- (IBAction)areaOnEditing:(id)sender {
    pickerArray = areaPickerArray;
    [selectPicker reloadAllComponents];
}

- (IBAction)selectButton:(id)sender {
    if (myUniversity.isEditing) {
        [myUniversity endEditing:YES];
    }
    else if(myCollege.isEditing)
    {
        [myCollege endEditing:YES];
    }
    else if(myArea.isEditing)
    {
        [myArea endEditing:YES];
    }
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
    NSInteger row = [selectPicker selectedRowInComponent:0];
    if (myUniversity.isEditing) {
        textField = myUniversity;
    }
    else if(myCollege.isEditing)
    {
        textField = myCollege;
    }
    else if(myArea.isEditing)
    {
        textField = myArea;
    }
    textField.text = [pickerArray objectAtIndex:row];
}

-(IBAction)doRegist:(id)sender{
    [self dismissModalViewControllerAnimated:NO];
}
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
