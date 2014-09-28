//
//  UserVerifyViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "UserVerifyViewController.h"

@interface UserVerifyViewController ()
{
    BOOL nameState,codeState;
    UIAlertView* endMessageView;
}

@end

@implementation UserVerifyViewController

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
    [self initView];
    self.userRealName.delegate = self;
    self.userCode.delegate = self;
    nameState=codeState=0;
}

-(void)initView
{
    [self.okButton addTarget:self action:@selector(okClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
   
}

- (void)DoAlert : (NSString*)caption: (NSString*)content
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:caption message:content delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

-(IBAction)okClick:(id)sender
{
    //ok function
    if (_userRealName.text.length == 0)
    {
        [self DoAlert:@"姓名不能为空" :@"请填写真实姓名"];
        return;
    }
    
    if (_userCode.text.length == 0)
    {
        [self DoAlert:@"学号不能为空" :@"请填写你的学号"];
        return;
    }
    
    if (!photoImg)
    {
        [self DoAlert:@"照片不能为空" :@"请选择本人真实头像照片"];
        return;
    }
    
    int uid = [[UserManager Instance]GetLocalUserId];
    
    NSString* authRequestUrl = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    authRequestUrl = [authRequestUrl stringByAppendingFormat:@"%d/authenticate", uid];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_userRealName.text forKey:@"fullName"];
    [dic setValue:_userCode.text forKey:@"code"];
    
    NSData* postData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    ASIHTTPRequest* authRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:authRequestUrl]];
    
    [authRequest addRequestHeader:@"Content-Type" value:@"application/json;charset=UTF-8"];
    [authRequest appendPostData:postData];
    [authRequest setRequestMethod:@"PUT"];
    
    [authRequest startSynchronous];
    
    NSError* error = [authRequest error];
    int returnCode = [authRequest responseStatusCode];
    
    if (!error)
    {
        NSString* fileName = [NSString stringWithFormat:@"authenticate_%d", uid];
        NSString* fileFullName = [fileName stringByAppendingString:@".jpg"];
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //获取完整路径
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *iconPath = [documentsDirectory stringByAppendingPathComponent:@"authenticate_img.jpg"];
        
        [self saveImage:photoImg WithName:@"authenticate_img.jpg"];
        
        NSString* firstPathStr = @"http://e.taoware.com:8080/quickstart/api/v1/images/authenticate/";
        firstPathStr = [firstPathStr stringByAppendingFormat:@"%d?imageName=%@.jpg", uid, fileName];
        
        NSURL* URL = [NSURL URLWithString:firstPathStr];
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
            [self DoAlert:@"传输失败" :@"网络连接错误"];
            return;
        }
        

        NSURL* uploadUrl = [NSURL URLWithString:@"http://e.taoware.com:8080/quickstart/api/v1/images/upload"];
        
        ASIFormDataRequest *uploadRequest = [ASIFormDataRequest requestWithURL:uploadUrl];
        
        [uploadRequest setRequestMethod:@"POST"];
        [uploadRequest setTimeOutSeconds:15];
        
        [uploadRequest setPostValue:pathResp forKey:@"name"];
        [uploadRequest setFile:iconPath withFileName:fileFullName andContentType:@"image/jpeg" forKey:@"file"];
        [uploadRequest buildRequestHeaders];
        [uploadRequest buildPostBody];
        
        NSDictionary* hdata = [uploadRequest requestHeaders];
        [uploadRequest startSynchronous];
        
        error = [uploadRequest error];
        int aaa = [uploadRequest responseStatusCode];
        NSString* bbb = [uploadRequest responseString];
        
        if (error)
        {
            // TODO
            [self DoAlert:@"传输失败" :@"网络连接错误"];
            NSLog(@"upload user icon fail: %d", error.code);
        }
        if (aaa == 200)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提交成功" message:@"认证信息已上传，等候审核结果" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            endMessageView = alertView;
            [alertView show];
            return;
        }
        else
        {
            // TODO
            NSLog(@"upload user icon return: %d", aaa);
        }

    }
    else
    {
        [self DoAlert:@"传输失败" :@"网络连接错误"];
    }
}

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger*)buttonIndex
{
    if ((id)alertView == (id)endMessageView)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)cancelClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnClickPhoto:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择您上传照片的方式" delegate:self cancelButtonTitle:@"取消"  destructiveButtonTitle:@"拍照上传" otherButtonTitles:@"从相册中选择", nil];
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
    photoImg= [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    [self dismissModalViewControllerAnimated:YES];
    
    [_userVerifyPhoto setImage:photoImg forState:UIControlStateNormal];
}

- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (nameState==0 && codeState == 0 ) {
        [self upAnim];
        if (self.userRealName.isEditing) {
            nameState = 1;
        }
        else if (self.userCode.isEditing)
        {
            codeState = 1;
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    nameState=codeState=0;
    [self downAnim];
    return 0;
}

-(void)upAnim
{
    NSTimeInterval animationDuration = 0.20f;
    CGRect frame = self.view.frame;
    frame.origin.y -= 150;
    //frame.size.height +=0;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}
-(void)downAnim
{
    NSTimeInterval animationDuration = 0.20f;
    CGRect frame = self.view.frame;
    frame.origin.y += 150;
    //frame.size.height -=0;
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
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
