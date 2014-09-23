//
//  UserInfoTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "UserInfoTableViewController.h"
#import "EditUserInfoViewController.h"

@interface UserInfoTableViewController ()

@end

@implementation UserInfoTableViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [self UpdateUserDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) UpdateContentDisplay
{
    [UserManager RefreshUserData];
    [self UpdateUserDetail];
}

- (void) UpdateUserDetail
{
    [self clearUserData];
    
    if (![UserManager IsInitSuccess])
        return;
    
    userId = [NSNumber numberWithInt:[[UserManager Instance] GetLocalUserId]];

    NSDictionary* userData = [UserManager LocalUserData];
    if (userData == nil)
        return;
    
    _userName.text = @"未认证用户";
    _schoolName.text = [UserManager filtStr:userData[@"university"][@"name"]];
    _departName.text =[UserManager filtStr:userData[@"department"][@"name"]];
    
    NSDictionary* profileData = userData[@"profile"];
    
    if ([profileData isKindOfClass:[NSDictionary class]])
    {
        _userName.text = [UserManager filtStr:profileData[@"fullName"] : @"未认证用户"];
        _userNickName.text = [UserManager filtStr:profileData[@"nickName"] : @""];
        _userSign.text = [UserManager filtStr:profileData[@"signature"] : @""];
        _schoolNumber.text = [UserManager filtStr:profileData[@"code"] : @"未认证用户"];
        
        NSString* urlStr = profileData[@"iconUrl"];
        urlStr = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/resources%@", urlStr];
        [_userIcon LoadFromUrl:[NSURL URLWithString:urlStr]:[UserManager DefaultIcon]];
    }
    
    NSDictionary* contactData = userData[@"contacts"];
    
    if ([contactData isKindOfClass:[NSDictionary class]])
    {
        _phoneNumber.text = [UserManager filtStr:contactData[@"CELL"] : @"未绑定手机"];
        if (_phoneNumber.text.length == 0)
            _phoneNumber.text = @"未绑定手机";
        _qqNumber.text = [UserManager filtStr:contactData[@"QQ"] : @""];
        _wechatId.text = [UserManager filtStr:contactData[@"WECHAT"] : @""];
    }
}

- (void) clearUserData
{
    _userName.text = @"";
    _userNickName.text = @"";
    _userSign.text = @"";
    _schoolNumber.text = @"";
    _schoolName.text = @"";
    _departName.text = @"";
    _phoneNumber.text = @"";
    _qqNumber.text = @"";
    _wechatId.text = @"";
    
    _userIcon.image = [UIImage imageNamed:@"user_icon_de.png"];
}


- (IBAction)OnChangeIcon:(id)sender
{
    [self UploadIconImage];
    
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
    
    UIImage *bigImage = [UserInfoTableViewController imageWithImageSimple:image scaledToSize:CGSizeMake(440.0, 440.0)];
    
    //if ([UserManager IsInitSuccess])
    //{
        int userId = [[UserManager Instance] GetLocalUserId];
        NSString* fileName = [NSString stringWithFormat:@"userIcon_%d", userId];
    //}
    
    [self saveImage:bigImage WithName:@"iconImageBig.jpg"];
    
    self.userIcon.image = image;
    UIImageView *buttonView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 77, 77)];
    buttonView.image = image;
//    [self.pickImgButton addSubview:buttonView];
    
    [self dismissModalViewControllerAnimated:YES];
    
    [self UploadIconImage];
}

