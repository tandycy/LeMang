//
//  HomeDetailViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14/11/1.
//  Copyright (c) 2014年 gxcm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeDetailViewController : UIViewController
{
    NSDictionary* localData;
}
@property (strong, nonatomic) UIScrollView *DetailSroll;

- (void)SetNewsData:(NSDictionary*)data;

@end
