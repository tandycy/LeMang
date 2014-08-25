//
//  ActivityViewCell.h
//  LeMang
//
//  Created by LZ on 8/25/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityViewCell : UITableViewCell
{
    NSURLConnection* connection;
    NSMutableData* imgData;
    NSURLResponse* _response;
}
@property (strong, nonatomic) IBOutlet UIImageView *activityIconImg;

- (void) SetIconImgUrl : (NSURL*)url;

@end