- (void)UploadIconImage
{
    if (![UserManager IsInitSuccess])
        return;
    int userId = [[UserManager Instance] GetLocalUserId];
    
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    if (!imageData)
        return;
    NSString* dataLength = [NSString stringWithFormat:@"%d",imageData.length];
    
    NSString* fileName = [NSString stringWithFormat:@"userIcon_%d", userId];
    NSString* fileFullName = [fileName stringByAppendingString:@".jpg"];
    NSString* firstPath = @"http://e.taoware.com:8080/quickstart/api/v1/images/profile/";
    firstPath = [firstPath stringByAppendingFormat:@"%d?imageName=%@.jpg", userId, fileName];
    
    NSURL* URL = [NSURL URLWithString:firstPath];
    ASIHTTPRequest *putRequest = [ASIHTTPRequest requestWithURL:URL];
    [putRequest setUsername:[UserManager UserName]];
    [putRequest setPassword:[UserManager UserPW]];
    
    [putRequest setRequestMethod:@"PUT"];
    [putRequest startSynchronous];
    
    NSError *error = [putRequest error];
    NSString* pathResp;
    
    if (!error)
    {
        pathResp = [putRequest responseString];
    }
    else
    {
        // TODO
        return;
    }
    
    NSString* secondPath = @"http://e.taoware.com:8080/quickstart/resources";
    secondPath = [secondPath stringByAppendingString:pathResp];
    NSLog(@"path %@", secondPath);
    
    NSURL* uploadUrl = [NSURL URLWithString:@"http://e.taoware.com:8080/quickstart/api/v1/images/upload"];
    
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *iconPath = [documentsDirectory stringByAppendingPathComponent:@"iconImageBig.jpg"];
    
 
    //[ASIHTTPRequest clearSession];
    ASIFormDataRequest *uploadRequest = [ASIFormDataRequest requestWithURL:uploadUrl];
   
    [uploadRequest setRequestMethod:@"POST"];
    [uploadRequest setTimeOutSeconds:15];
    
    [uploadRequest setPostValue:pathResp forKey:@"name"];
    [uploadRequest setFile:iconPath withFileName:fileFullName andContentType:@"image/jpeg" forKey:@"file"];
    [uploadRequest buildRequestHeaders];
    [uploadRequest buildPostBody];
   
    NSDictionary* hdata = [uploadRequest requestHeaders];
    NSLog(@"header: %@", hdata);
    
    //[uploadRequest setDelegate:self];
    //[uploadRequest startAsynchronous];
    
    [uploadRequest startSynchronous];
    
    error = [uploadRequest error];
    int aaa = [uploadRequest responseStatusCode];
    NSString* bbb = [uploadRequest responseString];
    
    if (error)
    {
        // TODO
        NSLog(@"upload user icon fail: %d", error.code);
    }
    if (aaa == 200)
    {
        // TODO: success
    }
    else
    {
        // TODO
        NSLog(@"upload user icon return: %d", aaa);
    }
   
}

- (void)requestFinished:(ASIHTTPRequest*)request
{
    NSString* resp = [request responseString];

    NSLog(@"done %@", [request responseStatusMessage]);
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
    NSError* error = [request error];
    NSString* resp = [request responseString];
    NSLog(@"resp %@", resp);
    NSLog(@"Upload file: %d - %d",error.code, [request responseStatusCode]);
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EditUserInfoViewController *EditUserInfoVC = [[EditUserInfoViewController alloc]init];
    [EditUserInfoVC SetOwner:self];
    
    if (indexPath.section==0) {
        NSDictionary* profileData = [UserManager LocalUserData][@"profile"];
        [EditUserInfoVC SetOriginData:profileData];
        switch (indexPath.row) {
            case 1:
                EditUserInfoVC.navigationItem.title = @"修改昵称";
                [EditUserInfoVC SetEditProfile:@"nickName" userId:userId defaultValue:_userNickName.text];
                [self.navigationController pushViewController:EditUserInfoVC animated:YES];
                break;
            case 2:
                EditUserInfoVC.navigationItem.title = @"修改签名";
                [EditUserInfoVC SetEditProfile:@"signature" userId:userId defaultValue:_userSign.text];
                [self.navigationController pushViewController:EditUserInfoVC animated:YES];
                break;
            default:
                break;
        }
    }
    else if(indexPath.section==1)
    {
        NSDictionary* contactData = [UserManager LocalUserData][@"contacts"];
        [EditUserInfoVC SetOriginData:contactData];
        switch (indexPath.row) {
            case 1:
                EditUserInfoVC.navigationItem.title = @"修改QQ号";
                [EditUserInfoVC SetEditContact:@"QQ" userId:userId defaultValue:_qqNumber.text];
                [self.navigationController pushViewController:EditUserInfoVC animated:YES];
                break;
            case 2:
                EditUserInfoVC.navigationItem.title = @"修改微信号";
                [EditUserInfoVC SetEditContact:@"WECHAT" userId:userId defaultValue:_wechatId.text];
                [self.navigationController pushViewController:EditUserInfoVC animated:YES];
                break;
            default:
                break;
        }
    }
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
