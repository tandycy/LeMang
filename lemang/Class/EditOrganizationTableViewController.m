//
//  EditOrganizationTableViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-27.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "EditOrganizationTableViewController.h"
#import "EditOrganizationDetailTableViewController.h"
#import "SchoolManager.h"
#import "Constants.h"

@interface EditOrganizationTableViewController ()
{
    UILabel *lab;
    UILabel *descriptionHolder;
    UILabel *nameHolder;
    
    NSString* iconStr;
}

@end

@implementation EditOrganizationTableViewController

@synthesize orgDescription,orgName,orgIcon,orgShortName;

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
    
    localNewIcon = nil;
    [_CancelPhotoButton setHidden:true];
    
    [self initView];
    
    [UserManager RefreshTagData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)initView
{
    orgShortName.delegate = self;
    orgName.delegate = self;
    orgDescription.delegate = self;
    
    nameHolder = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, orgDescription.frame.size.width, 20)];
    nameHolder.font = [UIFont fontWithName:defaultFont  size:15];
    nameHolder.text = @"请输入活动标题...";
    nameHolder.enabled = NO;//lable必须设置为不可用
    nameHolder.backgroundColor = [UIColor clearColor];
    [orgName addSubview:nameHolder];
    
    descriptionHolder = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, orgDescription.frame.size.width, 20)];
    descriptionHolder.font = [UIFont fontWithName:defaultFont  size:15];
    descriptionHolder.text = @"请输入活动描述...";
    descriptionHolder.enabled = NO;//lable必须设置为不可用
    descriptionHolder.backgroundColor = [UIColor clearColor];
    [orgDescription addSubview:descriptionHolder];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //date.inputAccessoryView = doneToolbar;
    //date.delegate = self;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    localNewIcon = nil;
    [_CancelPhotoButton setHidden:true];
    
    NSURL* iconUrl = [NSURL URLWithString:iconStr];
    [orgIcon LoadFromUrl:iconUrl :[UIImage imageNamed:@"default_Icon"] :@selector(AfterIconLoad:) :self];
    
    [self InitOrgData];
    [UserManager RefreshTagData];
}

- (void) SetOrganizationData:(NSDictionary *)data
{
    orgData = [NSMutableDictionary dictionaryWithDictionary:data];
}

- (void)SetOrganizationDataFromId:(NSNumber *)orgId
{
    NSString* urlStr = @"http://e.taoware.com:8080/quickstart/api/v1/association";
    urlStr = [urlStr stringByAppendingFormat:@"/%@", orgId];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [request setUsername:@"admin"];
    [request setPassword:@"admin"];
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error)
    {
        orgData = [[NSMutableDictionary alloc]init];
        
        NSDictionary* fullData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil];
        
        iconStr = [UserManager filtStr:fullData[@"iconUrl"] :@""];
        if (iconStr.length > 0)
        {
            NSString* tempstr = @"http://e.taoware.com:8080/quickstart/resources/g/";
            tempstr = [tempstr stringByAppendingFormat:@"%@/", orgId];
            tempstr = [tempstr stringByAppendingString:iconStr];
            iconStr = tempstr;
        }
        
        // Reset id
        [orgData setValue:orgId forKey:@"id"];
        
        // Page1 part
        NSString* title = [UserManager filtStr: fullData[@"name"] : @""];
        [orgData setValue:title forKey:@"name"];
        NSString* description = [UserManager filtStr:fullData[@"description"] :@""];
        [orgData setValue:description forKey:@"description"];
        NSString* shortName = [UserManager filtStr: fullData[@"shortName"] : @""];
        [orgData setValue:shortName forKey:@"shortName"];
        
        // Page2 part
        NSString* groupType = fullData[@"type"];
        [orgData setValue:groupType forKey:@"type"];
        
        NSDictionary* school = fullData[@"university"];
        if ([school isKindOfClass:[NSDictionary class]])
        {
            NSString* name = school[@"name"];
            [orgData setValue:name forKey:@"university"];
        }
        NSDictionary* area = fullData[@"area"];
        if ([area isKindOfClass:[NSDictionary class]])
        {
            NSString* name = area[@"name"];
            [orgData setValue:name forKey:@"area"];
        }
        NSDictionary* department = fullData[@"department"];
        if ([department isKindOfClass:[NSDictionary class]])
        {
            NSString* name = department[@"name"];
            [orgData setValue:name forKey:@"department"];
        }
        
        NSString* address = [UserManager filtStr:fullData[@"address"] :@""];
        [orgData setValue:address forKey:@"address"];
        NSString* contact = [UserManager filtStr:fullData[@"contact"] :@""];
        [orgData setValue:contact forKey:@"contact"];
        
        //NSNumber* peopleLimit = fullData[@"peopleLimit"];
        //[orgData setValue:peopleLimit forKey:@"peopleLimit"];
        //NSString* regionLimit = [UserManager filtStr:fullData[@"regionLimit"] :@""];
        //[orgData setValue:regionLimit forKey:@"regionLimit"];
        
        NSString* otherLimit = [UserManager filtStr:fullData[@"otherLimit"] :@""];
        [orgData setValue:otherLimit forKey:@"otherLimit"];
        
        NSString* tags = [UserManager filtStr:fullData[@"tags"] :@""];
        [orgData setValue:tags forKey:@"tags"];
        
        NSString* createTime = fullData[@"createdDate"];
        [orgData setValue:createTime forKey:@"createdDate"];
        
        NSDictionary* created = fullData[@"createdBy"];
        NSNumber* cid = [NSNumber numberWithInt:[[UserManager Instance]GetLocalUserId]];
        if ([created isKindOfClass:[NSDictionary class]])
        {
            NSNumber* oldcid = created[@"id"];
            if ([oldcid isKindOfClass:[NSNumber class]])
                cid = oldcid;
        }
        NSMutableDictionary* cdic = [[NSMutableDictionary alloc]init];
        [cdic setValue:cid forKey:@"id"];
        [orgData setValue:cdic forKey:@"createdBy"];
        
    }
}

