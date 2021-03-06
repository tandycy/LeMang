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
    
    [self.pickImgButton addTarget:self action:@selector(pickImgButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
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
    schoolPickerArray = [SchoolManager GetSchoolNameList];
    //collegePickerArray = [NSArray arrayWithObjects:@"软件工程",@"计算机信息与技术",@"工程技术",@"文法",@"广播电视传媒",nil];
    //areaPickerArray = [NSArray arrayWithObjects:@"嘉定校区",@"沪西校区",@"沪北校区",@"四平校区",nil];
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
        [self OnSchoolChange];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma imagePicker

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

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    image= [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }

    UIImage *bigImage = [UserRegisterViewController imageWithImageSimple:image scaledToSize:CGSizeMake(440.0, 440.0)];
    [self saveImage:bigImage WithName:@"iconImageBig.jpg"];
    
    self.imgViewBig.image = image;
    UIImageView *buttonView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 77, 77)];
    buttonView.image = image;
    [self.pickImgButton addSubview:buttonView];
    
    [self dismissModalViewControllerAnimated:YES];

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


- (IBAction)DoRegister:(id)sender {
    _infoText.text = @"";
    
    if (userName.text.length == 0)
    {
        _infoText.text = @"请输入用户名";
        return;
    }
    
    if (userPW.text.length == 0)
    {
        _infoText.text = @"密码不能为空";
        return;
    }
    
    if (userPW.text.length < 6)
    {
        _infoText.text = @"密码长度不小于6字符";
        return;
    }
    
    if ([userPW.text compare:userPWConform.text])
    {
        _infoText.text = @"两次密码不一致";
        return;
    }
    
    if (myUniversity.text.length == 0)
    {
        _infoText.text = @"学校不能为空";
        return;
    }
    
    [self ConfirmRegister];
}

- (IBAction)OnSchoolChanged:(UITextField *)sender {
    
    [self OnSchoolChange];
}

- (void) OnSchoolChange
{
    myArea.text = @"";
    myCollege.text = @"";
    
    SchoolItem* item = [SchoolManager GetSchoolItem:myUniversity.text];
    
    areaPickerArray = [item GetAreaList];
    collegePickerArray = [item GetDepartList];
}

- (void) ConfirmRegister
{
    if ([UserManager IsUserNameExists:userName.text])
    {
        _infoText.text = @"用户名已存在";
        return;
    }
    
    NSString* postString = @"";

    postString = [postString stringByAppendingFormat:@"{\"loginName\":\"%@\",\"name\":\"%@\",", userName.text, userName.text];
    postString = [postString stringByAppendingFormat:@"\"plainPassword\":\"%@\",", userPW.text];
    
    SchoolItem* schoolItem = [SchoolManager GetSchoolItem:myUniversity.text];
    NSNumber* schoolId = [schoolItem GetId];
    if (schoolItem == nil)
    {
        _infoText.text = @"学校信息错误";
        return;
    }
    NSNumber* areaId = [schoolItem GetAreaId:myArea.text];
    if (areaId == nil)
    {
        _infoText.text = @"校区信息错误";
        return;
    }
    NSNumber* departId = [schoolItem GetDepartId:myCollege.text];
    if (departId == nil)
    {
        _infoText.text = @"学院信息错误";
        return;
    }
    
    postString = [postString stringByAppendingFormat:@"\"university\":{\"id\":%@},\"area\":{\"id\":%@},\"department\":{\"id\":%@}}", schoolId, areaId,departId];
    
    NSString* dataLength = [NSString stringWithFormat:@"%d", [postString length]];
    NSData* postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(postString);
    
    //{ "loginName": "jason", "name": "jason", "plainPassword": "test", "university": {"id": 1}, "area": {"id": 1}, "department": {"id": 1} }
    
    NSString* urlString = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    NSURL* URL = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:URL];
    
    [request setUsername:@"admin"];
    [request setPassword:@"admin"];
    
//    [request setValue:@"application/json;charset=UTF-8" forKey: @"Content-Type"];
    [request addRequestHeader:@"Content-Type" value:@"application/json;charset=UTF-8"];
    [request addRequestHeader:@"Content-Length" value:dataLength];
    
    [request setRequestMethod:@"POST"];
    [request appendPostData:postData];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response;
    
    bool registerDone = false;
    
    if (!error) {
        response = [request responseString];
        int returnCode = [request responseStatusCode];
        NSLog(@"%@ - %d",response,returnCode);
        
        if (returnCode == 201)
            registerDone = true;
    }
    
    if (registerDone)
    {
        [self UploadIconFile];
        _imgViewBig.image = [UIImage imageNamed:@"user_icon_de.png"];
        [[UserManager Instance]DoLogIn:userName.text :userPW.text];
        [self dismissModalViewControllerAnimated:NO];
    }
    else
    {
        _infoText.text = @"注册用户失败";
    }
}

- (void) UploadIconFile
{
    //
}

/*
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential;
        newCredential=[NSURLCredential credentialWithUser:@"user" password:@"user"                                              persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

#pragma mark- NSURLConnection 回调方法
- (void)connection:(NSURLConnection *)aConn didReceiveResponse:(NSURLResponse *)response

{
    // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        //NSLog(@"[email=dictionary=%@]dictionary=%@",[dictionary[/email] description]);
        
    }
    
    NSLog(@"%@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}
-(void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {
    NSLog(@"%@",[error localizedDescription]);
}
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    NSLog(@"请求完成…");
    NSError* error;
    NSData* userData = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingAllowFragments error:&error];

    // TODO: log in
    
    [self dismissModalViewControllerAnimated:NO];
}
 */

@end
