//
//  CreateOrganizationTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-21.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "CreateOrganizationTableViewController.h"
#import "Constants.h"

@interface CreateOrganizationTableViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    schoolPickerArray = [NSArray arrayWithObjects:@"交通大学",@"上海大学",@"同济大学",@"复旦大学", nil];
    collegePickerArray = [NSArray arrayWithObjects:@"软件工程",@"计算机信息与技术",@"工程技术",@"文法",@"广播电视传媒",nil];
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
    //image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    image= [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    UIImage *theImage = [CreateOrganizationTableViewController imageWithImageSimple:image scaledToSize:CGSizeMake(120.0, 120.0)];
    UIImage *midImage = [CreateOrganizationTableViewController imageWithImageSimple:image scaledToSize:CGSizeMake(210.0, 210.0)];
    UIImage *bigImage = [CreateOrganizationTableViewController imageWithImageSimple:image scaledToSize:CGSizeMake(440.0, 440.0)];
    //[theImage retain];
    [self saveImage:theImage WithName:@"salesImageSmall.jpg"];
    [self saveImage:midImage WithName:@"salesImageMid.jpg"];
    [self saveImage:bigImage WithName:@"salesImageBig.jpg"];
    
    self.imgViewBig.image = image;
    UIImageView *buttonView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 77, 77)];
    buttonView.image = image;
    [self.pickImgButton addSubview:buttonView];
    
    [self dismissModalViewControllerAnimated:YES];
    //[self refreshData];
    //[picker release];
}

- (void)upLoadSalesBigImage:(NSString *)bigImage MidImage:(NSString *)midImage SmallImage:(NSString *)smallImage
{
    /* NSURL *url = [NSURL URLWithString:UPLOAD_SERVER_URL];
     ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
     [request setPostValue:@"photo" forKey:@"type"];
     [request setFile:bigImage forKey:@"file_pic_big"];
     [request buildPostBody];
     [request setDelegate:self];
     [request setTimeOutSeconds:TIME_OUT_SECONDS];
     [request startAsynchronous];
     */
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
