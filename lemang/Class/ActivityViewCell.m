//
//  ActivityViewCell.m
//  LeMang
//
//  Created by LZ on 8/25/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "ActivityViewCell.h"

@implementation ActivityViewCell
@synthesize activityIconImg;
@synthesize linkedActivity;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) SetIconImgUrl:(NSURL *)url
{
    /*
    if (connection != nil)
    {
        [connection release];
    }
    
    if (imgData != nil)
    {
        [imgData release];
    }
     */
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response{
    //可以在显示图片前先用本地的一个loading.gif来占位。
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:@"loading.gif"];
    [activityIconImg setImage:img];
    imgData = [[NSMutableData alloc] init];
    //保存接收到的响应对象，以便响应完毕后的状态。
    _response = response;
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    //_data为NSMutableData类型的私有属性，用于保存从网络上接收到的数据。
    //也可以从此委托中获取到图片加载的进度。
    [imgData appendData:data];
    NSLog(@"%lld%%", data.length/_response.expectedContentLength * 100);
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error{
    //请求异常，在此可以进行出错后的操作，如给UIImageView设置一张默认的图片等。
}
- (void)connectionDidFinishLoading:(NSURLConnection*)connection{
    //加载成功，在此的加载成功并不代表图片加载成功，需要判断HTTP返回状态。
    NSHTTPURLResponse*response=(NSHTTPURLResponse*)_response;
    if(response.statusCode == 200){
        //请求成功
        UIImage *img=[UIImage imageWithData:imgData];
        [activityIconImg setImage:img];
        linkedActivity.cachedImg = img;
    }
}
@end