- (void) InitOrgData
{
    if (orgData == nil)
    {
        orgData = [[NSMutableDictionary alloc]init];
    }
    else
    {
        orgName.text = orgData[@"name"];
        orgDescription.text = orgData[@"description"];
        orgShortName.text = orgData[@"shortName"];
        
        if (orgName.text.length > 0)
            nameHolder.text = @"";
        if (orgDescription.text.length > 0)
            descriptionHolder.text = @"";
    }
}

- (void) UpdateOrgData
{
    [orgData setValue:orgName.text forKey:@"name"];
    [orgData setValue:orgDescription.text forKey:@"description"];
    [orgData setValue:orgShortName.text forKey:@"shortName"];
}

- (void)DoAlert : (NSString*)caption: (NSString*)content
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:caption message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alertView show];
}

- (BOOL) CheckActivityData
{
    if (orgName.text.length == 0)
    {
        [self DoAlert:@"标题不能为空":@""];
        return false;
    }
    if (orgDescription.text.length == 0)
    {
        [self DoAlert:@"描述不能为空":@""];
        return false;
    }
    if (orgShortName.text.length == 0)
    {
        [self DoAlert:@"简称不能为空":@""];
        return false;
    }
    
    return true;
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.orgName resignFirstResponder];
    [self.orgDescription resignFirstResponder];
    [self.orgShortName resignFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == orgName) {
        if (textView.text.length == 0) {
            nameHolder.text = @"请输入组织名称...";
        }else{
            nameHolder.text = @"";
        }
    }
    else if (textView == orgDescription)
    {
        if (textView.text.length == 0) {
            descriptionHolder.text = @"请输入组织介绍...";
        }else{
            descriptionHolder.text = @"";
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (textView == orgName) {
        if ([text isEqualToString:@"\n"]) {
            [orgName resignFirstResponder];
            return NO;
        }
    }
    return YES;
    
}

- (IBAction)nextButton:(id)sender {
    
    if (![self CheckActivityData])
        return;
    
    [self UpdateOrgData];

    EditOrganizationDetailTableViewController *EditOrgDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditOrganizationDetailTableViewController"];
    EditOrgDetailVC.navigationItem.title = @"详细页面";
    [EditOrgDetailVC SetOrganizationData:orgData];
    [EditOrgDetailVC SetIconData:localNewIcon];
    //
    [self.navigationController pushViewController:EditOrgDetailVC animated:YES];
    
}


- (IBAction)OnChangePhoto:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择您上传照片的方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照上传" otherButtonTitles:@"从相册中选择", nil];
    [actionSheet showInView:self.view];
    
}

- (IBAction)OnCancelPhoto:(id)sender {
    
    localNewIcon = nil;
    
    if (originIcon == nil)
        [orgIcon setImage:[UIImage imageNamed:@"default_Icon"] forState:UIControlStateNormal];
    else
        [orgIcon setImage:originIcon forState:UIControlStateNormal];
    
    [_CancelPhotoButton setHidden:true];
}

- (void) AfterIconLoad : (UIImage*)loadImg
{
    originIcon = loadImg;
    
    if (localNewIcon != nil)
        [orgIcon setImage:localNewIcon forState:UIControlStateNormal];
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
    
    localNewIcon = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [orgIcon setImage:localNewIcon forState:UIControlStateNormal];
    [_CancelPhotoButton setHidden:false];
    
     
    [self dismissModalViewControllerAnimated:YES];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [SchoolManager InitSchoolList];
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
