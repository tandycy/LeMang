//
//  IconImageViewLoaderWithButton.h
//  LeMang
//
//  Created by LZ on 9/24/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "IconImageViewLoader.h"
#import "UIImageButton.h"

@interface IconImageViewLoaderWithButton : IconImageViewLoader
{
    UIImageButton* localButton;
}

- (void) InitButton;
- (void) SetButtonSelector:(SEL)sel target:(id)target;
- (void) SetButtonImage:(UIImage*)img;

@end
