//
//  CreateActivityCommentViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-13.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "CreateActivityCommentViewController.h"
#import "ActivityDetailViewController.h"
#import "Constants.h"

@interface CreateActivityCommentViewController ()
{
    UILabel *commentHolder;
    NSString *commentString;
    int rate;
    UIImage *rateStarOn;
    UIImage *rateStarOff;
}

@end

@implementation CreateActivityCommentViewController

@synthesize commentDetail;
@synthesize rate1,rate2,rate3,rate4,rate5;
@synthesize addPhoto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        linkedActivity = nil;
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
    // Do any additional setup after loading the view.
    rateStarOn = [UIImage imageNamed:@"rate_star_on.png"];
    rateStarOff = [UIImage imageNamed:@"rate_star_off.png"];
    
    [self initView];
    [self initRate];
    
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
}

- (void)SetActivity:(Activity *)activity
{
    linkedActivity = activity;
    //NSLog(@"comment create set activity: %@", linkedActivity.activityId);
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [commentDetail resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView
{
    commentDetail.delegate = self;
    commentHolder = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, commentDetail.frame.size.width, 20)];
    commentHolder.font = [UIFont fontWithName:defaultFont  size:15];
    commentHolder.text = @"写评论，谈谈你的感想...";
    commentHolder.enabled = NO;//lable必须设置为不可用
    commentHolder.backgroundColor = [UIColor clearColor];
    [commentDetail addSubview:commentHolder];
    
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc]init];
    okButton.title = @"ok";
    self.navigationItem.rightBarButtonItem = okButton;
    okButton.target = self;
    okButton.action = @selector(commentOk:);
    
    [addPhoto addTarget:self action:@selector(addPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.photo.image = [UIImage imageNamed:@"doge2.jpg"];
    
    UIButton *delPhoto = [[UIButton alloc]initWithFrame:CGRectMake(67, 0, 10, 10)];
    [delPhoto setBackgroundColor:[UIColor blueColor]];
    [delPhoto addTarget:self action:@selector(delPhotoClick:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.photo setUserInteractionEnabled:YES];
    [self.photo addSubview:delPhoto];
    
}

-(IBAction)delPhotoClick:(id)sender
{
    NSLog(@"del Doge!!!!");
    [self.photo removeFromSuperview];
}

-(void)initRate
{
    rate = 0;
    [rate1 addTarget:self action:@selector(rate1Clcik:) forControlEvents:UIControlEventTouchUpInside];
    [rate2 addTarget:self action:@selector(rate2Clcik:) forControlEvents:UIControlEventTouchUpInside];
    [rate3 addTarget:self action:@selector(rate3Clcik:) forControlEvents:UIControlEventTouchUpInside];
    [rate4 addTarget:self action:@selector(rate4Clcik:) forControlEvents:UIControlEventTouchUpInside];
    [rate5 addTarget:self action:@selector(rate5Clcik:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)rate1Clcik:(id)sender
{
    rate = 1;
    [rate1 setImage:rateStarOn forState:UIControlStateNormal];
    [rate2 setImage:rateStarOff forState:UIControlStateNormal];
    [rate3 setImage:rateStarOff forState:UIControlStateNormal];
    [rate4 setImage:rateStarOff forState:UIControlStateNormal];
    [rate5 setImage:rateStarOff forState:UIControlStateNormal];
}
-(IBAction)rate2Clcik:(id)sender
{
    rate = 2;
    [rate1 setImage:rateStarOn forState:UIControlStateNormal];
    [rate2 setImage:rateStarOn forState:UIControlStateNormal];
    [rate3 setImage:rateStarOff forState:UIControlStateNormal];
    [rate4 setImage:rateStarOff forState:UIControlStateNormal];
    [rate5 setImage:rateStarOff forState:UIControlStateNormal];
}
-(IBAction)rate3Clcik:(id)sender
{
    rate = 3;
    [rate1 setImage:rateStarOn forState:UIControlStateNormal];
    [rate2 setImage:rateStarOn forState:UIControlStateNormal];
    [rate3 setImage:rateStarOn forState:UIControlStateNormal];
    [rate4 setImage:rateStarOff forState:UIControlStateNormal];
    [rate5 setImage:rateStarOff forState:UIControlStateNormal];
}
-(IBAction)rate4Clcik:(id)sender
{
    rate = 4;
    [rate1 setImage:rateStarOn forState:UIControlStateNormal];
    [rate2 setImage:rateStarOn forState:UIControlStateNormal];
    [rate3 setImage:rateStarOn forState:UIControlStateNormal];
    [rate4 setImage:rateStarOn forState:UIControlStateNormal];
    [rate5 setImage:rateStarOff forState:UIControlStateNormal];
}
-(IBAction)rate5Clcik:(id)sender
{
    rate = 5;
    [rate1 setImage:rateStarOn forState:UIControlStateNormal];
    [rate2 setImage:rateStarOn forState:UIControlStateNormal];
    [rate3 setImage:rateStarOn forState:UIControlStateNormal];
    [rate4 setImage:rateStarOn forState:UIControlStateNormal];
    [rate5 setImage:rateStarOn forState:UIControlStateNormal];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        commentHolder.text = @"写评论，谈谈你的感想...";
    }else{
        commentHolder.text = @"";
    }
    commentString =  textView.text;
}

-(IBAction)addPhotoClick:(id)sender
{
    //add photo
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择您上传照片的方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照上传" otherButtonTitles:@"从相册中选择", nil];
    [actionSheet showInView:self.view];
    
}

-(IBAction)commentOk:(id)sender
{
    if (linkedActivity == nil)
        return;
    
    if (![UserManager IsInitSuccess])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户未登录" message:@"登陆后才能执行该操作。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        return;
    }
    
    if (rate == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未评分" message:@"请输入评分星级" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        return;
    }
    
    if (commentDetail.text.length < 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评论内容为空" message:@"评论内容不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        return;
    }
    
    //post comment information
    NSNumber* actId = linkedActivity.activityId;
    int userId = [[UserManager Instance] GetLocalUserId];
    
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *t2=[nsdf2 stringFromDate:[NSDate date]];
    
    // {"activity":{"id":1},"title":"健康生活","content":"从今天开始","createdBy":{"id":2},"createdDate":"2014-08-19 10:00:01"}
    
    NSString* postContent = @"{\"activity\":{\"id\":";
    postContent = [postContent stringByAppendingFormat:@"%@},\"title\":\"", actId];
    postContent = [postContent stringByAppendingFormat:@"%@\",\"content\":\"", [UserManager UserName]];
    postContent = [postContent stringByAppendingFormat:@"%@\",\"createdBy\":{\"id\":", commentDetail.text];
    postContent = [postContent stringByAppendingFormat:@"%d},\"createdDate\":\"", userId];
    postContent = [postContent stringByAppendingFormat:@"%@\",\"rating\":%d}", t2, rate];
    
    NSLog(@"comment post: %@",postContent);
    
    NSString* dataLength = [NSString stringWithFormat:@"%d", [postContent length]];
    NSData* postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* urlStr = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/api/v1/activity/%@/comment", actId];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [request setUsername:[UserManager UserName]];
    [request setPassword:[UserManager UserPW]];
    
    //    [request setValue:@"application/json;charset=UTF-8" forKey: @"Content-Type"];
    [request addRequestHeader:@"Content-Type" value:@"application/json;charset=UTF-8"];
    [request addRequestHeader:@"Content-Length" value:dataLength];
    
    [request setRequestMethod:@"POST"];
    [request appendPostData:postData];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error)
    {
        int returncode = [request responseStatusCode];
        //NSString* response = [request responseString];
        
        if (returncode == 201)
        {            
            [self.navigationController popViewControllerAnimated:true];
            
            if ([owner isKindOfClass:[ActivityDetailViewController class]])
               [(ActivityDetailViewController*)owner OnCommentSuccess];
        }
    }
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
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    UIImage *theImage = [CreateActivityCommentViewController imageWithImageSimple:image scaledToSize:CGSizeMake(120.0, 120.0)];
    UIImage *midImage = [CreateActivityCommentViewController imageWithImageSimple:image scaledToSize:CGSizeMake(210.0, 210.0)];
    UIImage *bigImage = [CreateActivityCommentViewController imageWithImageSimple:image scaledToSize:CGSizeMake(440.0, 440.0)];
    //[theImage retain];
    [self saveImage:theImage WithName:@"salesImageSmall.jpg"];
    [self saveImage:midImage WithName:@"salesImageMid.jpg"];
    [self saveImage:bigImage WithName:@"salesImageBig.jpg"];
    
    self.imgViewBig.image = image;
    UIImageView *buttonView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 77, 77)];
    buttonView.image = image;
    [self.addPhoto addSubview:buttonView];
    
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

@end
