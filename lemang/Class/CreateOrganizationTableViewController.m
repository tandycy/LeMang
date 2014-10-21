//
//  CreateOrganizationTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-21.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "OrganizationTableViewController.h"
#import "CreateOrganizationTableViewController.h"
#import "Constants.h"

@interface CreateOrganizationTableViewController ()
{
    NSArray* tagButtonArray;
}

@end

@implementation CreateOrganizationTableViewController

@synthesize selectPicker;
@synthesize schoolTextField,collegeTextField,areaTextField;
@synthesize doneToolbar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)SetOwner:(id)_owner
{
    owner = _owner;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SchoolManager InitSchoolList];
    [self initTag];
    
    schoolPickerArray = [SchoolManager GetSchoolNameList];
    collegePickerArray = [[NSArray alloc]init];
    areaPickerArray = [[NSArray alloc]init];
    
    schoolTextField.inputView = selectPicker;
    schoolTextField.inputAccessoryView = doneToolbar;
    schoolTextField.delegate = self;
    [schoolTextField addTarget:self action:@selector(schoolOnEditing:) forControlEvents:UIControlEventEditingDidBegin];
    collegeTextField.inputView = selectPicker;
    collegeTextField.inputAccessoryView = doneToolbar;
    collegeTextField.delegate = self;
    [collegeTextField addTarget:self action:@selector(collegeOnEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    areaTextField.inputAccessoryView = doneToolbar;
    areaTextField.inputView = selectPicker;
    areaTextField.delegate = self;
    [areaTextField addTarget:self action:@selector(areaOnEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    [collegeTextField setEnabled:FALSE];
    [areaTextField setEnabled:FALSE];
    
    selectPicker.delegate = self;
    selectPicker.dataSource = self;
    selectPicker.frame = CGRectMake(0, 480, 320, 216);
    
    [self.pickImgButton addTarget:self action:@selector(pickImgButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc]init];
    okButton.title = @"提交";
    self.navigationItem.rightBarButtonItem = okButton;
    okButton.target = self;
    okButton.action = @selector(commitOk:);

}

- (void)DoAlert : (NSString*)caption: (NSString*)content
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:caption message:content delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

-(BOOL)CheckOrgData
{
    if (_orgName.text.length == 0)
    {
        [self DoAlert:@"社群名不能为空":@""];
        return false;
    }
    if (_orgDescription.text.length == 0)
    {
        [self DoAlert:@"描述不能为空":@""];
        return false;
    }
    if (schoolTextField.text.length == 0)
    {
        [self DoAlert:@"学校不能为空":@""];
        return false;
    }
    if (areaTextField.text.length == 0)
    {
        [self DoAlert:@"校区不能为空":@""];
        return false;
    }
    if (collegeTextField.text.length == 0)
    {
        [self DoAlert:@"院系不能为空":@""];
        return false;
    }
    return true;
}

-(IBAction)commitOk:(id)sender
{
    if (![self CheckOrgData])
        return;
    
    NSMutableDictionary* orgData = [[NSMutableDictionary alloc]init];
    
    NSNumber* uid = [[UserManager Instance]GetLocalUserId];
    NSMutableDictionary* uidDic = [[NSMutableDictionary alloc]init];
    [uidDic setValue:uid forKey:@"id"];
    [orgData setValue:uidDic forKey:@"createdBy"];
    
    [orgData setValue:_orgName.text forKey:@"name"];
    [orgData setValue:_orgDescription.text forKey:@"description"];

    NSString* schoolName = schoolTextField.text;
    SchoolItem* school = [SchoolManager GetSchoolItem:schoolName];
    if (school != Nil)
    {
        NSNumber* sid = [school GetId];
        //NSString* schoolData = [NSString stringWithFormat:@"{\"id\":%@}",sid];
        NSMutableDictionary* schoolDic = [[NSMutableDictionary alloc]init];
        [schoolDic setValue:sid forKey:@"id"];
        [orgData setObject:schoolDic forKey:@"university"];
        
        NSNumber* areaId = [school GetAreaId:areaTextField.text];
        if (!areaId)
            [orgData removeObjectForKey:@"area"];
        else
        {
            //NSString* areaData = [NSString stringWithFormat:@"{\"id\":%@}",areaId];
            NSMutableDictionary* areaDic = [[NSMutableDictionary alloc]init];
            [areaDic setValue:areaId forKey:@"id"];
            [orgData setObject:areaDic forKey:@"area"];
        }
        
        NSNumber* departId = [school GetDepartId:collegeTextField.text];
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

    
    NSDateFormatter* nowDate = [[NSDateFormatter alloc]init];
    [nowDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* createDataText = [nowDate stringFromDate:[NSDate date]];
    [orgData setValue:createDataText forKey:@"createdDate"];

    
    NSData* postData = [NSJSONSerialization dataWithJSONObject:orgData options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"true\"" withString:@"true"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"false\"" withString:@"false"];
    
    //NSLog(@"%@", jsonString);
    
    NSString* orgUrlStr = @"http://e.taoware.com:8080/quickstart/api/v1/association";
    ASIHTTPRequest* createRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:orgUrlStr]];
    
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
        if (owner != nil && [owner isKindOfClass:[OrganizationTableViewController class]])
        {
            [(OrganizationTableViewController*)owner OnCreateDone];
            [self.navigationController popViewControllerAnimated:true];
        }
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.orgName resignFirstResponder];
    [self.orgDescription resignFirstResponder];
}


- (IBAction)pickImgButtonClicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择您上传照片的方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照上传" otherButtonTitles:@"从相册中选择", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%i", buttonIndex);
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    switch (buttonIndex) {
        case 0: {
            imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imagePicker.allowsEditing = YES;
            
            [self presentModalViewController:imagePicker animated:YES];
            break;
        }
        case 1: {
            imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imagePicker.allowsEditing = YES;
            
            [self presentModalViewController:imagePicker animated:YES];
            break;
        }
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectButton:(id)sender {
    if (schoolTextField.isEditing) {
        [schoolTextField endEditing:YES];
        [self OnSchoolChange];
    }
    else if(collegeTextField.isEditing)
    {
        [collegeTextField endEditing:YES];
    }
    else if(areaTextField.isEditing)
    {
        [areaTextField endEditing:YES];
    }
}

- (void)OnSchoolChange
{
    areaTextField.text = @"";
    collegeTextField.text = @"";
    
    SchoolItem* item = [SchoolManager GetSchoolItem:schoolTextField.text];
    
    areaPickerArray = [item GetAreaList];
    collegePickerArray = [item GetDepartList];
    
    if (areaPickerArray.count > 0)
        [areaTextField setEnabled:true];
    else
        [areaTextField setEnabled:FALSE];
    
    if (collegePickerArray.count > 0)
        [collegeTextField setEnabled:true];
    else
        [collegeTextField setEnabled:FALSE];
    
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
    if (schoolTextField.isEditing) {
        textField = schoolTextField;
    }
    else if(collegeTextField.isEditing)
    {
        textField = collegeTextField;
    }
    else if(areaTextField.isEditing)
    {
        textField = areaTextField;
    }
    textField.text = [pickerArray objectAtIndex:row];
}

-(void)initTag
{
    tagButtonArray = [[NSArray alloc]initWithObjects:_tag1,_tag2,_tag3,_tag4,_tag5,_tag6,_tag7,_tag8,nil];
    
    for (UIButton* item in tagButtonArray)
    {
        item.selected = false;
        
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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

#pragma PickImage
/*
- (IBAction)OnClickPickImage:(id)sender {
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    
    [self presentModalViewController:imagePicker animated:YES];
}

- (IBAction)OnClickPickCamera:(id)sender {
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    
    [self presentModalViewController:imagePicker animated:YES];
}
*/
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image= [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    self.imgViewBig.image = image;
    
    [self dismissModalViewControllerAnimated:YES];
}

- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
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

@end
